import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 160,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF8F8FF),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Image.asset(
          'assets/images/bg_scenetrack.png',
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
        title: Image.asset(
          'assets/images/icon_scenetrack.png',
          width: 234,
          fit: BoxFit.contain,
          semanticLabel: 'SCENE TRACK',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: BoxBorder.all(
                    color: Color(0xFF858995).withValues(alpha: 0.8),
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 2,
                  children: [
                    Icon(Icons.bluetooth, size: 20, color: Color(0xFF858995)),
                    Text("Connect Glasses"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Color(0xFFEADDFF),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Column(
                    children: [
                      Icon(Icons.bluetooth_outlined, size: 50),
                      SizedBox(height: 16),
                      Text("스마트 글래스를 연결해 주세요.", style: TextStyle(fontSize: 16)),
                      Text(
                        "장면을 인식하고 어울리는 음악을 추천해 드려요.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  Text(
                    "지금 많이 듣는 음악",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Color(0xFFF7F8FC),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("순위"),
                        Text("앨범 이미지"),
                        Column(children: [Text("노래 제목"), Text("가수 이름")]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
