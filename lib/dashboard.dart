import 'package:flutter/material.dart';
import 'package:simi/graduation.dart';
import 'package:simi/konfirmasiPayment.dart';
import 'package:simi/login.dart';
import 'package:simi/trainingSchadule.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'dataPersonal.dart';
import 'completeData.dart';
import 'berita.dart';
import 'infoPekerjaan.dart';
import 'payment.dart';
import 'final_score.dart';
import 'infoBerangkat.dart';


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CustomNavBarPage(), 
  ));
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PopupMenuButton<String>(
                    icon: Icon(Icons.settings),
                    onSelected: (value) {
                      if (value == 'logout') {
                        _showLogoutDialog(context);
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          value: 'logout',
                          child: Text('Logout'),
                        ),
                      ];
                    },
                  ),
                  Icon(Icons.person_outline),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage('assets/fotodashboard.png'),
                  fit: BoxFit.cover,
                ),
              ),
              height: 160,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Text(
                      'Grow better\ntogether',
                      style: TextStyle(
                        color: Color.fromARGB(255, 245, 211, 211),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        shadows: [
                          Shadow(
                            color: Colors.black45,
                            offset: Offset(1, 1),
                            blurRadius: 3,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "More",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 250, 195, 213),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                padding: EdgeInsets.symmetric(horizontal: 16),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
                children: [
                  _buildMenuItem(Icons.assignment_turned_in, "complete data", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => CompleteDataPage()));
                  }),
                  _buildMenuItem(Icons.school, "graduation", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => GraduationPage()));
                  }),
                  _buildMenuItem(Icons.work_outline, "job information", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => JobInfoPage()));
                  }),
                  _buildMenuItem(Icons.account_box, "personal data", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => PersonalDataPage()));
                  }),
                  _buildMenuItem('assets/payment.png', "payment", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentPage()));
                  }),
                  _buildMenuItem(Icons.newspaper, "popular news", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => PopularNewsPage()));
                  }),
                  _buildMenuItem(Icons.grade, "final score", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => FinalScorePage()));
                  }),
                  _buildMenuItem('assets/logoKonfirm.png', "confirm payment", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => konfirmasiPayment()));
                  }),
                  SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(dynamic icon, String label, VoidCallback onTap) {
    Widget iconWidget;

    if (icon is IconData) {
      iconWidget = Icon(icon, size: 28, color: Colors.grey[800]);
    } else if (icon is String) {
      iconWidget = Image.asset(
        icon,
        width: 28,
        height: 28,
      );
    } else {
      iconWidget = Icon(Icons.help_outline, size: 28);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink[100]!, Color.fromARGB(255, 244, 229, 186)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[800]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor:Colors.pink[50],
        title: Text(
          'Logout Confirmation',
          style: TextStyle(color: Colors.black),
          ),
        content: Text('Are you sure you want to logout?',
        style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel',
            style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
                (route) => false,
              );
            },
            child: Text('Logout',
            style: TextStyle(color: Colors.black),
            ),
          ),
        ],
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
    switch (index) {
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
