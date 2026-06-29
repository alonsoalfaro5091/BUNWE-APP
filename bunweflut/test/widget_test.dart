import 'package:flutter_test/flutter_test.dart';
import 'package:bungwe/main.dart';

void main() {
  testWidgets('BungweApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BungweApp());
    expect(find.byType(BungweApp), findsOneWidget);
  });
}
