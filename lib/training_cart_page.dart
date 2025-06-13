import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simi/api_services.dart';
import 'package:simi/payment_status_manager.dart';
import 'package:lottie/lottie.dart';
import 'payment.dart';

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

        _showCancelSuccessDialog(); // ganti SnackBar dengan pop up animasi
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Lottie.asset(
                    'assets/lottie/transaction.json',
                    repeat: false,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Pembayaran Anda Berhasil',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Kelas Anda Sudah Aktif',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[100],
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCancelSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lottie/batalkelas.json',
                width: 180,
                height: 180,
                repeat: false,
              ),
              SizedBox(height: 16),
              Text(
                "Registrasi Berhasil Dibatalkan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "Anda telah membatalkan pelatihan ini.",
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Tutup", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
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

        if (isActive) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showSuccessDialog();
          });
        }

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
                  color: isPaid ? Colors.black : Colors.grey[700],
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
