import 'package:flutter/material.dart';
import 'package:sync_app/models/sync_api_models.dart';
import 'package:sync_app/ui/widgets/playlist_song.dart';

class ModalBottomSheet extends StatelessWidget {
  const ModalBottomSheet({super.key, required this.recommendation});

  final DirectRecommendation recommendation;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 460,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
          children: [
            Text(
              recommendation.playlistTitle,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 16),
            for (final track in recommendation.tracks)
              PlaylistSong(track: track),
            if (recommendation.tracks.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Text('검증된 추천곡을 찾지 못했습니다.'),
              ),
          ],
        ),
      ),
    );
  }
}
