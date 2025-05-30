import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simi/api_services.dart';
import 'package:simi/training_cart_page.dart';

// Format angka ke Rupiah
String formatRupiah(dynamic number) {
  if (number == null) return 'Rp0';
  final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
  return formatter.format(number);
}

class DaftarKelasPage extends StatefulWidget {
  const DaftarKelasPage({super.key});

  @override
  State<DaftarKelasPage> createState() => _DaftarKelasPageState();
}

class _DaftarKelasPageState extends State<DaftarKelasPage> {
  List<Map<String, dynamic>> allTrainings = [];
  bool isLoading = true;
  bool alreadyRegistered = false;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    setState(() {
      isLoading = true;
    });
    await fetchAllTrainings();
    await checkIfAlreadyRegistered();
  }

  Future<void> fetchAllTrainings() async {
    final trainings = await ApiService.getTrainings(); // Ambil semua data pelatihan
    setState(() {
      allTrainings = trainings;
    });
  }

  Future<void> checkIfAlreadyRegistered() async {
    final result = await ApiService.getTrainingRegistrations();
    if (result['success']) {
      setState(() {
        alreadyRegistered = (result['data'] as List).isNotEmpty;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kelas Tersedia'),
        backgroundColor: Colors.pink[100],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchInitialData,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: allTrainings.length,
                itemBuilder: (context, index) {
                  final training = allTrainings[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            training['training_name'] ?? 'Nama Pelatihan',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Harga: ${formatRupiah(training['price'])}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Deskripsi:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            training['description'] ?? '-',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[800],
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: alreadyRegistered
                                  ? null
                                  : () async {
                                      final result = await ApiService.postTrainingRegistration(training['id']);
                                      if (result['success']) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Berhasil mendaftar pelatihan!')),
                                        );
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TrainingCartPage(),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(result['message'] ?? 'Pendaftaran gagal')),
                                        );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                                backgroundColor: alreadyRegistered ? Colors.grey : Colors.pink[100],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 4,
                              ),
                              child: Text(
                                alreadyRegistered ? 'Sudah Terdaftar' : 'Checkout',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
