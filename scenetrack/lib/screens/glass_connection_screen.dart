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
              'assets/images/glasses_icon.png',
              width: double.infinity,
              height: 208,
            ),
            Text(
              _isConnected
                  ? '스마트 글래스가 연결되었어요.'
                  : _isRegistering
                  ? 'Meta AI에서 연결을 완료해 주세요.'
                  : '스마트 글래스를 연결해 주세요.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 16),
            Text(
              "지금, 당신의 시선이",
              style: TextStyle(fontSize: 18, color: Color(0xFF858995)),
            ),
            Text(
              "음악이 되는 경험을 시작합니다.",
              style: TextStyle(fontSize: 18, color: Color(0xFF858995)),
            ),
            SizedBox(height: 144),
            FilledButton(
              onPressed: _isRegistering
                  ? null
                  : () {
                      if (_isConnected) {
                        Navigator.pop(context, true);
                      } else {
                        _connectGlasses();
                      }
                    },
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
                _isConnected
                    ? '연결 완료'
                    : _isRegistering
                    ? '연결 중...'
                    : '기기 연결하기',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
