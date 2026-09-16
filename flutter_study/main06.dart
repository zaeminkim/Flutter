// Abstract Classes
class Sibal extends Fuck {
  String name;
  XPLevel xp;
  Team team;

  Sibal({required this.name, required this.xp, required this.team});

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

// Inheritance
// 부모 클래스가 생성자를 포함하고 있는데, 그 부모 클래스를 다른 곳에 상속하려면 필요한 값을 전달해야 하고, 그 부모 클래스의 생성자를 호출해야 한다
class Human {
  final String name;
  Human({required this.name}); // 생성자
  void sayHi() {
    print("Hi my name is $name.");
  }
}

class Player extends Human {
  // Human 클래스에 있는 모든 것을 Player 클래스에 넣음
  final Team team;

  // 상속을 하면 프로퍼티, 메서드를 가져옴, 생성자 함수 호출도 해야 함
  Player({required this.team, required String name})
    : super(name: name); // super라는 키워드를 통해 상속한 부모 클래스와 상호작용할 수 있음: OOP
  // :을 적고 super 생성자를 호출하기

  @override // Human에서 온 sayHi를 우리가 직접 만든 sayHi()로 대체
  void sayHi() {
    super.sayHi(); // 상속한 부모 클래스의 프로퍼티에 접근, 메소드를 호출할 수 있게 해줌
    print('and I play for $team.');
  }
}

// Mixins
// 생성자가 없는 클래스, 클래스에 프로퍼티들을 추가할 때 사용함
// 핵심은 여러 클래스에 재사용이 가능하다는 점
class Strong {
  final double strengthLevel = 1500.99;
}

class QuickRunner {
  void runQuick() {
    print("run!");
  }
}

class Tall {
  final double height = 1.99;
}

// with 키워드를 사용함
// extend를 하게 되면 상속받은 클래스는 부모 클래스가 됨, 자식 클래스는 부모 클래스를 super를 통해 접근할 수 있음, 그 순간 부모 클래스의 인스턴스가 됨
class Man with Strong, QuickRunner, Tall {}

class Horse with Strong, QuickRunner {}

class Kid with QuickRunner {}

void main() {
  // Cascade Notation
  var sibal = Sibal(name: 'nico', xp: XPLevel.pro, team: Team.blue)
    // . = sibal
    ..name = 'max'
    ..xp = XPLevel.medium
    ..team = Team.blue
    ..sayHello();

  sibal.walk();

  // Inheritance
  var player = Player(team: Team.red, name: 'nico');
  player.sayHi();
}
