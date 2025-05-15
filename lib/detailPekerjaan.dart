import 'package:flutter/material.dart';
import 'package:simi/payment.dart';
import 'infoPekerjaan.dart';
import 'payment.dart';

class JobDetailPage extends StatelessWidget {
  final Map<String, String> job;

  const JobDetailPage({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pelatihan Batch 1',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 12),
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/fotodashboard.png', 
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              left: 16,
                              top: 16,
                              child: Text(
                                'Excellent',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 8,
                                      color: Colors.black45,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'IDK 1.000K',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          '1. Pelatihan Soft Skill\n'
                          '   • Komunikasi & etika kerja\n'
                          '   • Manajemen keuangan pribadi (dasar)\n'
                          '   • Pembekalan budaya negara tujuan\n\n'
                          '2. Peralatan dan Seragam Pelatihan\n'
                          '   • Seragam pelatihan (kaos)\n'
                          '   • Alat tulis (buku, pena, ID card)\n'
                          '   • Masker dan alat kebersihan pribadi\n\n'
                          '3. Sertifikat & Dokumentasi\n'
                          '   • Sertifikat pelatihan dasar (berlogo resmi lembaga)\n'
                          '   • Foto dokumentasi kegiatan\n\n'
                          '4. Fasilitas Ruangan\n'
                          '   • Ruang pelatihan (AC atau kipas)\n'
                          '   • Proyektor / papan tulis / sound system',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                              context,
                              MaterialPageRoute(
                              builder: (context) => PaymentPage()
                                   ),
                                );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: Colors.white,
                              shadowColor: Colors.pinkAccent,
                              elevation: 5,
                            ),
                            child: Text(
                              'BUY',
                              style: TextStyle(
                                color: Colors.pinkAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
