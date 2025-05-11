import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:simi/dashboard.dart';
import 'package:simi/infoBerangkat.dart';
import 'package:simi/trainingSchadule.dart';


class CompleteDataPage extends StatefulWidget {

  final int activeNavIndex;
  
  const CompleteDataPage({Key? key, this.activeNavIndex = 1}) : super(key: key);
  
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
  late int _currentIndex;
  
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.activeNavIndex; 
  }

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
      bottomNavigationBar: _buildBottomNavBar(context),
      extendBody: true, 
    );
  }

 
  Widget _buildBottomNavBar(BuildContext context) {
    final navigationKey = GlobalKey<CurvedNavigationBarState>();
    final items = <Widget>[
      Icon(Icons.flight_takeoff, size: 30, color: Colors.grey),
      Icon(Icons.home, size: 30, color: Colors.grey),
      Icon(Icons.calendar_today, size: 30, color: Colors.grey),
    ];

    return Container(
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
        onTap: (index) {
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CustomNavBarPage(initialIndex: index),
            ),
          );
        },
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
  late int _currentIndex;
  
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  
  Widget _getPageByIndex(int index) {
    switch(index) {
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

 
  late final pages = [
    InfoberangkatPage(),
    Dashboard(),
    TrainingSchedulePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(Icons.flight_takeoff, size: 30, color: Colors.grey),
      Icon(Icons.home, size: 30, color: Colors.grey),
      Icon(Icons.calendar_today, size: 30, color: Colors.grey),
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

