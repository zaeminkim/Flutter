import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            Image.asset(
              'assets/images/glasses_icon.png',
              width: double.infinity,
            ),
            Text(
              "스마트 글래스를 연결해 주세요.",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            Text(
              "지금, 당신의 시선이 음악이 되는 경험을 시작합니다.",
              style: TextStyle(fontSize: 16, color: Color(0xFF858995)),
            ),
            SizedBox(height: 80),
            FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: Color(0xFF7D8FEF),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 64),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              child: Text(
                "기기 연결하기",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
