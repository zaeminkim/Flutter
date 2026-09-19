import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

// Stateful Widget = Widget + State
// Widget: 모두 State를 가지고 있음
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

// State: Widget의 데이터와 UI 저장함
class _AppState extends State<App> {
  int counter = 0; // final이 아님, 값을 변경할 수 있도록 함

  void onClicked() {
    // setState()는 State Class에게 데이터가 변경되었다고 알리는 함수
    // 그리고 build 메소드를 한 번 더 호출함 (다시 렌더링)
    setState(() {
      counter += 1;
    });
  }

  // This widget is the root of your application.
  // build method
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFF4EDDB),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Click Count', style: TextStyle(fontSize: 30)),
              Text('$counter', style: const TextStyle(fontSize: 30)),
              IconButton(
                iconSize: 40,
                onPressed: onClicked,
                icon: Icon(Icons.add_box_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
