import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'berita.dart';
import 'dashboard.dart';
import 'infoPekerjaan.dart';

void main() {
  runApp(const MaterialApp(
    home: GraduationPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class GraduationPage extends StatefulWidget {
  const GraduationPage({super.key});

  @override
  State<GraduationPage> createState() => _GraduationPageState();
}

class _GraduationPageState extends State<GraduationPage> {
  int currentIndex = 1;
  List<Map<String, String>> trainingScheduleList = [
    {
      'ID': '1',
      'Nama': '',
      'KKM': '',
      'Nilai': '',
      'Status': '',
    },
    {
      'ID': '1',
      'Nama': '',
      'KKM': '',
      'Nilai': '',
      'Status': '',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    onPressed: () {
                    Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => CustomNavBarPage()),
                  );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Graduation",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.pinkAccent,
              ),
            ),
            const SizedBox(height: 16),


            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(const Color(0xFFFFF0F5)),
                    dataRowColor: MaterialStateProperty.all(const Color(0xFFFFF0F5)),
                    border: TableBorder.all(color: Colors.black, width: 0.5),
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Nama')),
                      DataColumn(label: Text('KKM')),
                      DataColumn(label: Text('Nilai')),
                      DataColumn(label: Text('Status')),
                    ],
                    rows: trainingScheduleList.map((data) {
                      return DataRow(cells: [
                        DataCell(Text(data['ID'] ?? 'N/A')), 
                        DataCell(Text(data['Nama'] ?? 'N/A')), 
                        DataCell(Text(data['KKM'] ?? 'N/A')), 
                        DataCell(Text(data['Nilai'] ?? 'N/A')), 
                        DataCell(Text(data['Status'] ?? 'N/A')), 
                      ]);
                    }).toList(),
                  ),
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