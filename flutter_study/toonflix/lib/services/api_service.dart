import 'dart:convert';
import 'package:toonflix/models/webtoon_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://webtoon-crawler.nomadcoders.workers.dev";
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
        // print(toon.title);
        webtoonInstances.add(WebtoonModel.fromJson(webtoon));
      }
      return webtoonInstances;
    }
    throw Error();
  }
}
