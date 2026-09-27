import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scenetrack/services/meta_dat_service.dart';
import 'package:flutter/services.dart';

class GlassConnectionScreen extends StatefulWidget {
  const GlassConnectionScreen({super.key});

  @override
  State<GlassConnectionScreen> createState() => _GlassConnectionScreenState();
}

class _GlassConnectionScreenState extends State<GlassConnectionScreen> {
  final MetaDatService _datService = MetaDatService.instance;

  StreamSubscription<Map<String, dynamic>>? _subscription;

  String _registrationState = "AVAILABLE";
  bool _hasActiveDevice = false;
  bool _isRequestingCameraPermission = false;
  bool? _hasCameraPermission;
  String? _errorMessage;

  bool get _isRegistering => _registrationState == 'REGISTERING';

  bool get _isConnected {
    return _registrationState == 'REGISTERED' && _hasActiveDevice;
  }

  @override
  void initState() {
    super.initState();

    _subscription = _datService.events.listen(
      _handleDatEvent,
      onError: (Object error) {
        if (!mounted) return;

        setState(() {
          _errorMessage = error.toString();
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

      case 'device':
        setState(() {
          _hasActiveDevice = event['hasActiveDevice'] as bool? ?? false;
        });

      case 'CAMERA_PERMISSION':
        setState(() {
          _isRequestingCameraPermission = false;
          _hasCameraPermission = event['granted'] as bool? ?? false;
          final isSnapshot = event['isSnapshot'] as bool? ?? false;
          final message = event['message'] as String?;

          _errorMessage =
              message ??
              (_hasCameraPermission == true || isSnapshot
                  ? null
                  : 'Meta AI에서 카메라 권한을 허용해 주세요.');
        });
        break;

      case 'error':
        setState(() {
          _errorMessage = event['message'] as String? ?? '연결 중 오류가 발생했습니다.';
        });
    }
  }

  Future<void> _connectGlasses() async {
    setState(() {
      _errorMessage = null;
    });

    try {
      await _datService.startRegistration();
    } on PlatformException catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = error.message ?? '연결을 시작하지 못했습니다.';
      });
    }
  }

  Future<void> _requestCameraPermission() async {
    setState(() {
      _isRequestingCameraPermission = true;
      _errorMessage = null;
    });

    try {
      await _datService.requestCameraPermission();
    } on PlatformException catch (error) {
      if (!mounted) return;

      setState(() {
        _isRequestingCameraPermission = false;
        _errorMessage = error.message ?? '카메라 권한을 요청하지 못했습니다.';
      });
    }
  }

  Future<void> _handleMainButton() async {
    if (_registrationState != 'REGISTERED') {
      await _connectGlasses();
      return;
    }

    if (!_hasActiveDevice) {
      setState(() {
        _errorMessage =
            'SceneTrack 등록은 완료되었습니다. '
            '글래스가 켜져 있고 가까이 있는지 확인해 주세요.';
      });
      return;
    }

    if (_hasCameraPermission != true) {
      await _requestCameraPermission();
      return;
    }

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connection"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 104),
            Image.asset(
              _isConnected && _hasCameraPermission == true
                  ? 'assets/images/check_icon.png'
                  : 'assets/images/glasses_icon.png',
              width: double.infinity,
              height: 208,
            ),
            Text(
              !_isConnected
                  ? '스마트 글래스를 연결해 주세요.'
                  : _hasCameraPermission == null
                  ? '연결 상태를 확인하고 있어요.'
                  : _hasCameraPermission == false
                  ? '카메라 권한을 허용해 주세요.'
                  : '연결이 완료되었어요!',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 16),
            Text(
              _isConnected && _hasCameraPermission == true
                  ? "이제 바라보는 장면을 인식하고"
                  : "지금, 당신의 시선이",
              style: TextStyle(fontSize: 18, color: Color(0xFF858995)),
            ),
            Text(
              _isConnected && _hasCameraPermission == true
                  ? "음악을 추천할 수 있어요."
                  : "음악이 되는 경험을 시작합니다.",
              style: TextStyle(fontSize: 18, color: Color(0xFF858995)),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            SizedBox(height: 144),
            FilledButton(
              onPressed:
                  _isRegistering ||
                      _isRequestingCameraPermission ||
                      (_isConnected && _hasCameraPermission == null)
                  ? null
                  : _handleMainButton,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF7D8FEF),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFB8B8B8),
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 64,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                !_isConnected
                    ? (_isRegistering ? '연결 중...' : '기기 연결하기')
                    : _hasCameraPermission == null
                    ? '연결 상태 확인 중...'
                    : _hasCameraPermission == false
                    ? (_isRequestingCameraPermission
                          ? '권한 승인 중...'
                          : '카메라 허용하기')
                    : '연결 완료',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
