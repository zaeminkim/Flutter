import 'dart:io';
// File()을 제공함

import 'package:flutter/material.dart';
import 'package:sync_app/ui/widgets/modal_bottom_sheet.dart';
import 'package:sync_app/ui/widgets/primary_button.dart';
import 'package:sync_app/ui/widgets/secondary_button.dart';

class HomePlaylistContent extends StatelessWidget {
  const HomePlaylistContent({
    super.key,
    required this.imagePath,
    // 사진을 다시 찍었을 때, 그 사진으로 변경시키기 위함
    required this.onRetakePressed,
    required this.onPlayPressed,
  });

  final String imagePath;
  final VoidCallback onRetakePressed;
  final VoidCallback onPlayPressed;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      children: [
        SizedBox(
          // width: double.infinity = 부모가 허용하는 가로너비를 모두 사용함
          width: double.infinity,
          height: 284,
          child: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(12),
            child: RotatedBox(
              quarterTurns: 1,
              // fit: BoxFit.cover = 이미지 비율을 유지하면서 지정한 영역을 빈틈없이 채움
              child: Image.file(File(imagePath), fit: BoxFit.cover),
            ),
          ),
        ),
        SizedBox(height: 24),
        Text("장면", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        Text("장면에 대한 키워드 및 분석 결과"),
        SizedBox(height: 24),
        Text(
          "장면에 어울리는 플레이리스트",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),
        // Material - Inkwell
        // GestureDetector 대신 터치효과가 있는 Inkwell 사용함
        // Material에서 색상, 모서리, 물결 효과 지정
        Material(
          color: Color(0xFF49454F).withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              debugPrint("Playlist 클릭");
              // ModalBottomSheet Widget을 화면에 띄우는 showModalBottomSheet() 함수
              showModalBottomSheet<void>(
                context: context,
                showDragHandle: true,
                useSafeArea: true,
                isScrollControlled: true,
                builder: (sheetContext) {
                  return ModalBottomSheet();
                },
              );
            },
            child: Container(
              height: 92,
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Image.asset('assets/images/image_sample.png', height: 70),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Playlist name",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text("Generated Date"),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 32),
        PrimaryButton(label: "Youtube Music에서 재생하기", onPressed: onPlayPressed),
        SizedBox(height: 8),
        SecondaryButton(
          label: "장면 다시 촬영하기",
          // 직접 Navigator를 호출하지 않고 콜백을 호출함
          onPressed: onRetakePressed,
        ),
      ],
    );
  }
}
