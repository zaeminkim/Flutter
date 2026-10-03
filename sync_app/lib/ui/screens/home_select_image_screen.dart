import 'package:flutter/material.dart';

class HomeSelectImageScreen extends StatelessWidget {
  const HomeSelectImageScreen({super.key, required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: Column(children: [])),
    );
  }
}
