import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:simi/api_services.dart';
import 'package:simi/berita.dart';
import 'package:simi/infoPekerjaan.dart';
import 'dashboard.dart';

class FinalScorePage extends StatefulWidget {
  const FinalScorePage({super.key});

  @override
  State<FinalScorePage> createState() => _FinalScorePageState();
}

class _FinalScorePageState extends State<FinalScorePage> {
  int currentIndex = 1;
  List<Map<String, dynamic>> examScores = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchScores();
  }

  Future<void> fetchScores() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final scores = await ApiService.fetchExamScores();
      setState(() {
        examScores = scores;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal memuat data nilai: $e';
        isLoading = false;
      });
    }
  }

  Widget buildScoreCard(Map<String, dynamic> score, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFFFFF0F5),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Table(
          columnWidths: const {
            0: IntrinsicColumnWidth(),
            1: FlexColumnWidth(),
          },
          children: [
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text('No', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(': ${index + 1}'),
                ),
              ],
            ),
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text('Kelas', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(': ${score['kelas_pelatihan'] ?? 'N/A'}'),
                ),
              ],
            ),
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text('Nilai', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(': ${score['nilai']?.toString() ?? 'N/A'}'),
                ),
              ],
            ),
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text('Keterangan', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(': ${score['keterangan'] ?? 'N/A'}'),
                ),
              ],
            ),
          ],
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
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const CustomNavBarPage()),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      fetchScores(); // refresh nilai
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Final Result",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.pinkAccent,
              ),
            ),
            const SizedBox(height: 12),

            // Content
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (errorMessage.isNotEmpty)
              Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red)))
            else if (examScores.isEmpty)
              const Center(child: Text('Tidak ada data nilai'))
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: fetchScores,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: examScores.length,
                    itemBuilder: (context, index) =>
                        buildScoreCard(examScores[index], index),
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
