import 'package:flutter/material.dart';

class HomeCameraScreen extends StatelessWidget {
  const HomeCameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(child: Text("Camera")),
    );
  }
}
