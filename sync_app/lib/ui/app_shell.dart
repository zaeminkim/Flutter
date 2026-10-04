import 'package:flutter/material.dart';
import 'package:sync_app/ui/screens/home_screen.dart';
import 'package:sync_app/ui/screens/moments_screen.dart';
import 'package:sync_app/ui/screens/settings_screen.dart';

// 기본적인 UI - AppBar, Body, bottomNavigationBar(네비게이션 바와 현재 탭 관리)

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  static const _screens = <Widget>[
    HomeScreen(),
    MomentsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/sync_logo.png',
          height: 40,
          // BoxFit.contain: 이미지의 가로세로 비율을 유지하면서, 주어진 영역 안에 이미지 전체가 보이도록 크기를 조절함
          fit: BoxFit.contain,
        ),
        centerTitle: true,
        toolbarHeight: 100,
      ),
      // IndexedStack: 탭을 바꿔도 이전 탭의 상태를 유지
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.transparent,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
            debugPrint("네비게이션 바 클릭");
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: "Home",
            selectedIcon: Icon(Icons.home),
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border),
            label: "Moments",
            selectedIcon: Icon(Icons.bookmark_outlined),
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: "Settings",
            selectedIcon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
