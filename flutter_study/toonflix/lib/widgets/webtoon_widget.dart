import 'package:flutter/material.dart';
import 'package:toonflix/screens/detail_screen.dart';

class Webtoon extends StatelessWidget {
  final String title, thumb, id;

  const Webtoon({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 탭을 감지
      onTap: () {
        Navigator.push(
          context,
          // 애니메이션
          MaterialPageRoute(
            builder: (context) =>
                DetailScreen(title: title, thumb: thumb, id: id),
            fullscreenDialog: true,
          ),
        );
      },
      child: Column(
        children: [
          Hero(
            tag: id,
            child: Container(
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 15,
                    offset: Offset(10, 10),
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                ],
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.network(
                thumb,
                headers: const {'Referer': 'https://comic.naver.com'},
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
