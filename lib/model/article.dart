class Article {
  final String title;
  final String urlToImage;
  final String url;
  final Source source;
  final String description; 

  Article({
    required this.title,
    required this.urlToImage,
    required this.url,
    required this.source,
    required this.description,
  });
}

class Source {
  final String name;
  final String country; 

  Source({required this.name, required this.country});
}
