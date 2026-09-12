void main() {
  print('Hello World');

  // Variables 변수
  // var를 사용해 데이터타입을 명시적으로 지정하지 않고도 변수 선언 가능함, 데이터타입 추로
  var name = 'Voyager I';
  var year = 1977;
  var antennaDiameter = 3.7;
  var flybyObjects = ['Jupiter', 'Saturn', 'Uranus'];
  var image = {
    'tags': ['saturn'],
    'url': '//path/to/saturn.jpg',
  };

  // Control FLow Statements 제어흐름문
  if (year >= 2001) {
    print('21st century');
  } else if (year >= 1901) {
    print('20th century');
  } else {
    print('19th century');
  }

  for (final object in flybyObjects) {
    print(object);
  }

  for (int month = 1; month <= 12; month++) {
    print(month);
  }

  while (year < 2026) {
    year += 1;
  }

  // Functions 함수
  var result = fibonacci(20);
  print(result);
}


int fibonacci(int n) { // 매개변수와 리턴값의 데이터타입을 명시적으로 지정
  if(n==0 || n==1) return n;
  return fibonacci(n-1) + fibonacci(n-2);
}
