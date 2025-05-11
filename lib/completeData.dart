import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CompleteDataPage(),
  ));
}

class CompleteDataPage extends StatefulWidget {
  @override
  _CompleteDataPageState createState() => _CompleteDataPageState();
}

class _CompleteDataPageState extends State<CompleteDataPage> {
  final Map<String, TextEditingController> controllers = {
    'ID PMI': TextEditingController(),
    'Tgl. Pendaftaran': TextEditingController(),
    'Nama Lengkap': TextEditingController(),
    'Tempat Lahir': TextEditingController(),
    'Tgl. Lahir': TextEditingController(),
    'NIK': TextEditingController(),
    'No. KK': TextEditingController(),
    'No. Paspor': TextEditingController(),
    'No. KTP': TextEditingController(),
    'No. Ijazah': TextEditingController(),
    'Full Medical': TextEditingController(),
    'Pra Medical': TextEditingController(),
    'Jabatan': TextEditingController(),
    'Visa': TextEditingController(),
    'Status Pernikahan': TextEditingController(),
    'Sponsor': TextEditingController(),
    'Tgl. Pendaftaran ID': TextEditingController(),
    'Tgl. Keberangkatan': TextEditingController(),
    'Tgl. Kepulangan': TextEditingController(),
    'Pass Foto': TextEditingController(),
    'Foto Visa': TextEditingController(),
    'Foto KTP': TextEditingController(),
    'Foto Akta Kelahiran': TextEditingController(),
    'Foto KK': TextEditingController(),
    'SKCK': TextEditingController(),
    'Foto PP': TextEditingController(),
    'Foto Surat Izin': TextEditingController(),
    'Foto Ijazah': TextEditingController(),
  };

  String selectedOption = 'ex';
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Your Personal Data',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  for (var field in controllers.entries)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: TextField(
                        controller: field.value,
                        decoration: InputDecoration(
                          labelText: field.key,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  const Text("Status:"),
                  Row(
                    children: ['ex', 'non'].map((option) {
                      return Expanded(
                        child: RadioListTile<String>(
                          title: Text(option),
                          value: option,
                          groupValue: selectedOption,
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value!;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.pink[100]!,
              const Color.fromARGB(255, 244, 229, 186),
            ],
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: _currentIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.flight_takeoff),
              label: "departure",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: "schedule",
            ),
          ],
        ),
      ),
    );
  }
}
