import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'berita.dart';
import 'dashboard.dart';
import 'infoPekerjaan.dart';

void main() {
  runApp(const MaterialApp(
    home: TrainingSchedulePage(),
    debugShowCheckedModeBanner: false,
  ));
}

class TrainingSchedulePage extends StatefulWidget {
  const TrainingSchedulePage({super.key});

  @override
  State<TrainingSchedulePage> createState() => _TrainingSchedulePageState();
}

class _TrainingSchedulePageState extends State<TrainingSchedulePage> {
  int currentIndex = 1;
  List<Map<String, String>> trainingScheduleList = [
    {
      'ID': '1',
      'Materi': '',
      'Lokasi': '',
      'Hari': '',
      'Jam': '',
    },
    {
      'ID': '2',
      'Materi': '',
      'Lokasi': '',
      'Hari': '',
      'Jam': '',
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
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Training Schedule",
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
                      DataColumn(label: Text('Materi')),
                      DataColumn(label: Text('Lokasi')),
                      DataColumn(label: Text('Hari')),
                      DataColumn(label: Text('Jam')),
                    ],
                    rows: trainingScheduleList.map((data) {
                      return DataRow(cells: [
                        DataCell(Text(data['ID'] ?? 'N/A')), 
                        DataCell(Text(data['Materi'] ?? 'N/A')), 
                        DataCell(Text(data['Lokasi'] ?? 'N/A')), 
                        DataCell(Text(data['Hari'] ?? 'N/A')), 
                        DataCell(Text(data['Jam'] ?? 'N/A')), 
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
