import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'dashboard.dart';
import 'infoBerangkat.dart';
import 'trainingSchadule.dart';

class CustomNavBarPage extends StatefulWidget {
  const CustomNavBarPage({super.key});

  @override
  State<CustomNavBarPage> createState() => _CustomNavBarPageState();
}

class _CustomNavBarPageState extends State<CustomNavBarPage> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int _currentIndex = 1;

  final pages = [
    InfoberangkatPage(),
    Dashboard(),
    TrainingSchedulePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(Icons.flight_takeoff, size: 30, color: Colors.grey),
      Icon(Icons.home, size: 30, color: Colors.grey),
      Icon(Icons.calendar_today, size: 30, color: Colors.grey),
    ];

    return Container(
      color: Colors.pink[100],
      child: SafeArea(
        top: false,
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.white,
          body: pages[_currentIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.pink.shade100,
                  const Color.fromARGB(255, 255, 243, 214),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: CurvedNavigationBar(
              key: navigationKey,
              color: Colors.transparent, 
              buttonBackgroundColor: Colors.white, 
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
