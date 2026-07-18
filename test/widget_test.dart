// Basic smoke test for the M-Zingi Invest app.
//
// It just verifies the app boots to the landing screen without throwing,
// since this app doesn't have the default counter-demo behaviour.

import 'package:flutter_test/flutter_test.dart';

import 'package:mzingi_invest/main.dart';

void main() {
  testWidgets('App boots to the landing screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MZingiApp());
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('M-Zingi Invest'), findsWidgets);
    expect(find.text('Start Investing →'), findsOneWidget);
  });
}
