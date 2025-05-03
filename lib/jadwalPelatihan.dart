import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: TrainingSchedulePage(),
    debugShowCheckedModeBanner: false,
  ));
}

class TrainingSchedulePage extends StatefulWidget {
  const TrainingSchedulePage({super.key});

  @override
  State<TrainingSchedulePage> createState() => _TrainingSchedulePageState();
}

class _TrainingSchedulePageState extends State<TrainingSchedulePage> {
  int _currentIndex = 1;
  List<Map<String, String>> trainingScheduleList = [
    {
      'ID': '1',
      'Materi': '',
      'Lokasi': '',
      'Hari': '',
      'Jam': '',
    },
    {
      'ID': '2',
      'Materi': '',
      'Lokasi': '',
      'Hari': '',
      'Jam': '',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Training Schedule",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.pinkAccent,
              ),
            ),
            const SizedBox(height: 16),


            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(const Color(0xFFFFF0F5)),
                    dataRowColor: MaterialStateProperty.all(const Color(0xFFFFF0F5)),
                    border: TableBorder.all(color: Colors.black, width: 0.5),
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Materi')),
                      DataColumn(label: Text('Lokasi')),
                      DataColumn(label: Text('Hari')),
                      DataColumn(label: Text('Jam')),
                    ],
                    rows: trainingScheduleList.map((data) {
                      return DataRow(cells: [
                        DataCell(Text(data['ID'] ?? 'N/A')), 
                        DataCell(Text(data['Materi'] ?? 'N/A')), 
                        DataCell(Text(data['Lokasi'] ?? 'N/A')), 
                        DataCell(Text(data['Hari'] ?? 'N/A')), 
                        DataCell(Text(data['Jam'] ?? 'N/A')), 
                      ]);
                    }).toList(),
                  ),
                ),
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
            Color.fromARGB(255, 244, 229, 186),
          ],
        ),
      ),
  child: BottomNavigationBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    currentIndex: _currentIndex,
    selectedItemColor: const Color.fromARGB(255, 255, 255, 255), 
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

  Widget buildMenuItem(IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.pink[100]!, Color.fromARGB(255, 244, 229, 186)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: Colors.grey[800]),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[800]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
