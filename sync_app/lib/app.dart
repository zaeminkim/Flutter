import 'package:flutter/material.dart';
import 'package:sync_app/ui/app_shell.dart';

// 앱 이름, 테마, 최초 화면 설정

// This widget is the root of your application.
// root widget => Material/iOS 디자인 시스템 선택
class SyncApp extends StatelessWidget {
  const SyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const AppShell(),
    );
  }
}
