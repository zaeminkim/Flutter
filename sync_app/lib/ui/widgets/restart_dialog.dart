import 'package:flutter/material.dart';

enum RestartAction { retakePhoto, recommendAgain }

class RestartDialog extends StatelessWidget {
  const RestartDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // alignment: 팝업의 위치
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        child: Column(
          // 고정 높이가 아닌 요소에 따라 높이가 결정됨
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            Text(
              "플레이리스트를 다시 추천 받으시겠습니까?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            Text(
              "‘사진 다시 찍기’를 선택해 새로운 Moment를 만들거나,\n‘다시 추천 받기’를 선택해 지금 사진으로\n다른 플레이리스트를 만들어 드릴 수 있습니다.",
              style: TextStyle(color: Color(0xFF8E8E93)),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(RestartAction.retakePhoto);
                  },
                  child: const Text("사진 다시 찍기"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(RestartAction.recommendAgain);
                  },
                  child: const Text("다시 추천 받기"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
