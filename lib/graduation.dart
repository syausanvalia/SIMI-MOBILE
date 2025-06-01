import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:simi/dashboard.dart';
import 'dart:async';
import 'api_services.dart';

class GraduationPage extends StatefulWidget {
  const GraduationPage({super.key});

  @override
  State<GraduationPage> createState() => _GraduationPageState();
}

class _GraduationPageState extends State<GraduationPage> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> examScores = [];
  bool isLoading = true;
  bool showCongrats = false;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    loadExamScores();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> loadExamScores() async {
    setState(() {
      isLoading = true;
      showCongrats = false;
    });

    try {
      final data = await ApiService.fetchExamScores();
      final approvedData = data.where((e) => e['review_status'] == 'approved').toList();

      if (approvedData.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showNoDataDialog();
        });
      }

      setState(() {
        examScores = approvedData;
        isLoading = false;
        if (approvedData.isNotEmpty) {
          showCongrats = true;
          _controller.forward();

          Future.delayed(const Duration(seconds: 10), () {
          Navigator.pushReplacementNamed(context, '/dashboard');
        });

        }
      });
    } catch (e) {
      print('Error fetching exam scores: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showNoDataDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/lottie/data.json',
                  width: 200,
                  height: 200,
                  repeat: false,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Belum ada data nilai ujian yang disetujui.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildScoreCard(Map<String, dynamic> score, int index) {
    final displayFields = <Widget>[];

    void addFieldIfExists(String label, dynamic value, {bool isDate = false}) {
      if (value != null && value.toString().trim().isNotEmpty && value.toString() != 'null') {
        final displayValue = isDate ? formatDate(value.toString()) : value.toString();
        displayFields.add(rowItem(label, displayValue));
      }
    }

    addFieldIfExists("Kelas Pelatihan", score['kelas_pelatihan']);
    addFieldIfExists("Nilai", score['nilai']);
    addFieldIfExists("Keterangan", score['keterangan']);
    addFieldIfExists("Review Status", score['review_status']);
    addFieldIfExists("Tanggal Nilai", score['tanggal_nilai'], isDate: true);
    addFieldIfExists("Status", score['status']);
    addFieldIfExists("Created At", score['created_at'], isDate: true);
    addFieldIfExists("Updated At", score['updated_at'], isDate: true);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.pink[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.pinkAccent),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Data Ke-${index + 1}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          ...displayFields,
        ],
      ),
    );
  }

  Widget rowItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const Text(": "),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  Widget buildCongratsBanner() {
    return showCongrats
        ? SlideTransition(
            position: _slideAnimation,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green),
              ),
              child: const Column(
                children: [
                  Text(
                    "🎉 Selamat anda lulus kelas!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Anda berhak untuk melakukan perjalanan ke luar negeri. Silahkan lengkapi dokumen anda.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Kelulusan",
          style: TextStyle(color: Colors.pinkAccent),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.pinkAccent),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.pinkAccent),
            onPressed: () {
              loadExamScores(); // refresh
            },
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                buildCongratsBanner(),
                Expanded(
                  child: ListView.builder(
                    itemCount: examScores.length,
                    itemBuilder: (context, index) {
                      return buildScoreCard(examScores[index], index);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
