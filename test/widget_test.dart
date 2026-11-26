// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:news_app/main.dart';

void main() {
  testWidgets('home page shows all practical sections', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('BAB 7 · REST API'), findsOneWidget);
    expect(find.text('Latihan 7.1'), findsOneWidget);
    expect(find.text('Latihan 7.2'), findsOneWidget);
    expect(find.text('Latihan 7.3'), findsOneWidget);
  });
}
