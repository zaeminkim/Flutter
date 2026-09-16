// Dart Class
// Class 선언 시(function에서와 달리) property의 데이터타입을 반드시 명시해야 함
class Player {
  final String name;
  int xp;
  
  String team;
  int age;

  // Class 내의 method 정의
  void sayHello() {
    print("Hi, my name is $name.");
  }

  // Constructors
  // 생성자 메서드의 이름은 클래스의 이름과 같아야 함
  // 클래스를 호출할 때마다 기본적으로 호출되는 기본 constructor
  // Player(this.name, this.xp);

  // Named Constructor Parameters: {} 사용해서 표현하기
  Player({
    required this.name,
    required this.xp,
    required this.team,
    required this.age,
  });
  // named parameter는 기본적으로 required 속성이 없음
  // positional parameter는 기본적으로 required 속성이 있음

  // Named Constructors
  // Player.createRedPlayer(..)는 Player instance(object)를 만듦
  // : this.. ; 는 Player instance(object)를 초기화함
  Player.createRedPlayer({required String name, required int age})
    : this.age = age,
      this.name = name,
      team = 'red',
      xp = 0;

  Player.createYellowPlayer(String name, int age)
    : this.age = age,
      this.name = name,
      this.team = 'yellow',
      this.xp = 0;
}

void main() {
  // Class의 instance(Object) 선언
  // Constructors
  // var player = Player('max', 150);
  // player.sayHello();
  // var player2 = Player('lando', 100);
  // player2.sayHello();

  // Named Constructor Parameters
  // 순서에 상관없이 key:value 형식으로 작성
  var player = Player(name: "max", xp: 150, team: 'red', age: 20);
  var player2 = Player(age: 19, team: "yellow", xp: 100, name: "lando");
  print("${player.name}, ${player2.name}");

  // Named Constructors
  var player3 = Player.createRedPlayer(name: 'max', age: 21); // named parameter
  var player4 = Player.createYellowPlayer('lando', 19); // positional parameter
  print("${player3.team}, ${player4.team}");
}
