import 'package:flutter/material.dart';

// PageRouteBuilder: Animate a page route transition
// Animation 객체를 제공하고, 이 객체는 Tween, Curve 객체와 함께 사용되어 애니메이션을 커스텀함
// 이 코드는 화면이 아래에서 위로 올라오도록 하는 커스텀 Route.

// 1. PageRouteBuilder 설정
// 2. Tween 만들기
// 3. AnimatedWidget 추가하기
// 4. CurveTween 사용하기
// 5. 두 개의 Tween 결합하기

Route<T> buildCameraPageRoute<T>(Widget page) {
  // 1. PageRouteBuilder 설정
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    // 1-1. pageBuilder: route의 페이지를 빌드, 어떤 화면을 보여줄지
    pageBuilder: (context, animation, secondaryAnimation) =>
        // const HomeCameraScreen(),
        page,
    // 1-2. transitionBuilder: route의 전환을 빌드, 그 화면이 어떻게 등장할지
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // 2. Tween 만들기: Offset(0,1) -> Offset(0,0) = 전환 애니메이션 만들기
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeOut;

      // 4. CurveTween 사용하기 = 애니메이션의 속도를 조정하는 곡선
      // 5. 두 개의 Tween 결합하기: chain()
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      // 3. AnimatedWidget 사용하기: SlideTransition
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}
