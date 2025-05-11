import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'infoBerangkat.dart';
import 'dashboard.dart';
import 'trainingSchadule.dart';

class CobaNavbar extends StatefulWidget {
  const CobaNavbar({super.key});

  @override
  State<CobaNavbar> createState() => _cobaNavbarState();
}

class _cobaNavbarState extends State<CobaNavbar> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 1;

  final screens = [   
    InfoberangkatPage(),
    Dashboard(),
    TrainingSchedulePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(
        Icons.shopping_cart,
        size: 30,
      ),
      Icon(
        Icons.home,
        size: 30,
      ),
      Icon(
        Icons.person,
        size: 30,
      ),
    ];

    return Container(
      color: Colors.blue.shade800,
      child: SafeArea(
        top: false,
        child: ClipRect(
          child: Scaffold(
            extendBody: true,
            backgroundColor: Colors.white,
            body: screens[index],
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                iconTheme: IconThemeData(color: Colors.white),
              ),
              child: CurvedNavigationBar(
                key: navigationKey,
                color: Color(0xFF2D6A78),
                buttonBackgroundColor: Color(0xFF2D6A78),
                backgroundColor: Colors.transparent,
                height: 60,
                animationCurve: Curves.easeInOut,
                animationDuration: Duration(milliseconds: 300),
                index: index,
                items: items,
                onTap: (index) => setState(() => this.index = index),
              ),
            ),
          ),
        ),
      ),
    );
  }
}