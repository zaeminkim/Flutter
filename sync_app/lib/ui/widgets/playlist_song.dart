import 'package:flutter/material.dart';

class PlaylistSong extends StatelessWidget {
  const PlaylistSong({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.amber,
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Image.asset('assets/images/image_sample.png', height: 60),
          SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(
                "Title",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                "Singer",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
