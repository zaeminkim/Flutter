import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sync_app/ui/screens/playlist_detail_screen.dart';
import 'package:sync_app/ui/widgets/bluetooth_state.dart';
import 'package:sync_app/ui/widgets/restart_dialog.dart';
import 'package:sync_app/ui/widgets/secondary_button.dart';

class HomePlayingContent extends StatelessWidget {
  const HomePlayingContent({
    super.key,
    required this.isConnected,
    required this.imagePath,
    required this.onRetakePressed,
    required this.onRecommendAgainPressed,
  });

  final bool isConnected;
  final String imagePath;
  final VoidCallback onRetakePressed;
  final VoidCallback onRecommendAgainPressed;

  Future<void> _showRestartDialog(BuildContext context) async {
    final action = await showDialog<RestartAction>(
      context: context,
      builder: (dialogContext) {
        return const RestartDialog();
      },
    );

    if (!context.mounted || action == null) {
      return;
    }

    switch (action) {
      case RestartAction.retakePhoto:
        onRetakePressed();
        break;

      case RestartAction.recommendAgain:
        onRecommendAgainPressed();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      children: [
        BluetoothState(isConnected: isConnected),
        const SizedBox(height: 24),
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
        SizedBox(height: 16),
        Material(
          color: Color(0xFF49454F).withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              debugPrint("Playlist 클릭");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PlaylistDetailScreen(imagePath: imagePath),
                ),
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
                          "Scene",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF6750A4).withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "Playing",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 64),
        SecondaryButton(
          label: "플레이리스트 다시 추천받기",
          onPressed: () {
            _showRestartDialog(context);
          },
        ),
        SizedBox(height: 8),
        SecondaryButton(label: "Youtube Music으로 이동하기", onPressed: () {}),
      ],
    );
  }
}
