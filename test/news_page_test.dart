// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_news_app/screens/news_page.dart';
import 'package:news_api_flutter_package/model/article.dart';
import 'package:mockito/mockito.dart';
import 'package:news_api_flutter_package/news_api_flutter_package.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockNewsAPI extends Mock implements NewsAPI {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('NewsPageState Tests', () {
    late NewsPageState newsPageState;

    setUp(() {
      newsPageState = NewsPageState();
    });

    test('The search term setting should accurately update the state', () {
      // Arrange
      const searchTerm = 'Flutter';

      // Act
      newsPageState.setSearchTerm(searchTerm);

      // Assert
      expect(newsPageState.getSearchTerm(), searchTerm);
    });

    test('For BUSINESS, the chosen category setting should accurately update the state', () {
      // Arrange
      const selectedCategory = 'BUSINESS';

      // Act
      newsPageState.setSelectedCategory(selectedCategory);

      // Assert
      expect(newsPageState.getSelectedCategory(), selectedCategory);
    });

    test('For entertainment, the chosen category setting should accurately update the status.', () {
      // Arrange
      const selectedCategory = 'ENTERTAINMENT';

      // Act
      newsPageState.setSelectedCategory(selectedCategory);

      // Assert
      expect(newsPageState.getSelectedCategory(), selectedCategory);
    });

    test('The chosen category setting for HEALTH should accurately update the status', () {
      // Arrange
      const selectedCategory = 'HEALTH';

      // Act
      newsPageState.setSelectedCategory(selectedCategory);

      // Assert
      expect(newsPageState.getSelectedCategory(), selectedCategory);
    });

    test('For Science, the chosen category should accurately update the state', () {
      // Arrange
      const selectedCategory = 'SCIENCE';

      // Act
      newsPageState.setSelectedCategory(selectedCategory);

      // Assert
      expect(newsPageState.getSelectedCategory(), selectedCategory);
    });
  });

  runApp(MaterialApp(home: CategoriesTestScreen()));
}

class CategoriesTestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Categories Test')),
      body: ListView(
        children: [
          _buildCategoryItem(Icons.search, 'Search Term'),
          _buildCategoryItem(Icons.business, 'Business'),
          _buildCategoryItem(Icons.theater_comedy, 'Entertainment'),
          _buildCategoryItem(Icons.local_hospital, 'Health'),
          _buildCategoryItem(Icons.science, 'Science'),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String name) {
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
    );
  }
}
