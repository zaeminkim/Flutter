import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sync_app/ui/widgets/primary_button.dart';
import 'package:sync_app/ui/widgets/secondary_button.dart';

import 'package:sync_app/ui/routes/hero_tags.dart';

class HomeSelectImageScreen extends StatelessWidget {
  const HomeSelectImageScreen({super.key, required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
          children: [
            Hero(
              tag: cameraMediaHeroTag,
              child: RotatedBox(
                quarterTurns: 1,
                child: Image.file(File(imagePath), fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                spacing: 8,
                children: [
                  PrimaryButton(label: "이 장면 분석하기", onPressed: () {}),
                  SecondaryButton(
                    label: "다시 촬영하기",
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
