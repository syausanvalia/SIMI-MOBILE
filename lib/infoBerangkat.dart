import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:simi/api_services.dart';
import 'package:simi/berita.dart';
import 'package:simi/infoPekerjaan.dart';
import 'dashboard.dart';

void main() {
  runApp(MaterialApp(
    home: InfoberangkatPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class InfoberangkatPage extends StatefulWidget {
  @override
  _InfoberangkatPageState createState() => _InfoberangkatPageState();
}

class _InfoberangkatPageState extends State<InfoberangkatPage> {
  Map<String, dynamic>? travelInfo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTravelInfo();
  }

  Future<void> fetchTravelInfo() async {
    final logs = await ApiService.getTravelLogs();
    setState(() {
      travelInfo = logs.isNotEmpty ? logs[0] : null;
      isLoading = false;
    });
  }

  Widget buildDataField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: const Border(bottom: BorderSide(color: Colors.black)),
            ),
            child: Text(
              value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : travelInfo == null
                ? const Center(child: Text("Tidak ada data berangkat."))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                        child: Text(
                          "Informasi Berangkat",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.pink,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12),
                              buildDataField("Nama :", travelInfo!['nama_user']?? '-'),
                              buildDataField("Review Status", travelInfo!['review_status'] ?? '-'),
                              buildDataField("Travel Type", travelInfo!['travel_type'] ?? '-'),
                              buildDataField("Date", travelInfo!['date'] ?? '-'),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
  final GlobalKey<CurvedNavigationBarState> navigationKey = GlobalKey<CurvedNavigationBarState>();
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
