import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool showTitle = true;

  void toggleTitle() {
    setState(() {
      showTitle = !showTitle;
    });
  }

  // This widget is the root of your application.
  // build method
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Theme 만들기
      theme: ThemeData(
        textTheme: TextTheme(titleLarge: TextStyle(color: Colors.red)),
      ),
      home: Scaffold(
        backgroundColor: const Color(0xFFF4EDDB),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              showTitle
                  ? MyLargeTitle()
                  : Text("Nothing", style: TextStyle(fontSize: 30)),
              IconButton(
                onPressed: toggleTitle,
                icon: Icon(Icons.remove_red_eye),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyLargeTitle extends StatefulWidget {
  const MyLargeTitle({super.key});

  @override
  State<MyLargeTitle> createState() => _MyLargeTitleState();
}

class _MyLargeTitleState extends State<MyLargeTitle> {
  // initState 메소드
  // 초기화, 항상 build 메소드보다 먼저 호출되어야 함
  @override
  void initState() {
    super.initState();
    print("initState");
  }

  // dispose 메소드
  // 위젯이 스크린에서 제거될 때 호출됨
  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  // build 메소드
  @override
  Widget build(BuildContext context) {
    print("build");
    // Text의 모든 부모 요소들에 대한 정보를 담고 있다
    return Text(
      'My Large Title',
      style: TextStyle(
        fontSize: 30,
        color: Theme.of(context).textTheme.titleLarge?.color,
        // Theme이라는 위젯이 제공한 ThemeData 객체 안의 textTheme 프로퍼티(값)가 가진 titleLarge 슬롯에 정의된 TextStyle 객체의 color 프로퍼티를 사용한다.
      ),
    );
  }
}
