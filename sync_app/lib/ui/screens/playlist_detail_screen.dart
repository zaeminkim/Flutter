import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sync_app/ui/widgets/playlist_song.dart';

class PlaylistDetailScreen extends StatelessWidget {
  const PlaylistDetailScreen({super.key, required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 80),
      body: SafeArea(
        child: ListView(
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
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Scene",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                ),
                Text(
                  "Playlist Name",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text("Generated Date"),
              ],
            ),
            SizedBox(height: 16),
            PlaylistSong(),
            PlaylistSong(),
            PlaylistSong(),
            PlaylistSong(),
            PlaylistSong(),
            PlaylistSong(),
            PlaylistSong(),
            PlaylistSong(),
            PlaylistSong(),
            PlaylistSong(),
          ],
        ),
      ),
    );
  }
}
