import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dataPersonal2.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'dashboard.dart';
import 'trainingSchadule.dart';

void main() {
  runApp(MaterialApp(
    home: InfoberangkatPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class InfoberangkatPage extends StatefulWidget {
  @override
  _InfoberangkatPageState createState() => _InfoberangkatPageState();
}

class _InfoberangkatPageState extends State<InfoberangkatPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController instansiController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController jamController = TextEditingController();
  final TextEditingController telpController = TextEditingController();
  final TextEditingController ktpController = TextEditingController();
  final TextEditingController pasporController = TextEditingController();
  final TextEditingController visaController = TextEditingController();

  String? suratPerizinanPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Text(
                "Informasi Berangkat",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.pink,
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildTextField("ID", idController),
                      buildTextField("Nama cpmi", nameController),
                      buildTextField("Instansi Tujuan", instansiController),
                      buildTextField("tgl berangkat", tanggalController),
                      buildTextField("Jam berangkat", jamController),
                      buildTextField("No.Telp", telpController),
                      buildTextField("No.KTP", ktpController),
                      buildTextField("No.Paspor", pasporController),
                      buildTextField("No.Visa", visaController),
                      buildUploadField("Surat perizinan"),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              print("Form disimpan");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFFD6E8), 
                            elevation: 2,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text(
                            "SAVE",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          TextFormField(
            controller: controller,
            style: const TextStyle(fontSize: 13),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.only(bottom: 4),
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            ),
            validator: (value) => value == null || value.isEmpty ? "Wajib diisi" : null,
          ),
        ],
      ),
    );
  }

  Widget buildUploadField(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(fontSize: 14)),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () => pickFile(),
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  suratPerizinanPath != null ? "File Selected" : "",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      setState(() {
        suratPerizinanPath = result.files.single.path;
      });
    }
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
        return InfoberangkatPage();
      case 1:
        return Dashboard();
      case 2:
        return TrainingSchedulePage();
      default:
        return Dashboard();
    }
  }

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


