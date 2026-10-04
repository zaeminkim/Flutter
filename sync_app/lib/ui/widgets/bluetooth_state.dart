import 'package:flutter/material.dart';

class BluetoothState extends StatelessWidget {
  const BluetoothState({
    super.key,
    required this.isConnected,
  });

  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            color: !isConnected ? Color(0xFF49454F) : Color(0xFF6750A4),
          ),
          const SizedBox(width: 8),
          // Expanded: 자식위젯이 자동으로 남는 구간을 모두 차지함
          Text(
            !isConnected ? "기기가 연결되지 않았어요." : "Ray-Ban Meta",
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
    );
  }
}