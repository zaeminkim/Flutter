import 'package:flutter/material.dart';
import 'package:scenetrack/screens/home_screen.dart';
import 'package:scenetrack/screens/moments_screen.dart';
import 'package:scenetrack/screens/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPageIndex = 0;

  final List<Widget> pages = const [
    HomeScreen(),
    MomentsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        // indicatorColor: Colors.transparent,
        selectedIndex: currentPageIndex,
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
      body: IndexedStack(index: currentPageIndex, children: pages),
    );
  }
}
