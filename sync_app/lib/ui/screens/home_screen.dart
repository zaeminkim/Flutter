import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sync_app/services/meta_dat_service.dart';
import 'package:sync_app/ui/screens/home_camera_screen.dart';
import 'package:sync_app/ui/widgets/primary_button.dart';

import 'package:sync_app/ui/routes/camera_page_route.dart';

// HomeScreen class (Widget): 화면을 나타내는 Widget 설정
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  // CreateState(): HomeScreen을 화면에 표시할 때, _HomeScreenState이라는 상태객체를 만들어서 사용해라
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// _HomeScreen class (State): 변하는 데이터와 실제 UI 관리
class _HomeScreenState extends State<HomeScreen> {
  // DAT 서비스 객체: Flutter가 Android Native DAT 코드와 통신
  final MetaDatService _datService = MetaDatService.instance;

  // 이벤트 구독 객체(_subscription): DAT에서 들어오는 이벤트를 계속 듣기 위한 객체(Stream)
  // 'type': 'registration', 'state': 'REGISTERED', ...
  StreamSubscription<Map<String, dynamic>>? _subscription;

  // _registrationState: 등록상태
  String _registrationState = 'AVAILABLE';
  // _hasActiveDevice: 활성 기기 존재여부
  bool _hasActiveDevice = false;
  // _hasCameraPermission: 카메라 권한 상태
  bool? _hasCameraPermission;
  // _isRequestingCameraPermission: 카메라 권한 요청 진행여부
  bool _isRequestingCameraPermission = false;
  // _errorMessage: 에러 메시지
  String? _errorMessage;

  // _isRegistering: getter함수
  bool get _isRegistering => _registrationState == 'REGISTERING';
  // _isConnected
  bool get _isConnected =>
      _registrationState == 'REGISTERED' && _hasActiveDevice;

  @override
  // initState()는 State 객체가 처음 생성될 때 최초 한 번만 실행됨
  // initState()에서 이벤트 듣기
  void initState() {
    super.initState();

    _subscription = _datService.events.listen(
      _handleDatEvent,
      onError: (Object error) {
        if (!mounted) return;

        setState(() {
          _isRequestingCameraPermission = false;
          _errorMessage = error.toString();
        });
      },
    );
  }

  // _handleDatEvent: DAT 이벤트 처리 함수
  void _handleDatEvent(Map<String, dynamic> event) {
    // mounted: 이 State가 현재 화면 트리에 붙어 있는지 확인
    // !mounted = 화면이 존재하지 않는다
    if (!mounted) return;

    switch (event['type']) {
      case 'registration':
        // setState() 안에서 상태값을 바꾸면 Flutter가 build()를 다시 실행함
        setState(() {
          // .. as String? = ..을 String 혹은 null로 취급해라
          // A ?? B = A가 null이면 B 사용, A가 null이 아니면 A 사용
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

  // HomeCameraScreen()으로 이동 -> PageRouteBuilder 사용
  Future<void> _openCameraScreen() async {
    // AppShell에 별도의 내부 Navigator가 없기 때문에
    // appBar와 bottomNavigationBar를 덮는 전체 화면 route가 열림
    await Navigator.of(
      context,
    ).push(buildCameraPageRoute(const HomeCameraScreen()));
  }

  // _handlePrimaryAction: 버튼 클릭 함수
  // Future: 결과가 나중에 완료됨, async/await: 비동기 함수
  Future<void> _handlePrimaryAction() async {
    setState(() {
      _errorMessage = null;
    });

    try {
      if (!_isConnected) {
        await _datService.startRegistration();
        return;
      }

      if (_hasCameraPermission != true) {
        setState(() {
          _isRequestingCameraPermission = true;
        });

        await _datService.requestCameraPermission();
        return;
      }

      await _openCameraScreen();
    } on PlatformException catch (error) {
      if (!mounted) return;

      setState(() {
        _isRequestingCameraPermission = false;
        _errorMessage = error.message ?? "요청을 처리하지 못했습니다.";
      });
    }
  }

  String get _buttonLabel {
    if (_isRegistering) {
      return '스마트글래스 연결 중...';
    }

    if (_registrationState == 'REGISTERED' && !_hasActiveDevice) {
      return '스마트글래스 확인 중...';
    }

    if (!_isConnected) {
      return '스마트글래스 연결하기';
    }

    if (_hasCameraPermission == null) {
      return '카메라 권한 확인 중...';
    }

    if (_hasCameraPermission == false) {
      return _isRequestingCameraPermission ? '카메라 권한 요청 중...' : '카메라 권한 허용하기';
    }

    return '사진 찍기';
  }

  bool get _buttonEnabled {
    if (_isRegistering || _isRequestingCameraPermission) {
      return false;
    }

    if (_registrationState == 'REGISTERED' && !_hasActiveDevice) {
      return false;
    }

    if (_isConnected && _hasCameraPermission == null) {
      return false;
    }

    return true;
  }

  Widget _buildStepIndicator({required int number, required bool completed}) {
    if (completed) {
      return const Icon(Icons.check_circle, size: 28, color: Color(0xFF6750A4));
    }

    return CircleAvatar(
      radius: 14,
      backgroundColor: const Color(0xFFE8E4EC),
      child: Text(
        '$number',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // SafeArea: 콘텐츠가 휴대폰의 노치, 상태 표시줄, 카메라 홀, 제스처 바 등에 가려지지 않도록 자동으로 여백을 추가하는 위젯
    // -> 주로 Body에 사용함
    return SafeArea(
      // ListView: Column보다는 스크롤이 가능한 ListView 사용하기
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFF49454F).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            // Row: 자동 width 채우기 성질
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bluetooth,
                  color: !_isConnected ? Color(0xFF49454F) : Color(0xFF6750A4),
                ),
                const SizedBox(width: 8),
                // Expanded: 자식위젯이 자동으로 남는 구간을 모두 차지함
                Text(
                  !_isConnected ? "기기가 연결되지 않았어요." : "Ray-Ban Meta",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                // TextButton(
                //   onPressed: () {
                //     debugPrint("연결하기 버튼 클릭");
                //   },
                //   child: Text(
                //     "연결하기",
                //     style: TextStyle(color: Color(0xFF6750A4), fontSize: 14),
                //   ),
                // ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "지금 보고 있는 장면에\n음악을 더해보세요.",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "사진을 찍으면 싱크가 어울리는 음악을 찾아드려요.",
            style: TextStyle(color: Color(0xFF8E8E93), fontSize: 14),
          ),
          const SizedBox(height: 48),
          Row(
            children: [
              _buildStepIndicator(number: 1, completed: _isConnected),
              SizedBox(width: 16),
              Text(
                '스마트글래스 연결하기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStepIndicator(
                number: 2,
                completed: _isConnected && _hasCameraPermission == true,
              ),
              SizedBox(width: 16),
              Text(
                '카메라 권한 허용하기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStepIndicator(number: 3, completed: false),
              SizedBox(width: 16),
              Text(
                '사진 찍기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            label: _buttonLabel,
            onPressed: _buttonEnabled
                ? () {
                    debugPrint("PrimaryButton 클릭");
                    _handlePrimaryAction();
                  }
                : null,
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ],
      ),
    );
  }
}
