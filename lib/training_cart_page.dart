import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simi/api_services.dart';
import 'package:simi/payment_status_manager.dart';
import 'payment.dart'; // Pastikan file ini ada

class TrainingCartPage extends StatefulWidget {
  @override
  _TrainingCartPageState createState() => _TrainingCartPageState();
}

class _TrainingCartPageState extends State<TrainingCartPage> {
  List<dynamic> registrations = [];
  bool isLoading = true;
  bool hasError = false;

  final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    fetchRegistrations();
  }

  Future<void> fetchRegistrations() async {
    try {
      final response = await ApiService.getTrainingRegistrations();
      print("RESPON REGISTRASI: $response");

      if (response['success'] == true) {
        final registrationsData = response['data'] as List;

        for (var registration in registrationsData) {
          final id = registration['id'];
          final status = registration['status']?.toLowerCase();
          if (status == 'active') {
            await PaymentStatusManager.setPaymentStatus(id, false);
          }
        }

        setState(() {
          registrations = registrationsData;
          isLoading = false;
          hasError = false;
        });
      } else {
        throw Exception(response['message'] ?? 'Gagal mengambil data.');
      }
    } catch (e) {
      print("ERROR FETCH REGISTRATION: $e");
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> _cancelRegistration(int id) async {
    try {
      final response = await ApiService.cancelTrainingRegistration(id);
      if (response['success'] == true) {
        setState(() {
          registrations.removeWhere((item) => item['id'] == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registrasi berhasil dibatalkan')),
        );
      } else {
        throw Exception(response['message'] ?? 'Gagal membatalkan registrasi');
      }
    } catch (e) {
      print("ERROR CANCEL REGISTRATION: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan saat membatalkan registrasi')),
      );
    }
  }

  Widget _buildCartItem(Map<String, dynamic> item) {
    final training = item['training'];
    final price = training?['price'] ?? 0;
    final id = item['id'];
    final trainingName = training?['training_name'] ?? 'Nama pelatihan tidak tersedia';
    final status = item['status']?.toLowerCase() ?? '';

    return FutureBuilder<bool>(
      future: PaymentStatusManager.getPaymentStatus(id),
      builder: (context, snapshot) {
        final isPaid = snapshot.data ?? false;
        final isActive = status == 'active';

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink[100]!, Color.fromARGB(255, 244, 229, 186)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trainingName,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                "Harga: ${currencyFormatter.format(price)}",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 6),
              Text(
                "Status: ${isPaid ? 'Menunggu Konfirmasi Admin' : item['status']}",
                style: TextStyle(
                  fontSize: 14,
                  color: isPaid ? Colors.white : Colors.grey[700],
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isActive
                          ? Colors.green
                          : (isPaid ? Colors.grey : Colors.pinkAccent),
                      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: (isActive || isPaid)
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PaymentPage(
                                  id: id,
                                  trainingName: trainingName,
                                  price: price,
                                ),
                              ),
                            );
                          },
                    icon: Icon(
                      isActive
                          ? Icons.check_circle
                          : (isPaid ? Icons.hourglass_empty : Icons.payment),
                    ),
                    label: Text(
                      isActive
                          ? "Kelas Anda Sudah Aktif"
                          : (isPaid ? "Menunggu Konfirmasi" : "Bayar Sekarang"),
                    ),
                  ),
                  if (!isPaid && !isActive) SizedBox(width: 12),
                  if (!isPaid && !isActive)
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Konfirmasi"),
                            content: Text("Apakah Anda yakin ingin membatalkan registrasi ini?"),
                            actions: [
                              TextButton(
                                child: Text("Tidak"),
                                onPressed: () => Navigator.of(context).pop(false),
                              ),
                              TextButton(
                                child: Text("Ya"),
                                onPressed: () => Navigator.of(context).pop(true),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await _cancelRegistration(id);
                        }
                      },
                      icon: Icon(Icons.cancel),
                      label: Text("Batal"),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.pinkAccent,
        title: Text("Keranjang Pelatihan"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
              ? Center(child: Text("Gagal memuat data."))
              : RefreshIndicator(
                  onRefresh: fetchRegistrations,
                  child: registrations.isEmpty
                      ? ListView(
                          physics: AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: 100),
                            Center(child: Text("Tidak ada pelatihan dalam keranjang.")),
                          ],
                        )
                      : ListView.builder(
                          itemCount: registrations.length,
                          itemBuilder: (context, index) {
                            return _buildCartItem(registrations[index]);
                          },
                        ),
                ),
    );
  }
}
