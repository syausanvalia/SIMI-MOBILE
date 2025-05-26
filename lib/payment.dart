import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:simi/detailPekerjaan.dart';
import 'package:simi/konfirmasiPayment.dart';
import 'dashboard.dart';
import 'infoBerangkat.dart';
import 'trainingSchadule.dart';
import 'package:intl/intl.dart';
import 'training_cart_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  String formatRupiah(int number) {
    final formatCurrency = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
    return formatCurrency.format(number);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CustomNavBarPage(initialIndex: 1),
    );
  }
}

class PaymentPage extends StatelessWidget {
  final int id;
  final String trainingName;
  final int price;

  const PaymentPage({
    Key? key,
    required this.id,
    required this.trainingName,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Payment Now!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink[300],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'PAKET PELATIHAN',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        PaymentDetailRow(
                            title: 'ID Pelatihan', value: id.toString()),
                        PaymentDetailRow(
                            title: 'Kelas Pelatihan', value: trainingName),
                        PaymentDetailRow(
                            title: 'Harga', value: formatRupiah(price)),
                        const Divider(height: 30, thickness: 1),
                        const PaymentBankItem(
                          imagePath: 'assets/bni.png',
                          name: 'Valiaa Cecann',
                          accountNumber: '089515771237',
                        ),
                        const PaymentBankItem(
                          imagePath: 'assets/mandiri.png',
                          name: 'Lyaa',
                          accountNumber: '089515772377',
                        ),
                        const PaymentBankItem(
                          imagePath: 'assets/bri.png',
                          name: 'Syausan',
                          accountNumber: '089515783937',
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.pink[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Pembayaran harus dilakukan paling lambat 1 hari sebelum pelatihan. '
                            'Setelah pembayaran, harap lakukan konfirmasi dengan memasukkan nomor resi transfer. Terima kasih :)',
                            style: TextStyle(fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        konfirmasiPayment(trainingId: id)),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 14),
                              backgroundColor: Colors.pink[100]!,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 4,
                            ),
                            child: const Text(
                              'NEXT',
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentDetailRow extends StatelessWidget {
  final String title;
  final String value;

  const PaymentDetailRow({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(": $value", style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class PaymentBankItem extends StatelessWidget {
  final String imagePath;
  final String name;
  final String accountNumber;

  const PaymentBankItem({
    Key? key,
    required this.imagePath,
    required this.name,
    required this.accountNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Image.asset(imagePath, width: 50),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Nama   : $name"),
              Text("No.Rek : $accountNumber"),
            ],
          ),
        ],
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
  int _currentIndex = 1;

  final pages = [
    InfoberangkatPage(),
    Dashboard(),
    TrainingSchedulePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      const Icon(Icons.flight_takeoff, size: 30, color: Colors.grey),
      const Icon(Icons.home, size: 30, color: Colors.grey),
      const Icon(Icons.calendar_today, size: 30, color: Colors.grey),
    ];

    return Container(
      color: Colors.pink[100],
      child: SafeArea(
        top: false,
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.white,
          body: pages[_currentIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.pink[100]!,
                  const Color.fromARGB(255, 244, 229, 186),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: CurvedNavigationBar(
              key: navigationKey,
              color: const Color.fromARGB(255, 255, 192, 203),
              buttonBackgroundColor: const Color(0xFFFFF6F6),
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
