import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sync_app/services/meta_dat_service.dart';
import 'package:sync_app/ui/routes/camera_page_route.dart';
import 'package:sync_app/ui/routes/select_image_page_route.dart';
import 'package:sync_app/ui/screens/home_select_image_screen.dart';
import 'package:sync_app/ui/widgets/camera_preview.dart';

import 'package:sync_app/ui/routes/hero_tags.dart';

class HomeCameraScreen extends StatefulWidget {
  const HomeCameraScreen({super.key});

  @override
  State<HomeCameraScreen> createState() => _HomeCameraScreenState();
}

class _HomeCameraScreenState extends State<HomeCameraScreen> {
  final MetaDatService _datService = MetaDatService.instance;

  StreamSubscription<Map<String, dynamic>>? _subscription;

  bool _isCameraReady = false;
  bool _isCapturing = false;
  bool _isOpeningCapturedImage = false;
  String? _errorMessage;
  int? _textureId;

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

    unawaited(_startCamera());
  }

  Future<void> _startCamera() async {
    await _datService.startCameraSession();
  }

  // 이벤트 처리
  void _handleDatEvent(Map<String, dynamic> event) {
    if (!mounted) return;

    switch (event['type']) {
      case 'camera':
        final rawTextureId = event['textureId'];

        setState(() {
          _isCameraReady = event['ready'] as bool? ?? false;
          _textureId = rawTextureId is num ? rawTextureId.toInt() : null;
        });
        break;

      case 'capture':
        final state = event['state'] as String?;

        if (state == 'CAPTURING') {
          setState(() {
            _isCapturing = true;
          });
        } else if (state == 'COMPLETED') {
          final path = event['path'] as String?;

          setState(() {
            _isCapturing = false;
          });

          if (path != null) {
            unawaited(_openCapturedImage(path));
          }
        }
        if (state == 'FAILED') {
          setState(() {
            _isCapturing = false;
            _errorMessage = event['message'] as String? ?? '사진 촬영에 실패했습니다.';
          });
        }
        break;

      case 'error':
        setState(() {
          _isCapturing = false;
          _errorMessage = event['message'] as String? ?? '카메라 오류가 발생했습니다.';
        });
        break;
    }
  }

  Future<void> _capturePhoto() async {
    if (!_isCameraReady || _isCapturing) return;

    try {
      await _datService.capturePhoto();
    } on PlatformException catch (error) {
      if (!mounted) return;

      setState(() {
        _isCapturing = false;
        _errorMessage = error.message ?? '사진 촬영 요청에 실패했습니다.';
      });
    }
  }

  Future<void> _openCapturedImage(String imagePath) async {
    if (_isOpeningCapturedImage || !mounted) return;

    _isOpeningCapturedImage = true;

    // PageRouteBuilder 애니메이션 적용
    // Slide Transition
    // await Navigator.of(context).push(
    //   buildCameraPageRoute<void>(HomeSelectImageScreen(imagePath: imagePath)),
    // );

    // Fade Transition
    await Navigator.of(context).push(
      buildPhotoPreviewRoute<void>(HomeSelectImageScreen(imagePath: imagePath)),
    );

    if (!mounted) return;

    _isOpeningCapturedImage = false;
  }

  Future<void> _closeCamera() async {
    await _datService.stopCameraSession();

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    unawaited(_datService.stopCameraSession());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: cameraMediaHeroTag,
              child: CameraPreview(
                textureId: _textureId,
                isReady: _isCameraReady,
              ),
            ),
            Positioned(
              top: 16,
              right: 20,
              child: IconButton.filledTonal(
                onPressed: _closeCamera,
                icon: const Icon(Icons.close),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 28,
              child: Center(
                child: GestureDetector(
                  onTap: _isCameraReady && !_isCapturing
                      ? () => unawaited(_capturePhoto())
                      : null,
                  child: Container(
                    width: 76,
                    height: 76,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _isCameraReady ? Colors.white : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isCameraReady
                            ? const Color(0xFFE7E2E8)
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (_isCapturing)
              const ColoredBox(
                color: Color(0x33000000),
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            if (_errorMessage != null)
              Positioned(
                left: 24,
                right: 24,
                bottom: 124,
                child: Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
