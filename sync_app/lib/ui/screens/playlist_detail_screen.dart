import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sync_app/models/sync_api_models.dart';
import 'package:sync_app/ui/widgets/playlist_song.dart';

class PlaylistDetailScreen extends StatelessWidget {
  const PlaylistDetailScreen({
    super.key,
    required this.imagePath,
    required this.recommendation,
  });

  final String imagePath;
  final DirectRecommendation recommendation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 80),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
          children: [
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
            Text(
              recommendation.sceneDescription,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
            Text(
              recommendation.playlistTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            for (final track in recommendation.tracks)
              PlaylistSong(track: track),
          ],
        ),
      ),
    );
  }
}
