class WebtoonDetailModel {
  final String title, about, genre, age;

  // 5. 생성자함수는 Json을 받아서 title에 json의 title값을 할당, ...
  WebtoonDetailModel.fromJson(Map<String, dynamic> json)
    : title = json['title'],
      about = json['about'],
      genre = json['genre'],
      age = json['age'];
}
