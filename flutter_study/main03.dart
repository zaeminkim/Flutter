// Defining a Function
// void: 아무것도 return 하지 않는다
import 'dart:vmservice_io';

void sayHello(String name) {
  print("Hello $name!");
}

// 함수가 즉시 return 하는 경우, =>를 사용해 간결하게 작성할 수 있음
// String sayBye(String name) => "Bye $name";
// String: return 타입
String sayBye(String name) {
  return "Bye $name!";
}

num plus(num a, num b) => a + b;

// Named Parameters: {} 사용해서 표현하기
// default value 지정하기
String sayHi({String name = 'anon', int age = 22, String country = 'wakanda'}) {
  return "Hi $name, you are $age, and you come from $country";
}

// required modifier 사용하기
String sayFuck({
  required String name,
  required int age,
  required String country,
}) {
  return "Fuck $name, $age year-old, from $country.";
}

// Optional Positional Parameters [ ..? .. = default value ]
String saySibal(String name, int age, [String? country = 'japan']) =>
    "sibal $name, $age year-old, from $country";

// QQ Operator
// String capitalizeName(String? name) =>
//     name != null ? name.toUpperCase() : 'ANON';
// left ?? right
// left가 null이라면 right를 return, left가 null이 아니라면 left를 return
String capitalizeName(String? name) => name?.toUpperCase() ?? 'ANON';

// Typedef
// Type Definition, 타입에 별명을 붙여서 간단하게 부를 수 있음
typedef ListOfInts = List<int>;

ListOfInts reverseListOfNumbers(ListOfInts list) {
  var reversed = list.reversed;
  return reversed.toList();
}

void main() {
  // Defining a Function
  sayHello("Max");
  print(sayBye("Lando"));
  print(plus(3, 4));

  // Named Parameters (<-> Positional Parameters)
  // 순서에 상관없이 argument의 이름들을 적으면 됨
  // default value 지정하기 or required modifier
  print(sayHi(age: 12, country: 'korea', name: 'nico'));
  print(sayHi(age: 90));
  print(sayFuck(age: 30, country: 'usa', name: 'george'));

  // Optional Positional Parameters
  print(saySibal('nico', 44));

  // QQ Operator
  print(capitalizeName('max'));
  print(capitalizeName(null));
  // QQ Assignment Operator
  // 변수가 null이라면 이 값을 할당하라
  String? n;
  n ??= 'nico';
  print(n);

  // Typedef
  print(reverseListOfNumbers([1, 2, 3]));
}
