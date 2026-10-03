import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  // VoidCallback: 매개변수와 반환값이 없는 함수, null도 허용함
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    // FilledButton: 일반적인 button widget
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: TextStyle(fontSize: 16),
      ),
      child: Text(label),
    );
  }
}
