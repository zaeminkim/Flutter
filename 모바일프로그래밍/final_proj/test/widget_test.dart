import 'package:final_proj/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('sport flow opens home tabs and profile', (tester) async {
    await tester.pumpWidget(const SportPickApp());

    expect(find.text('스포츠를 즐길\n준비가 되셨나요?'), findsOneWidget);
    expect(find.text('선택하기'), findsOneWidget);

    await tester.tap(find.text('선택하기'));
    await tester.pumpAndSettle();

    expect(find.text('모바일 티켓'), findsOneWidget);
    expect(find.text('AR'), findsOneWidget);
    expect(find.text('편의'), findsOneWidget);
    expect(find.byType(Image), findsWidgets);

    final ticketOrigin = tester.getTopLeft(
      find.byKey(const ValueKey('mobileTicket')),
    );
    await tester.tapAt(ticketOrigin + const Offset(24, 24));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('ticketOverlay')), findsOneWidget);

    final overlayOrigin = tester.getTopLeft(
      find.byKey(const ValueKey('ticketOverlay')),
    );
    await tester.tapAt(overlayOrigin + const Offset(4, 4));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('ticketOverlay')), findsNothing);

    await tester.tap(find.text('AR'));
    await tester.pumpAndSettle();

    expect(find.text('AR 어시스턴트 사용하기'), findsOneWidget);

    await tester.tap(find.text('편의'));
    await tester.pumpAndSettle();

    expect(find.byType(Image), findsWidgets);

    await tester.tap(find.text('프로필'));
    await tester.pumpAndSettle();

    expect(find.text('마이페이지'), findsOneWidget);
    expect(find.text('설정'), findsOneWidget);
    expect(find.text('스포츠 사용자1'), findsOneWidget);
    expect(find.text('내 정보'), findsOneWidget);

    await tester.tap(find.text('설정'));
    await tester.pumpAndSettle();

    expect(find.text('푸시 알림 설정'), findsOneWidget);
    expect(find.text('기본 스포츠'), findsOneWidget);
    expect(find.text('앱 버전'), findsOneWidget);

    await tester.drag(find.byType(Scrollable).last, const Offset(0, -260));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Switch).last);
    await tester.pumpAndSettle();

    final darkModeSwitch = tester.widget<Switch>(find.byType(Switch).last);
    expect(darkModeSwitch.value, isTrue);

    expect(find.text('경기'), findsOneWidget);
  });
}
