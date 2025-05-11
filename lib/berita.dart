import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PopularNewsPage(),
  ));
}

class PopularNewsPage extends StatefulWidget {
  @override
  _PopularNewsPageState createState() => _PopularNewsPageState();
}

class _PopularNewsPageState extends State<PopularNewsPage> {
  int _currentIndex = 1;

  final List<Map<String, String>> newsList = [
    {
      'image': 'assets/pasar.jpeg',
      'title': 'Wisata kuliner',
      'subtitle': 'Night Market Teipei'
    },
    {
      'image': 'assets/dibakar.png',
      'title': 'Pria Nekat',
      'subtitle': 'Jenazah Ayah Dibakar'
    },
    {
      'image': 'assets/news3.jpg',
      'title': 'Berita Ketiga',
      'subtitle': 'Subjudul Ketiga'
    },
    {
      'image': 'assets/news4.jpg',
      'title': 'Berita Keempat',
      'subtitle': 'Subjudul Keempat'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back, size: 28),
              ),
            ),

            // Section Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Popular News",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent,
                ),
              ),
            ),

            SizedBox(height: 16),

            // Scrollable News Cards
            SizedBox(
              height: 190,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: newsList.map((news) {
                    return Container(
                      width: 160,
                      margin: EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.asset(
                              news['image']!,
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  news['title']!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  news['subtitle']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            Spacer(),
          ],
        ),
      ),
    );
  }
}
