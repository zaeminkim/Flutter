class WebtoonEpisodeModel {
  final String id, title, rating, date;

  WebtoonEpisodeModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      title = json['title'],
      rating = json['rating'],
      date = json['date'];
}
// 새로운 class 생성, json Map으로 class를 초기화할 생성자도 생성