import 'package:flutter/material.dart';

// Reusable Widgets
class Button extends StatelessWidget {
  // Button 클래스가 가지게 될 프로퍼티들
  final String text;
  final Color bgColor;
  final Color textColor;

  // 생성자 함수 만들어야 함
  const Button({
    super.key,
    required this.text,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(45),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 45),
        child: Text(text, style: TextStyle(color: textColor, fontSize: 20)),
      ),
    );
  }
}
