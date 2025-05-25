import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simi/api_services.dart';
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
        setState(() {
          registrations = response['data'];
          isLoading = false;
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

  Widget _buildCartItem(Map<String, dynamic> item) {
    final training = item['training'];
    final price = training?['price'] ?? 0;
    final id = item['id'];
    final trainingName = training?['training_name'] ?? 'Nama pelatihan tidak tersedia';

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
            "Status: ${item['status']}",
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
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
              icon: Icon(Icons.payment),
              label: Text("Bayar Sekarang"),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        title: Text("Keranjang Pelatihan"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
              ? Center(child: Text("Gagal memuat data."))
              : registrations.isEmpty
                  ? Center(child: Text("Tidak ada pelatihan dalam keranjang."))
                  : ListView.builder(
                      itemCount: registrations.length,
                      itemBuilder: (context, index) {
                        return _buildCartItem(registrations[index]);
                      },
                    ),
    );
  }
}
