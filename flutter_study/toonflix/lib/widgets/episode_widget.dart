import 'package:flutter/material.dart';
import 'package:toonflix/models/webtoon_episode_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Episode extends StatelessWidget {
  const Episode({super.key, required this.episode, required this.webtoonId});

  final String webtoonId;
  final WebtoonEpisodeModel episode;

  // url launcher 사용 함수
  Future<void> onButtonTap() async {
    // final url = Uri.parse("https://google.com");
    // await launchUrl(url);
    await launchUrlString(
      "https:/comic.naver.com/webtoon/detail?titleId=$webtoonId&no=${episode.id}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onButtonTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(20),
          // border: BoxBorder.all(color: Colors.green),
          boxShadow: [
            BoxShadow(
              blurRadius: 15,
              offset: Offset(5, 5),
              color: Colors.green.withValues(alpha: 0.5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                episode.title,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
