import 'package:flutter/material.dart';

// 이 코드의 Texture로 대체
class CameraPreview extends StatelessWidget {
  const CameraPreview({
    super.key,
    required this.textureId,
    required this.isReady,
  });

  final int? textureId;
  final bool isReady;

  @override
  Widget build(BuildContext context) {
    if (!isReady || textureId == null) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    } else {
      return ColoredBox(
        color: Colors.black,
        child: SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              width: 504,
              height: 896,
              child: Texture(textureId: textureId!),
            ),
          ),
        ),
      );
    }
  }
}
