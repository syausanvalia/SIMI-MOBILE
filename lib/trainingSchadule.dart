import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'berita.dart';
import 'dashboard.dart';
import 'infoPekerjaan.dart';
import 'api_services.dart';

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
  List<Map<String, String>> trainingScheduleList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadTrainingSchedule();
  }

  Future<void> loadTrainingSchedule() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await ApiService.fetchTrainingSchedule(); // Ganti YourApiService sesuai file/fungsi kamu
      setState(() {
        trainingScheduleList = data;
      });
    } catch (e) {
      print('Failed to fetch training schedule: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.pinkAccent),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Text(
                    "Training Schedule",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.pinkAccent,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.pinkAccent),
                    onPressed: () {
                      loadTrainingSchedule();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: RefreshIndicator(
                onRefresh: loadTrainingSchedule,
                child: trainingScheduleList.isEmpty && isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.all(const Color(0xFFFFF0F5)),
                            dataRowColor: MaterialStateProperty.all(const Color(0xFFFFF0F5)),
                            border: TableBorder.all(color: Colors.black, width: 0.5),
                            columns: const [
                              DataColumn(label: Text('Materi')),
                              DataColumn(label: Text('Lokasi')),
                              DataColumn(label: Text('Hari')),
                              DataColumn(label: Text('Jam')),
                              DataColumn(label: Text('Durasi')),
                              DataColumn(label: Text('Mulai')),
                              DataColumn(label: Text('Selesai')),
                            ],
                            rows: trainingScheduleList.map((data) {
                              return DataRow(cells: [
                                DataCell(Text(data['Materi'] ?? 'N/A')),
                                DataCell(Text(data['Lokasi'] ?? 'N/A')),
                                DataCell(Text(data['Hari'] ?? 'N/A')),
                                DataCell(Text(data['Jam'] ?? 'N/A')),
                                DataCell(Text(data['Durasi'] ?? 'N/A')),
                                DataCell(Text(data['Mulai'] ?? 'N/A')),
                                DataCell(Text(data['Selesai'] ?? 'N/A')),
                              ]);
                            }).toList(),
                          ),
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
