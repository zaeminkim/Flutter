import 'package:flutter/material.dart';
import 'package:scenetrack/screens/glass_connection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isGlassesConnected = false;

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
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      offset: Offset(4, 4),
                      color: Colors.black.withValues(alpha: 0.1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 2,
                  children: [
                    Icon(
                      Icons.bluetooth,
                      size: 20,
                      color: _isGlassesConnected
                          ? Color(0xFF7D8FEF)
                          : Color(0xFF858995),
                    ),
                    Text(
                      _isGlassesConnected
                          ? "Glasses Connected"
                          : "Connect Glasses",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            GestureDetector(
              onTap: () async {
                final connected = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GlassConnectionScreen(),
                  ),
                );

                if (connected == true) {
                  setState(() {
                    _isGlassesConnected = true;
                  });
                }
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Color(0xFFEADDFF),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      offset: Offset(4, 4),
                      color: Colors.black.withValues(alpha: 0.1),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Column(
                    children: [
                      Icon(Icons.bluetooth_outlined, size: 50),
                      SizedBox(height: 16),
                      Text(
                        _isGlassesConnected
                            ? "스마트 글래스가 연결되었어요."
                            : "스마트 글래스를 연결해 주세요.",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "장면을 인식하고 어울리는 음악을 추천해 드려요.",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
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
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    offset: Offset(4, 4),
                    color: Colors.black.withValues(alpha: 0.1),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  Text(
                    "지금 많이 듣는 음악",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Color(0xFFF7F8FC),
                    ),
                    child: Row(
                      spacing: 8,
                      children: [
                        Text("순위"),
                        Text("앨범 이미지"),
                        SizedBox(width: 64),
                        Column(children: [Text("노래 제목"), Text("가수 이름")]),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Color(0xFFF7F8FC),
                    ),
                    child: Row(
                      spacing: 8,
                      children: [
                        Text("순위"),
                        Text("앨범 이미지"),
                        SizedBox(width: 64),
                        Column(children: [Text("노래 제목"), Text("가수 이름")]),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Color(0xFFF7F8FC),
                    ),
                    child: Row(
                      spacing: 8,
                      children: [
                        Text("순위"),
                        Text("앨범 이미지"),
                        SizedBox(width: 64),
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
