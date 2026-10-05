import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sync_app/models/sync_api_models.dart';
import 'package:sync_app/ui/widgets/modal_bottom_sheet.dart';
import 'package:sync_app/ui/widgets/primary_button.dart';
import 'package:sync_app/ui/widgets/secondary_button.dart';

class HomePlaylistContent extends StatelessWidget {
  const HomePlaylistContent({
    super.key,
    required this.imagePath,
    required this.recommendation,
    required this.onRetakePressed,
    required this.onSavePressed,
    required this.isSaving,
    this.errorMessage,
    this.statusMessage,
  });

  final String imagePath;
  final DirectRecommendation recommendation;
  final VoidCallback onRetakePressed;
  final VoidCallback onSavePressed;
  final bool isSaving;
  final String? errorMessage;
  final String? statusMessage;

  Widget _playlistArtwork() {
    final artworkUrl = recommendation.tracks.isEmpty
        ? null
        : recommendation.tracks.first.artworkUrl;
    final fallback = Image.asset(
      'assets/images/image_sample.png',
      width: 70,
      height: 70,
      fit: BoxFit.cover,
    );
    if (artworkUrl == null) return fallback;

    return Image.network(
      artworkUrl,
      width: 70,
      height: 70,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => fallback,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      children: [
        SizedBox(
          width: double.infinity,
          height: 284,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: RotatedBox(
              quarterTurns: 1,
              child: Image.file(File(imagePath), fit: BoxFit.cover),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          '장면',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(recommendation.sceneDescription),
        const SizedBox(height: 24),
        const Text(
          '장면에 어울리는 플레이리스트',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Material(
          color: const Color(0xFF49454F).withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              showModalBottomSheet<void>(
                context: context,
                showDragHandle: true,
                useSafeArea: true,
                isScrollControlled: true,
                builder: (_) =>
                    ModalBottomSheet(recommendation: recommendation),
              );
            },
            child: SizedBox(
              height: 92,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _playlistArtwork(),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recommendation.playlistTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text('${recommendation.tracks.length}곡'),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (recommendation.partial) ...[
          const SizedBox(height: 12),
          Text(
            '검증된 곡 ${recommendation.tracks.length}/${recommendation.targetTrackCount}곡을 찾았어요. 찾은 곡은 그대로 저장할 수 있습니다.',
            style: const TextStyle(color: Color(0xFF6F6676), fontSize: 13),
          ),
        ],
        if (errorMessage != null) ...[
          const SizedBox(height: 12),
          Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ],
        if (statusMessage != null) ...[
          const SizedBox(height: 12),
          Text(
            statusMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF6750A4)),
          ),
        ],
        const SizedBox(height: 32),
        PrimaryButton(
          label: isSaving ? 'YouTube Music에 저장 중...' : 'YouTube Music에 저장',
          onPressed: isSaving || recommendation.tracks.isEmpty
              ? null
              : onSavePressed,
        ),
        const SizedBox(height: 8),
        SecondaryButton(
          label: '장면 다시 촬영하기',
          onPressed: isSaving ? null : onRetakePressed,
        ),
      ],
    );
  }
}
