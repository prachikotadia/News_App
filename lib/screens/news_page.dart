// ignore_for_file: library_prefixes

import 'package:flutter/material.dart';
import 'package:flutter_news_app/screens/news_web_view.dart';
import 'package:news_api_flutter_package/model/article.dart' as NewsApiArticle;
import 'package:news_api_flutter_package/model/article.dart';
import 'package:news_api_flutter_package/news_api_flutter_package.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key, required newsAPI}) : super(key: key);

  @override
  State<NewsPage> createState() => NewsPageState();
}

class NewsPageState extends State<NewsPage> {
  late Future<List<NewsApiArticle.Article>> future;
  String? searchTerm;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  List<String> categoryItems = [
    "GENERAL",
    "BUSINESS",
    "ENTERTAINMENT",
    "HEALTH",
    "SCIENCE",
    "SPORTS",
    "TECHNOLOGY",
  ];

  String? selectedCategory;

@override
void initState() {
  super.initState();

  if (categoryItems.isNotEmpty) {
    // Set the selected category to the first item in the list
    selectedCategory = categoryItems[0];
  } else {
    // If the category list is empty, set the selected category to a default value
    selectedCategory = "OTHER";
  }

  // Fetch news data for the selected category
  future = getNewsData();

  // Load preferences to initialize search term and selected category
  loadPreferences();

  // Additional logic for initialization
  if (isSearching) {
    // Perform additional setup if currently searching
    searchController.addListener(() {
      // Add listener to search controller for real-time updates
      setState(() {
        searchTerm = searchController.text;
        future = getNewsData();
        savePreferences();
      });
    });
  }
}

  Future<void> loadPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    final selectedCategoryFromPrefs = preferences.getString('selectedCategory');
    final searchTermFromPrefs = preferences.getString('searchTerm');
    setState(() {
      selectedCategory = selectedCategoryFromPrefs ?? (categoryItems.isNotEmpty ? categoryItems[0] : "OTHER");
      searchTerm = searchTermFromPrefs;
      future = getNewsData();
    });
  }


  // Future<List<NewsApiArticle.Article>> getNewsData() async {
  //   final newsAPI = NewsAPI(apiKey: '17dfa04528274be1b319265af7c3c531');
  //   final newsList = await newsAPI.getTopHeadlines(
  //     country: "us",
  //     query: searchTerm,
  //     category: selectedCategory,
  //     pageSize: 50,
  //   );
  //   return newsList;
  // }
Future<List<NewsApiArticle.Article>> getNewsData() async {
  try {
    final newsAPI = NewsAPI('17dfa04528274be1b319265af7c3c531');
    final newsList = await newsAPI.getTopHeadlines(
      country: "us",
      query: searchTerm,
      category: selectedCategory,
      pageSize: 50,
    );
    return newsList;
  } catch (e) {
    // Handle the exception or error here
    //print('Successfully fetching news data');
    // You can return an empty list or throw a custom error
    return <NewsApiArticle.Article>[];
  }
}


  Future<void> savePreferences() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString('selectedCategory', selectedCategory!);
    preferences.setString('searchTerm', searchTerm ?? '');
  }

  String? getSelectedCategory() {
    return selectedCategory;
  }

  String? getSearchTerm() {
    return searchTerm;
  }

  Future<void> fetchNewsData() async {
    future = getNewsData();
  }

  void setSearchTerm(String term) {
    searchTerm = term;
  }

  void setSelectedCategory(String category) {
    selectedCategory = category;
  }

  Future<void> resetPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.clear();
    setState(() {
      selectedCategory = categoryItems[0];
      searchTerm = null;
      future = getNewsData();
    });
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: isSearching ? searchAppBar() : appBar(),
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 8, 64, 4),
            Color.fromARGB(255, 121, 146, 161)
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            _buildCategories(),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder(
                builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "Error loading the news",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  } else {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return _buildNewsListView(snapshot.data as List<Article>);
                    } else {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            "No news available",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }
                  }

                },
                future: future,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

 PreferredSizeWidget appBar() {
  return PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: AppBar(
      backgroundColor: Colors.teal,
      title: const Row(
        children: [
          Text(
            "EXPLORE",
            style: TextStyle(
              color: Colors.yellow,
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Pacifico', // Custom font
            ),
          ),
          SizedBox(width: 8.0),
          Text(
            "NEWS",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              isSearching = true;
            });
          },
          icon: const Icon(
            Icons.search,
            color: Colors.white,
            size: 28.0,
          ),
        ),
      ],
    ),
  );
}


PreferredSizeWidget searchAppBar() {
  return AppBar(
    backgroundColor: const Color.fromARGB(255, 108, 134, 121),
    leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 32.0),
      onPressed: () {
        setState(() {
          isSearching = false;
          searchTerm = null;
          searchController.text = "";
          future = getNewsData();
          savePreferences(); 
        });
      },
    ),
    title: Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 2, 248, 101).withOpacity(0.01),
        borderRadius: BorderRadius.circular(0.10),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white, size: 28.0),
          const SizedBox(width: 16.0),
          Expanded(
            child: TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white, fontSize: 20.0),
              cursorColor: Colors.white,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: " ",
                hintStyle: TextStyle(color: Colors.white70, fontSize: 20.0),
              ),
            ),
          ),
        ],
      ),
    ),
    actions: [
      ElevatedButton(
        onPressed: () {
          setState(() {
            searchTerm = searchController.text;
            future = getNewsData();
            savePreferences(); 
          });
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 3, 128, 15).withOpacity(0.8)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          elevation: MaterialStateProperty.all<double>(0),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          child: Text(
            'Search',
            style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ],
  );
}




Widget _buildCategories() {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: List.generate(categoryItems.length, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = categoryItems[index];
                future = getNewsData();
                savePreferences();
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: categoryItems[index] == selectedCategory
                    ? const Color.fromARGB(255, 47, 110, 49).withOpacity(0.8)
                    : const Color.fromARGB(255, 84, 222, 88),
                borderRadius: BorderRadius.circular(28.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    _getCategoryIcon(categoryItems[index]),
                    color: Colors.white,
                    size: 20.0,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    categoryItems[index],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    ),
  );
}


IconData _getCategoryIcon(String category) {
  switch (category) {
    case "GENERAL":
      // Return the public icon for the general category
      return Icons.public;
    case "BUSINESS":
      // Return the business icon for the business category
      return Icons.business;
    case "ENTERTAINMENT":
      // Return the movie icon for the entertainment category
      return Icons.movie;
    case "HEALTH":
      // Return the local hospital icon for the health category
      return Icons.local_hospital;
    case "SCIENCE":
      // Return the science icon for the science category
      return Icons.science;
    case "SPORTS":
      // Return the sports soccer icon for the sports category
      return Icons.sports_soccer;
    case "TECHNOLOGY":
      // Return the computer icon for the technology category
      return Icons.computer;
    default:
      // Return the default category icon for unknown categories
      return Icons.category;
  }
}



  Widget _buildNewsListView(List<Article> articleList) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      physics: const BouncingScrollPhysics(),
      itemCount: articleList.length,
      separatorBuilder: (context, index) => Divider(color: Colors.grey.shade300),
      itemBuilder: (context, index) {
        final article = articleList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: _buildNewsItem(article),
        );
      },
    );
  }

Widget _buildNewsItem(Article article) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsWebView(url: article.url!),
        ),
      );
    },
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 8,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.network(
              article.urlToImage ?? "",
              height: 120.0,
              width: 120.0,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image_not_supported, size: 80, color: Colors.grey);
              },
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title ?? "",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  article.source.name ?? "",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

}
