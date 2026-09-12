void main() {
  // Basic Data Types
  // 모든 데이터타입은 object로 구성됨, 객체 지향 언어
  String driver = "Max";
  bool alive = true;
  int score = 20;
  double money = 50.55;
  // num : integer or double
  num x = 12;
  x = 1.1;

  // Lists
  var numbers = [1, 2, 3, 4]; // List<int> numbers = [1,2,3,4,];
  numbers.add(10);
  // 다양한 메서드 존재
  print(numbers.first);
  print(numbers.last);
  // collection if
  // 조건에 따라 List에 item 추가하기
  var giveMeFive = true;
  var nums = [1, 2, 3, 4, if (giveMeFive) 5];
  print(nums);

  // String Interpolation
  // text에 변수를 추가하는 방법
  var name = "Max";
  var age = 10;
  var greeting = "Hello everyone, my name is $name and I'm ${age + 2}.";
  print(greeting);

  // Collection For
  var oldFriends = ['nico', 'lynn'];
  var newFriends = [
    'lewis',
    'lando',
    'yuki',
    for (var friend in oldFriends) "+$friend",
  ];
  print(newFriends);

  // Maps
  // key:value 구조
  var player = {'name': 'lewis', 'xp': 10, 'superpower': false};
  // Map<int, bool> player = {1: true, 2: false, 3: true};
}
