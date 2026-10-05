import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sync_app/ui/widgets/primary_button.dart';
import 'package:sync_app/ui/widgets/secondary_button.dart';

class HomeAnalysisErrorContent extends StatelessWidget {
  const HomeAnalysisErrorContent({
    super.key,
    required this.imagePath,
    required this.message,
    required this.onRetryPressed,
    required this.onRetakePressed,
  });

  final String imagePath;
  final String message;
  final VoidCallback onRetryPressed;
  final VoidCallback onRetakePressed;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      children: [
        SizedBox(
          height: 284,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: RotatedBox(
              quarterTurns: 1,
              child: Image.file(File(imagePath), fit: BoxFit.cover),
            ),
          ),
        ),
        const SizedBox(height: 32),
        const Icon(Icons.error_outline, size: 44, color: Colors.redAccent),
        const SizedBox(height: 12),
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 24),
        PrimaryButton(label: '다시 분석하기', onPressed: onRetryPressed),
        const SizedBox(height: 8),
        SecondaryButton(label: '다시 촬영하기', onPressed: onRetakePressed),
      ],
    );
  }
}
