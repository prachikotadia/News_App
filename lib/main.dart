import 'package:flutter/material.dart';
import 'package:flutter_news_app/screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

// NewsPage widget implementation
class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latest News'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('News Title $index'),
            subtitle: Text('News Content $index'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewsDetailPage(index)),
              );
            },
          );
        },
      ),
    );
  }
}

// NewsDetailPage widget implementation
class NewsDetailPage extends StatelessWidget {
  final int index;

  const NewsDetailPage(this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    // Simulated news detail page
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'News Title $index',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Stay updated!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
