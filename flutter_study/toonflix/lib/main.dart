import 'package:flutter/material.dart';
import 'package:toonflix/screens/home_screen.dart';
//import 'package:toonflix/services/api_service.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key}); // widget은 ID처럼 쓰이는 key를 가지고 있음 - 위젯식별용

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}
