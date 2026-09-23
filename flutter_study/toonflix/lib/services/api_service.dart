import 'dart:convert';
import 'package:toonflix/models/webtoon_detail_model.dart';
import 'package:toonflix/models/webtoon_episode_model.dart';
import 'package:toonflix/models/webtoon_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today"; // endpoint

  // async(비동기) 함수
  static Future<List<WebtoonModel>> getTodaysToons() async {
    List<WebtoonModel> webtoonInstances = [];
    final url = Uri.parse('$baseUrl/$today');
    // get(): url에 get request 보내기, await 키워드
    final response = await http.get(url);

    // statusCode == 200: request가 성공했다
    if (response.statusCode == 200) {
      // 데이터를 JSON으로 바꾸는 함수
      final List<dynamic> webtoons = jsonDecode(
        response.body,
      ); // response의 body에는 서버가 보낸 데이터가 있음
      for (var webtoon in webtoons) {
        // final toon = WebtoonModel.fromJson(webtoon);
        // print(toon.title);\

        // 각각의 웹툰마다 모델을 생성하고 List에 추가함
        webtoonInstances.add(WebtoonModel.fromJson(webtoon));
      }
      return webtoonInstances;
    } else {
      throw Error();
    }
  }

  // async(비동기) 함수
  static Future<WebtoonDetailModel> getToonById(String id) async {
    // 1. url을 만든다
    final url = Uri.parse("$baseUrl/$id");
    // 2. 해당 url로 request를 보내고, response를 받을 때까지 대기한다
    final response = await http.get(url);
    // 3. request가 성공적이라면, response.body를 받아서 Json으로 바꾼다
    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.body); // Json
      //4. Json을 생성자로 전달해서 model을 생성한다
      return WebtoonDetailModel.fromJson(webtoon);
    }
    throw Error();
  }

  static Future<List<WebtoonEpisodeModel>> getLatestEpisodesById(
    String id,
  ) async {
    List<WebtoonEpisodeModel> episodesInstances = [];
    final url = Uri.parse("$baseUrl/$id/episodes");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final episodes = jsonDecode(response.body);
      for (var episode in episodes) {
        episodesInstances.add(WebtoonEpisodeModel.fromJson(episode));
      }
      return episodesInstances;
    }
    throw Error();
  }
}
