import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simi/daftar_kelas_page.dart';
import 'package:simi/payment.dart';
import 'package:simi/infoPekerjaan.dart';
import 'daftar_kelas_page.dart';

// Fungsi untuk format Rupiah
String formatRupiah(dynamic number) {
  if (number == null) return 'Rp0';
  final formatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
  return formatter.format(number);
}

class TrainingDetailPage extends StatelessWidget {
  final Map<String, dynamic> training;

  const TrainingDetailPage({Key? key, required this.training})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tombol kembali
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),

              const SizedBox(height: 8),

              Container(
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
                      training['training']?['training_name'] ??
                          'Nama Pelatihan',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Harga: ${formatRupiah(training['training']?['price'])}',
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
                      training['training']?['description'] ?? '-',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Tombol Beli
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DaftarKelasPage(
                           
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 14),
                          backgroundColor: Colors.pink[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'BUY',
                          style: TextStyle(
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
            ],
          ),
        ),
      ),
    );
  }
}
