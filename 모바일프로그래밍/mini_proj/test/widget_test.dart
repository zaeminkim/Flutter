import 'package:flutter_test/flutter_test.dart';
import 'package:mini_proj/main.dart';

void main() {
  testWidgets('Outfeed app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const OutfeedApp());
    await tester.pumpAndSettle();
  });
}
