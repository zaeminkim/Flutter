import 'package:flutter/material.dart';
import 'package:sync_app/ui/widgets/playlist_song.dart';

class ModalBottomSheet extends StatelessWidget {
  const ModalBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 420,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
          children: [
            const Text(
              "Playlist Name",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
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
