import 'package:flutter/material.dart';
import 'package:sync_app/ui/widgets/bluetooth_state.dart';
import 'package:sync_app/ui/widgets/primary_button.dart';

class HomeSetupContent extends StatelessWidget {
  const HomeSetupContent({
    super.key,
    required this.isConnected,
    required this.hasCameraPermission,
    required this.buttonLabel,
    required this.onPrimaryPressed,
    this.errorMessage,
  });

  final bool isConnected;
  final bool hasCameraPermission;
  final String buttonLabel;
  final VoidCallback? onPrimaryPressed;
  final String? errorMessage;

  Widget _buildStepIndicator({required int number, required bool completed}) {
    if (completed) {
      return const Icon(
        Icons.check_circle_sharp,
        size: 28,
        color: Color(0xFF6750A4),
      );
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
  Widget build(BuildContext context) {
    return
    // ListView: Column보다는 스크롤이 가능한 ListView 사용하기
    ListView(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      children: [
        BluetoothState(isConnected: isConnected),
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
            _buildStepIndicator(number: 1, completed: isConnected),
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
              completed: isConnected && hasCameraPermission == true,
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
        PrimaryButton(label: buttonLabel, onPressed: onPrimaryPressed),

        if (errorMessage != null) ...[
          const SizedBox(height: 12),
          Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ],
    );
  }
}
