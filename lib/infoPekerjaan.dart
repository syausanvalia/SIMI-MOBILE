import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:simi/berita.dart';
import 'package:simi/dashboard.dart';
import 'detailPekerjaan.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CustomNavBarPage(),
  ));
}

class JobInfoPage extends StatefulWidget {
  const JobInfoPage({Key? key}) : super(key: key);

  @override
  _JobInfoPageState createState() => _JobInfoPageState();
}

class _JobInfoPageState extends State<JobInfoPage> {
  final List<Map<String, String>> jobList = [
    {
      'namaPelatihan': 'Pelatihan Caregiver Dasar',
      'namaPekerjaan': 'Caregiver Lansia',
      'negara': 'Jepang',
      'gaji': 'IDK 18.000K',
      'desc': 'Merawat dan membantu aktivitas sehari-hari lansia di fasilitas kesehatan dengan pendekatan empatik dan tanggung jawab tinggi.'
    },
    {
      'namaPelatihan': 'Pelatihan Keterampilan Rumah Tangga',
      'namaPekerjaan': 'Housekeeper',
      'negara': 'Hong Kong',
      'gaji': 'IDK 15.500K',
      'desc': 'Bertugas membersihkan, mencuci, memasak, dan mengelola kebutuhan rumah tangga majikan dengan standar kebersihan tinggi.'
    },
    {
      'namaPelatihan': 'Pelatihan Asisten Dapur',
      'namaPekerjaan': 'Kitchen Helper',
      'negara': 'Taiwan',
      'gaji': 'IDK 16.000K',
      'desc': 'Membantu chef dalam menyiapkan bahan masakan, menjaga kebersihan dapur, serta memahami standar keamanan makanan.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Informasi Pekerjaan",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.pink,
          ),
        ),
        leading: BackButton(),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: jobList.length,
        itemBuilder: (context, index) {
          final job = jobList[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JobDetailPage(job: job),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job['namaPelatihan'] ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    job['namaPekerjaan'] ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    job['negara'] ?? '',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      text: job['gaji'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: "/bulan",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    job['desc'] ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
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
    switch (index) {
      case 0:
        return JobInfoPage();
      case 1:
        return Dashboard();
      case 2:
        return PopularNewsPage();
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
