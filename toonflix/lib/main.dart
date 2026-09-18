import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

// Widget을 만든다 = class를 만든다
// flutter SDK의 3개의 core Widget 중 하나를 상속 받아야 함
class App extends StatelessWidget {
  // Widget을 만들기 위해선 build 메소드를 구현해야 함
  // return MaterialApp or return CupertinoApp
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Scaffold: 화면의 구성 및 구조에 관한 Widget
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hello Flutter!'),
          centerTitle: true,
          backgroundColor: Colors.blue,
          elevation: 9,
          shadowColor: Colors.red,
        ),
        body: Center(child: Text('Hello World!')),
      ),
    );
  }
} 
// 이 App Widget이 우리 앱을 시작할 때 뜨는 첫번째 widget이기 때문에 앱의 Root이다
// Root는 Material 디자인과 iOS 디자인 중 하나를 선택해야 함.