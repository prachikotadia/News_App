import 'package:flutter/material.dart';
import 'package:flutter_news_app/screens/news_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Integration Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: NewsPage(
        newsAPI: null,
      ),
    ));

    expect(find.text('GENERAL'), findsOneWidget);
    expect(find.byIcon(Icons.public), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.text('BUSINESS'), findsOneWidget);
    expect(find.text('ENTERTAINMENT'), findsOneWidget);
    expect(find.text('HEALTH'), findsOneWidget);
    expect(find.text('SCIENCE'), findsOneWidget);
    expect(find.text('SPORTS'), findsOneWidget);
    expect(find.text('TECHNOLOGY'), findsOneWidget);

    await tester.tap(find.text('BUSINESS'));
    await tester.pump();
    expect(find.text('BUSINESS'), findsOneWidget);
  });
}
