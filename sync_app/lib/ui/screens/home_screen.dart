import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sync_app/models/sync_api_models.dart';
import 'package:sync_app/services/meta_dat_service.dart';
import 'package:sync_app/services/sync_api_service.dart';
import 'package:sync_app/services/sync_auth_service.dart';
import 'package:sync_app/ui/contents/home_analysis_error_content.dart';
import 'package:sync_app/ui/contents/home_analyzing_content.dart';
import 'package:sync_app/ui/contents/home_playing_content.dart';
import 'package:sync_app/ui/contents/home_playlist_content.dart';
import 'package:sync_app/ui/contents/home_setup_content.dart';
import 'package:sync_app/ui/routes/camera_page_route.dart';
import 'package:sync_app/ui/screens/home_camera_screen.dart';
import 'package:sync_app/ui/screens/home_phase.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MetaDatService _datService = MetaDatService.instance;
  final SyncApiService _api = SyncApiService();
  final AppLinks _appLinks = AppLinks();

  late final SyncAuthService _auth = SyncAuthService(api: _api);
  StreamSubscription<Map<String, dynamic>>? _datSubscription;
  StreamSubscription<Uri>? _appLinkSubscription;

  HomePhase _phase = HomePhase.setup;
  String _registrationState = 'AVAILABLE';
  bool _hasActiveDevice = false;
  bool? _hasCameraPermission;
  bool _isRequestingCameraPermission = false;
  bool _isSavingPlaylist = false;
  bool _pendingPlaylistSave = false;
  String? _errorMessage;
  String? _playlistStatusMessage;
  String? _capturedImagePath;
  DirectRecommendation? _recommendation;
  CreatedPlaylist? _createdPlaylist;

  bool get _isRegistering => _registrationState == 'REGISTERING';
  bool get _isConnected =>
      _registrationState == 'REGISTERED' && _hasActiveDevice;

  @override
  void initState() {
    super.initState();
    _datSubscription = _datService.events.listen(
      _handleDatEvent,
      onError: (Object error) {
        if (!mounted) return;
        setState(() {
          _isRequestingCameraPermission = false;
          _errorMessage = error.toString();
        });
      },
    );
    _appLinkSubscription = _appLinks.uriLinkStream.listen(
      (uri) => unawaited(_handleAppLink(uri)),
      onError: (Object error) {
        if (!mounted) return;
        setState(() {
          _isSavingPlaylist = false;
          _errorMessage = '로그인 완료 링크를 처리하지 못했습니다.';
        });
      },
    );
  }

  void _handleDatEvent(Map<String, dynamic> event) {
    if (!mounted) return;

    switch (event['type']) {
      case 'registration':
        setState(() {
          _registrationState = event['state'] as String? ?? 'AVAILABLE';
          _errorMessage = null;
        });
        break;
      case 'device':
        setState(() {
          _hasActiveDevice = event['hasActiveDevice'] as bool? ?? false;
        });
        break;
      case 'CAMERA_PERMISSION':
        setState(() {
          _isRequestingCameraPermission = false;
          _hasCameraPermission = event['granted'] as bool? ?? false;
          _errorMessage = event['message'] as String?;
        });
        break;
      case 'error':
        setState(() {
          _isRequestingCameraPermission = false;
          _errorMessage = event['message'] as String? ?? '처리 중 오류가 발생했습니다.';
        });
        break;
    }
  }

  Future<void> _openCameraScreen() async {
    final imagePath = await Navigator.of(
      context,
    ).push<String>(buildCameraPageRoute<String>(const HomeCameraScreen()));

    if (!mounted || imagePath == null) return;
    await _analyzeImage(imagePath);
  }

  Future<void> _analyzeImage(String imagePath) async {
    setState(() {
      _capturedImagePath = imagePath;
      _recommendation = null;
      _createdPlaylist = null;
      _errorMessage = null;
      _playlistStatusMessage = null;
      _phase = HomePhase.analyzing;
    });

    try {
      final result = await _api.recommendDirect(
        imagePath,
        requestId: 'android_${DateTime.now().microsecondsSinceEpoch}',
      );
      if (!mounted) return;
      setState(() {
        _recommendation = result;
        _phase = HomePhase.playlist;
      });
    } on SyncApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = _friendlyApiMessage(error);
        _phase = HomePhase.analysisError;
      });
    } on TimeoutException {
      if (!mounted) return;
      setState(() {
        _errorMessage = '추천 요청 시간이 초과되었습니다. 잠시 후 다시 시도해 주세요.';
        _phase = HomePhase.analysisError;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = '서버에 연결하지 못했습니다. 네트워크 상태를 확인해 주세요.';
        _phase = HomePhase.analysisError;
      });
    }
  }

  Future<void> _handlePrimaryAction() async {
    setState(() => _errorMessage = null);

    try {
      if (!_isConnected) {
        await _datService.startRegistration();
        return;
      }
      if (_hasCameraPermission != true) {
        setState(() => _isRequestingCameraPermission = true);
        await _datService.requestCameraPermission();
        return;
      }
      await _openCameraScreen();
    } on PlatformException catch (error) {
      if (!mounted) return;
      setState(() {
        _isRequestingCameraPermission = false;
        _errorMessage = error.message ?? '요청을 처리하지 못했습니다.';
      });
    }
  }

  Future<void> _savePlaylist() async {
    final recommendation = _recommendation;
    if (recommendation == null || _isSavingPlaylist) return;

    setState(() {
      _isSavingPlaylist = true;
      _errorMessage = null;
      _playlistStatusMessage = null;
    });

    try {
      final token = await _auth.readValidSessionToken();
      if (token == null) {
        await _startGoogleConnection();
        return;
      }

      final status = await _api.getGoogleStatus(token);
      if (!status.connected) {
        await _auth.clearSession();
        await _startGoogleConnection();
        return;
      }
      await _createPlaylist(token);
    } on SyncApiException catch (error) {
      if (error.isAuthenticationError) {
        await _auth.clearSession();
        await _startGoogleConnection();
        return;
      }
      _showPlaylistError(_friendlyApiMessage(error));
    } on TimeoutException {
      _showPlaylistError('요청 시간이 초과되었습니다. 잠시 후 다시 시도해 주세요.');
    } catch (_) {
      _showPlaylistError('서버에 연결하지 못했습니다. 네트워크 상태를 확인해 주세요.');
    }
  }

  Future<void> _startGoogleConnection() async {
    _pendingPlaylistSave = true;
    try {
      await _auth.beginGoogleConnection();
      if (!mounted) return;
      setState(() {
        _isSavingPlaylist = false;
        _playlistStatusMessage = '브라우저에서 Google 로그인을 완료하면 자동으로 저장됩니다.';
      });
    } on SyncApiException catch (error) {
      _pendingPlaylistSave = false;
      _showPlaylistError(_friendlyApiMessage(error));
    } catch (_) {
      _pendingPlaylistSave = false;
      _showPlaylistError('Google 로그인 화면을 열지 못했습니다.');
    }
  }

  Future<void> _handleAppLink(Uri uri) async {
    if (uri.host != 'sync-backend-c2lv.onrender.com' ||
        uri.path != '/auth/android/complete') {
      return;
    }

    if (mounted) {
      setState(() {
        _isSavingPlaylist = true;
        _errorMessage = null;
        _playlistStatusMessage = 'Google 연결을 확인하고 있어요.';
      });
    }

    try {
      final session = await _auth.completeGoogleConnection(uri);
      if (!mounted) return;

      if (_pendingPlaylistSave && _recommendation != null) {
        _pendingPlaylistSave = false;
        await _createPlaylist(session.sessionToken);
      } else {
        setState(() {
          _isSavingPlaylist = false;
          _playlistStatusMessage = 'Google 계정이 연결되었습니다.';
        });
      }
    } on SyncApiException catch (error) {
      _pendingPlaylistSave = false;
      _showPlaylistError(_friendlyApiMessage(error));
    } catch (_) {
      _pendingPlaylistSave = false;
      _showPlaylistError('로그인 완료 정보를 처리하지 못했습니다.');
    }
  }

  Future<void> _createPlaylist(String token) async {
    final recommendation = _recommendation!;
    final created = await _api.createPlaylist(
      sessionToken: token,
      recommendationId: recommendation.recommendationId,
      title: recommendation.playlistTitle,
    );
    if (!mounted) return;

    setState(() {
      _createdPlaylist = created;
      _isSavingPlaylist = false;
      _playlistStatusMessage = null;
      _phase = HomePhase.playing;
    });

    await launchUrl(
      created.youtubeMusicUrl,
      mode: LaunchMode.externalApplication,
    );
  }

  void _showPlaylistError(String message) {
    if (!mounted) return;
    setState(() {
      _isSavingPlaylist = false;
      _playlistStatusMessage = null;
      _errorMessage = message;
    });
  }

  String _friendlyApiMessage(SyncApiException error) {
    switch (error.code) {
      case 'DIRECT_RECOMMENDATION_UNAVAILABLE':
        return '서버의 추천 기능이 아직 활성화되지 않았습니다. 백엔드 설정을 확인해 주세요.';
      case 'IMAGE_TOO_LARGE':
        return '이미지 크기는 10MB 이하여야 합니다.';
      case 'UNSUPPORTED_IMAGE_TYPE':
      case 'UNSUPPORTED_CONTENT_TYPE':
        return 'JPEG, PNG 또는 WebP 이미지만 사용할 수 있습니다.';
      case 'RECOMMENDATION_EXPIRED':
      case 'RECOMMENDATION_NOT_FOUND':
        return '추천 정보가 만료되었습니다. 사진을 다시 분석해 주세요.';
      case 'NO_VERIFIED_TRACKS':
        return '저장할 수 있는 검증된 추천곡이 없습니다.';
      case 'MOBILE_AUTH_UNAVAILABLE':
        return '서버의 모바일 Google 로그인이 아직 설정되지 않았습니다.';
      case 'YOUTUBE_QUOTA_EXCEEDED':
        return 'YouTube 요청 한도를 초과했습니다. 잠시 후 다시 시도해 주세요.';
      default:
        return error.message;
    }
  }

  String get _buttonLabel {
    if (_isRegistering) return '스마트글래스 연결 중...';
    if (_registrationState == 'REGISTERED' && !_hasActiveDevice) {
      return '스마트글래스 확인 중...';
    }
    if (!_isConnected) return '스마트글래스 연결하기';
    if (_hasCameraPermission == null) return '카메라 권한 확인 중...';
    if (_hasCameraPermission == false) {
      return _isRequestingCameraPermission ? '카메라 권한 요청 중...' : '카메라 권한 허용하기';
    }
    return '사진 찍기';
  }

  bool get _buttonEnabled {
    if (_isRegistering || _isRequestingCameraPermission) return false;
    if (_registrationState == 'REGISTERED' && !_hasActiveDevice) return false;
    if (_isConnected && _hasCameraPermission == null) return false;
    return true;
  }

  @override
  void dispose() {
    _datSubscription?.cancel();
    _appLinkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: _buildCurrentContent());
  }

  Widget _buildCurrentContent() {
    switch (_phase) {
      case HomePhase.setup:
        return HomeSetupContent(
          isConnected: _isConnected,
          hasCameraPermission: _hasCameraPermission == true,
          buttonLabel: _buttonLabel,
          onPrimaryPressed: _buttonEnabled
              ? () => unawaited(_handlePrimaryAction())
              : null,
          errorMessage: _errorMessage,
        );
      case HomePhase.analyzing:
        return HomeAnalyzingContent(imagePath: _capturedImagePath!);
      case HomePhase.analysisError:
        return HomeAnalysisErrorContent(
          imagePath: _capturedImagePath!,
          message: _errorMessage ?? '분석하지 못했습니다.',
          onRetryPressed: () => unawaited(_analyzeImage(_capturedImagePath!)),
          onRetakePressed: () => unawaited(_openCameraScreen()),
        );
      case HomePhase.playlist:
        return HomePlaylistContent(
          imagePath: _capturedImagePath!,
          recommendation: _recommendation!,
          onRetakePressed: () => unawaited(_openCameraScreen()),
          onSavePressed: () => unawaited(_savePlaylist()),
          isSaving: _isSavingPlaylist,
          errorMessage: _errorMessage,
          statusMessage: _playlistStatusMessage,
        );
      case HomePhase.playing:
        return HomePlayingContent(
          isConnected: _isConnected,
          imagePath: _capturedImagePath!,
          recommendation: _recommendation!,
          playlist: _createdPlaylist!,
          onRetakePressed: () => unawaited(_openCameraScreen()),
          onRecommendAgainPressed: () =>
              unawaited(_analyzeImage(_capturedImagePath!)),
          onOpenYoutubeMusic: () => unawaited(
            launchUrl(
              _createdPlaylist!.youtubeMusicUrl,
              mode: LaunchMode.externalApplication,
            ),
          ),
        );
    }
  }
}
