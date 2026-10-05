import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sync_app/models/sync_api_models.dart';
import 'package:sync_app/ui/screens/playlist_detail_screen.dart';
import 'package:sync_app/ui/widgets/bluetooth_state.dart';
import 'package:sync_app/ui/widgets/restart_dialog.dart';
import 'package:sync_app/ui/widgets/secondary_button.dart';

class HomePlayingContent extends StatelessWidget {
  const HomePlayingContent({
    super.key,
    required this.isConnected,
    required this.imagePath,
    required this.recommendation,
    required this.playlist,
    required this.onRetakePressed,
    required this.onRecommendAgainPressed,
    required this.onOpenYoutubeMusic,
  });

  final bool isConnected;
  final String imagePath;
  final DirectRecommendation recommendation;
  final CreatedPlaylist playlist;
  final VoidCallback onRetakePressed;
  final VoidCallback onRecommendAgainPressed;
  final VoidCallback onOpenYoutubeMusic;

  Future<void> _showRestartDialog(BuildContext context) async {
    final action = await showDialog<RestartAction>(
      context: context,
      builder: (_) => const RestartDialog(),
    );
    if (!context.mounted || action == null) return;

    switch (action) {
      case RestartAction.retakePhoto:
        onRetakePressed();
      case RestartAction.recommendAgain:
        onRecommendAgainPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      children: [
        BluetoothState(isConnected: isConnected),
        const SizedBox(height: 24),
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
        const SizedBox(height: 16),
        Material(
          color: const Color(0xFF49454F).withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => PlaylistDetailScreen(
                    imagePath: imagePath,
                    recommendation: recommendation,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recommendation.sceneDescription,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          playlist.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text('${playlist.addedCount}곡 저장됨'),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
        ),
        if (playlist.partial) ...[
          const SizedBox(height: 12),
          Text(
            '${playlist.failedCount}곡은 저장하지 못했습니다.',
            style: const TextStyle(color: Color(0xFF6F6676)),
          ),
        ],
        const SizedBox(height: 64),
        SecondaryButton(
          label: '플레이리스트 다시 추천받기',
          onPressed: () => _showRestartDialog(context),
        ),
        const SizedBox(height: 8),
        SecondaryButton(
          label: 'YouTube Music으로 이동하기',
          onPressed: onOpenYoutubeMusic,
        ),
      ],
    );
  }
}
