import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'dashboard.dart';
import 'infoBerangkat.dart';
import 'trainingSchadule.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PopularNewsPage(),
  ));
}

class PopularNewsPage extends StatefulWidget {
  final int activeNavIndex;
  
  const PopularNewsPage({Key? key, this.activeNavIndex = 1}) : super(key: key);
  
  @override
  _PopularNewsPageState createState() => _PopularNewsPageState();
}

class _PopularNewsPageState extends State<PopularNewsPage> {
  late int _currentIndex;
  
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
      'image': 'assets/jalaniSumpah.jpeg',
      'title': 'Jay Idzes',
      'subtitle': 'Rampung jalani pengambilan sumpah'
    },
    {
      'image': 'assets/fotodashboard.jpg',
      'title': 'Berita Promo',
      'subtitle': 'Promo Sale'
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.activeNavIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, size: 28),
              ),
            ),


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

            const SizedBox(height: 16),

            SizedBox(
              height: 190,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: newsList.map((news) {
                    return Container(
                      width: 160,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
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
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
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
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
      extendBody: true,
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    final navigationKey = GlobalKey<CurvedNavigationBarState>();
    final items = <Widget>[
      const Icon(Icons.flight_takeoff, size: 30, color: Colors.grey),
      const Icon(Icons.home, size: 30, color: Colors.grey),
      const Icon(Icons.calendar_today, size: 30, color: Colors.grey),
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.pink[100]!,
            const Color.fromARGB(255, 244, 229, 186),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: CurvedNavigationBar(
        key: navigationKey,
        color: const Color.fromARGB(255, 255, 192, 203),
        buttonBackgroundColor: const Color(0xFFFFF6F6),
        backgroundColor: Colors.transparent,
        height: 60,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        index: _currentIndex,
        items: items,
        onTap: (index) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CustomNavBarPage(initialIndex: index),
            ),
          );
        },
      ),
    );
  }
}

class CustomNavBarPage extends StatefulWidget {
  final int initialIndex;
  const CustomNavBarPage({Key? key, this.initialIndex = 1}) : super(key: key);

  @override
  State<CustomNavBarPage> createState() => _CustomNavBarPageState();
}

class _CustomNavBarPageState extends State<CustomNavBarPage> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  late int _currentIndex;
  
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  Widget _getPageByIndex(int index) {
    switch(index) {
      case 0:
        return InfoberangkatPage();
      case 1:
        return Dashboard();
      case 2:
        return TrainingSchedulePage();
      default:
        return Dashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      const Icon(Icons.flight_takeoff, size: 30, color: Colors.grey),
      const Icon(Icons.home, size: 30, color: Colors.grey),
      const Icon(Icons.calendar_today, size: 30, color: Colors.grey),
    ];

    return Container(
      color: Colors.pink[100],
      child: SafeArea(
        top: false,
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.white,
          body: _getPageByIndex(_currentIndex),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.pink[100]!,
                  const Color.fromARGB(255, 244, 229, 186),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: CurvedNavigationBar(
              key: navigationKey,
              color: const Color.fromARGB(255, 255, 192, 203),
              buttonBackgroundColor: const Color(0xFFFFF6F6),
              backgroundColor: Colors.transparent,
              height: 60,
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 300),
              index: _currentIndex,
              items: items,
              onTap: (index) => setState(() => _currentIndex = index),
            ),
          ),
        ),
      ),
    );
  }
}