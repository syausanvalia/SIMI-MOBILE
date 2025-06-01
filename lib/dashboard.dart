import 'dart:async';
import 'package:flutter/material.dart';
import 'package:simi/api_services.dart';
import 'package:simi/graduation.dart';
import 'package:simi/login.dart';
import 'package:simi/trainingSchadule.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'completeData.dart';
import 'berita.dart';
import 'infoPekerjaan.dart';
import 'final_score.dart';
import 'infoBerangkat.dart';
import 'daftar_kelas_page.dart';
import 'personaldata.dart';
import 'package:simi/training_cart_page.dart';
import 'package:lottie/lottie.dart';

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
  String welcomeMessage = "";
  bool isLoading = true;
  bool hasError = false;
  String? registrationStatus;
   Map<String, dynamic>? userData;

  List<String> imageList = [
    'assets/fotodashboard.png',
    'assets/fotodashboard2.png',
  ];

  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    fetchDashboardData();

    _pageController = PageController(initialPage: 0);

    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < imageList.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> fetchDashboardData() async {
    try {
      final response = await ApiService.getDashboard();
      print("RESPON DASHBOARD: $response");
      
      if (!mounted) return;
      
      if (response['success']) {
        final data = response['data'];
        setState(() {
          welcomeMessage = data['info'] ?? "Selamat datang pengguna";
          registrationStatus = data['registration_status'];
          userData = data['user'];
          isLoading = false;
        });
        
        print("Registration Status: $registrationStatus"); 
      } else {
        setState(() {
          welcomeMessage = "Gagal memuat data";
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      print("ERROR DASHBOARD: $e");
      if (!mounted) return;
      setState(() {
        welcomeMessage = "Gagal memuat data";
        hasError = true;
        isLoading = false;
      });
    }
  }
 void _handleMenuNavigation(Widget page) {
    print("Current Registration Status: $registrationStatus"); // Debug print
    
    if (registrationStatus == null || 
        !(registrationStatus == 'active' || 
          registrationStatus == 'completed')) {
      _showRegistrationAlert(context);
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  void _showRegistrationAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.all(20),
        constraints: BoxConstraints(maxHeight: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ANIMASI LOTTIE
            SizedBox(
              height: 150,
              child: Lottie.asset(
                'assets/lottie/classtidakbisadiakses.json',
                repeat: false,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Akses Ditolak!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Anda belum mendaftar kelas, silakan daftar kelas terlebih dahulu.',
              style: TextStyle(fontSize: 14, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.pinkAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(Icons.arrow_forward),
              label: Text('Daftar Kelas'),
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DaftarKelasPage()),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}

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
                          child: Text('Keluar'),
                        ),
                      ];
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.shopping_cart_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => TrainingCartPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 160,
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: imageList.length,
                  itemBuilder: (context, index) {
                    return Image.asset(
                      imageList[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: isLoading
                    ? CircularProgressIndicator()
                    : Text(
                        welcomeMessage,
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
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                crossAxisSpacing: 8,
                mainAxisSpacing: 7,
                childAspectRatio: 1,
                shrinkWrap: true,
                children: [
                  _buildMenuItem(Icons.account_box, "Data Pribadi", () {
                    _handleMenuNavigation(PersonalDataScreen());
                  }),
                  _buildMenuItem(Icons.assignment_turned_in, "Kelengkapan Data", () {
                    _handleMenuNavigation(CompletaData());
                  }),
                  _buildMenuItem(Icons.flight_takeoff, "Keberangkatan", () {
                    _handleMenuNavigation(InfoberangkatPage());
                  }),
                  _buildMenuItem(Icons.school, "Kelulusan", () {
                    _handleMenuNavigation(GraduationPage());
                  }),
                  _buildMenuItem(Icons.schedule_sharp, "Jadwal Pelatihan", () {
                    _handleMenuNavigation(TrainingSchedulePage());
                  }),
                  _buildMenuItem(Icons.grade, "Hasil Nilai", () {
                    _handleMenuNavigation(FinalScorePage());
                  }),
                  _buildMenuItem(Icons.class_, "Kelas Pelatihan", () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => DaftarKelasPage()));
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap) {
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
            Icon(icon, size: 28, color: Colors.grey[800]),
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
        backgroundColor: Colors.pink[50],
        title: Text(
          'Keluar dari akun',
          style: TextStyle(color: Colors.black),
        ),
        content: Text(
          'Anda yakin ingin keluar dari akun?',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Batal', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final success = await ApiService.logout();
              if (success) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                  (route) => false,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gagal keluar. Silakan coba lagi!'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text('Keluar', style: TextStyle(color: Colors.black)),
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

  final pages = [
    JobInfoPage(),
    Dashboard(),
    PopularNewsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(Icons.work_outline, size: 30, color: Colors.grey),
      Icon(Icons.home, size: 30, color: Colors.grey),
      Icon(Icons.newspaper, size: 30, color: Colors.grey),
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
