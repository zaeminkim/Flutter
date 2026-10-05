import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

class HomeAnalyzingContent extends StatefulWidget {
  const HomeAnalyzingContent({super.key, required this.imagePath});

  final String imagePath;

  @override
  State<HomeAnalyzingContent> createState() => _HomeAnalyzingContentState();
}

class _HomeAnalyzingContentState extends State<HomeAnalyzingContent> {
  static const _messages = [
    '사진의 분위기를 분석하고 있어요',
    '어울리는 음악을 찾고 있어요',
    '플레이리스트를 만들고 있어요',
  ];

  Timer? _timer;
  int _messageIndex = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      setState(() {
        _messageIndex = (_messageIndex + 1) % _messages.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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
              child: Image.file(File(widget.imagePath), fit: BoxFit.cover),
            ),
          ),
        ),
        const SizedBox(height: 56),
        const Center(child: CircularProgressIndicator()),
        const SizedBox(height: 24),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _messages[_messageIndex],
            key: ValueKey(_messageIndex),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
