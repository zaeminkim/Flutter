// Abstract Classes
class Player extends Fuck {
  String name;
  XPLevel xp;
  Team team;

  Player({required this.name, required this.xp, required this.team});

  void sayHello() {
    print("Hi, my name is $name");
  }

  // Abstract Classes
  void walk() {
    print('i am walking.');
  }
}

// Enums
// 새로운 타입 만들기와 같음
enum Team { red, blue }

enum XPLevel { beginner, medium, pro }

// Abstract Classes
// 추상화 클래스는 이를 상속받는(extends) 모든 클래스가 지녀야 하는 메소드(이름, 반환타입)들을 정의함
abstract class Fuck {
  void walk();
}

void main() {
  // Cascade Notation
  var player = Player(name: 'nico', xp: XPLevel.pro, team: Team.blue)
    // . = player
    ..name = 'max'
    ..xp = XPLevel.medium
    ..team = Team.blue
    ..sayHello();

  player.walk();
}
