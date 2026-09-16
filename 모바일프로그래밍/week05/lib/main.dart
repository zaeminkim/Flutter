import 'package:flutter/material.dart';
// 1. 패키지 임포트
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:http/http.dart';
// flutter_native_splash package
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Fluent Icons Test')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 2. 패키지 아이콘 사용
              const Text('using package fluentui'),

              const Icon(FluentIcons.flash_24_filled, size: 50, color: Colors.amber),
              const SizedBox(height: 20),

              const Icon(FluentIcons.airplane_24_regular, size: 100, color: Colors.lightBlueAccent),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}