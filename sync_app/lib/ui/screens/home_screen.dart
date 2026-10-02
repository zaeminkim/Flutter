import 'package:flutter/material.dart';
import 'package:sync_app/ui/widgets/primary_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // SafeArea: 콘텐츠가 휴대폰의 노치, 상태 표시줄, 카메라 홀, 제스처 바 등에 가려지지 않도록 자동으로 여백을 추가하는 위젯
    // 주로 Body에 사용함
    return SafeArea(
      // ListView: Column보다는 스크롤이 가능한 ListView 사용하기
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF49454F).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            // Row: 자동 width 채우기 성질
            child: Row(
              children: [
                Icon(Icons.bluetooth, color: Color(0xFF49454F)),
                const SizedBox(width: 12),
                // Expanded: 자식위젯이 자동으로 남는 구간을 모두 차지함
                Expanded(
                  child: Text(
                    "기기가 연결되지 않았어요.",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    debugPrint("연결하기 버튼 클릭");
                  },
                  child: Text(
                    "연결하기",
                    style: TextStyle(color: Color(0xFF6750A4), fontSize: 14),
                  ),
                ),
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
              CircleAvatar(
                radius: 14,
                backgroundColor: Color(0xFFE8E4EC),
                child: Text(
                  '1',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
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
              CircleAvatar(
                radius: 14,
                backgroundColor: Color(0xFFE8E4EC),
                child: Text(
                  '2',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
              CircleAvatar(
                radius: 14,
                backgroundColor: Color(0xFFE8E4EC),
                child: Text(
                  '3',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Text(
                '사진 찍기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            label: "스마트글래스 연결하기",
            onPressed: () {
              debugPrint("스마트 글래스 연결하기 버튼 클릭");
            },
          ),
        ],
      ),
    );
  }
}
