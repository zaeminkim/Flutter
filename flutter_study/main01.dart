void main() {
  print('hello world');

  // The var keyword
  // 지역변수 선언할 때 var 사용
  // 명시적으로 타입 선언할 수도 있음
  var name = 'Max';
  name = 'Lando';
  print(name);

  // Dynamic Type
  // 어떤 타입의 데이터가 들어올지 모를 때
  var dyn;
  dyn = 'a';
  dyn = 12;
  dyn = false;
  print(dyn);

  // Nullable Variables
  // null safety: 개발자가 null 값을 참조할 수 없도록 하는 것
  //            : 어떤 변수가 null이 될 수 있음을 명시하는 것
  // 기본적으로 모든 변수는 non-nullable. null이 될 수 없음
  String? fuck = 'fuck'; // ?: 이 변수는 null이 될 수 있음
  fuck = null;
  //fuck.length;
  if (fuck != null) {
    // fuck이 null이 아니라면, length 속성을 요청한다
    fuck.length;
  }
  fuck?.isEmpty; // fuck이 null이 아니라면, isNotEmpty 속성을 요청한다

  // Final Variables
  // 수정 불가능한 변수 선언할 때 final 사용
  final sibal = 'sibal';
  print(sibal);

  // Late Variables
  // 데이터 없이 변수를 선언할 수 있도록 함
  late final ssibal;
  ssibal = 'ssibal';
  print(ssibal);

  // Constant Variables
  // const는 compile-time에 알고 있는 값일 때 사용
  const max_allowed_price = 120;
  // final API = fetchApi(); // 컴파일러가 값을 모르기 때문에 const 아님
  print(max_allowed_price);
}
