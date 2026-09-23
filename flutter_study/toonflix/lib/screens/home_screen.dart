import 'package:flutter/material.dart';
import 'package:toonflix/models/webtoon_model.dart';
import 'package:toonflix/services/api_service.dart';
import 'package:toonflix/widgets/webtoon_widget.dart';

// Widget
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // 1. Future를 가져오는 Service를 호출함
  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "오늘의 웹툰",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 2,
        surfaceTintColor: Colors.transparent,
      ),
      // 2. FutureBuilder를 사용해 Future가 완료되는 것을 기다리고 UI를 그림
      body: FutureBuilder(
        future: webtoons,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // return ListView.builder(
            return Column(
              children: [
                SizedBox(height: 50),
                Expanded(child: makeList(snapshot)),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  // ListView 렌더
  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      itemBuilder: (context, index) {
        var webtoon = snapshot.data![index];
        return Webtoon(
          title: webtoon.title,
          thumb: webtoon.thumb,
          id: webtoon.id,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(width: 40),
    );
  }
}
