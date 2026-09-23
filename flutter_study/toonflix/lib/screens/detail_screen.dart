import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toonflix/models/webtoon_detail_model.dart';
import 'package:toonflix/models/webtoon_episode_model.dart';
import 'package:toonflix/services/api_service.dart';
import 'package:toonflix/widgets/episode_widget.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher_string.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb, id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

// Stateful Widget은 별개의 두 class를 이용하기 때문에
// 데이터를 받아오려면 widget.id 처럼 작성해야 함
class _DetailScreenState extends State<DetailScreen> {
  // 1. Future
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;
  // 초기화하고 싶은 property가 있지만 생성자함수에서 불가능할 때 late 사용

  // 1. 사용자의 스마트폰 저장소와 연결한다
  late SharedPreferences prefs;
  bool isLiked = false;
  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    // 2. List를 가져온다
    final likedToons = prefs.getStringList('likedToons');
    if (likedToons != null) {
      if (likedToons.contains(widget.id) == true) {
        //
        setState(() {
          isLiked = true;
        });
      }
    } else {
      await prefs.setStringList('likedToons', []);
    }
  }

  @override
  void initState() {
    super.initState();
    // initState()에서 widget.id에 접근
    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getLatestEpisodesById(widget.id);

    initPrefs();
  }

  // // url launcher 사용 함수
  // onButtonTap() async {
  //   // final url = Uri.parse("https://google.com");
  //   // await launchUrl(url);
  //   await launchUrlString("https://google.com");
  // }

  Future<void> onHeartTap() async {
    final likedToons = prefs.getStringList('likedToons');
    if (likedToons != null) {
      if (isLiked) {
        likedToons.remove(widget.id);
      } else {
        likedToons.add(widget.id);
      }
      await prefs.setStringList('likedToons', likedToons);
      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 2,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: onHeartTap,
            icon: Icon(isLiked ? Icons.favorite : Icons.favorite_outline),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              // SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: widget.id,
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
                        widget.thumb,
                        headers: const {'Referer': 'https://comic.naver.com'},
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              // 2. FutureBuilder: widget을 return하는 함수
              FutureBuilder(
                future: webtoon,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.about,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          '${snapshot.data!.genre} / ${snapshot.data!.age}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    );
                  }
                  return Text("...");
                },
              ),
              const SizedBox(height: 20),
              FutureBuilder(
                future: episodes,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        for (var episode
                            in snapshot.data!.length > 10
                                ? snapshot.data!.sublist(0, 10)
                                : snapshot.data!)
                          Episode(episode: episode, webtoonId: widget.id),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
