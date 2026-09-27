import 'package:flutter/material.dart';

class MomentsScreen extends StatelessWidget {
  const MomentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Moments"), centerTitle: true),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
