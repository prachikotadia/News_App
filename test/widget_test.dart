import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_news_app/screens/news_page.dart';

void main() {
  group('NewsPage Widget Tests 🌟', () {
    testWidgets('A public icon indicates the first category that was chosen.', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: NewsPage(
          newsAPI: null,
        ),
      ));

      expect(find.byIcon(Icons.public), findsOneWidget);
    });

    testWidgets('A search icon appears when you enter search mode', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: NewsPage(
          newsAPI: null,
        ),
      ));

      // Verify initial state
      expect(find.byIcon(Icons.search), findsOneWidget);

      // Tap on the search icon
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Verify the search mode
      expect(find.byIcon(Icons.public), findsOneWidget); 
    });

    testWidgets('Tapping on the search icon enters search mode', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: NewsPage(
          newsAPI: null,
        ),
      ));

      expect(find.byType(TextField), findsNothing);

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('An symbol for health indicates the first category that has been chosen', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: NewsPage(
          newsAPI: null,
        ),
      ));

      expect(find.byIcon(Icons.local_hospital), findsOneWidget);
    });

    testWidgets('A scientific symbol denotes the first category that was chosen', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: NewsPage(
          newsAPI: null,
        ),
      ));

      expect(find.byIcon(Icons.science), findsOneWidget);
    });
  });
}
