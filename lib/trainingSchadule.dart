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
      ),
    );
  }
}
