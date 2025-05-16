import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: GraduationPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class GraduationPage extends StatefulWidget {
  const GraduationPage({super.key});

  @override
  State<GraduationPage> createState() => _GraduationPageState();
}

class _GraduationPageState extends State<GraduationPage> {
  int currentIndex = 1;
  List<Map<String, String>> trainingScheduleList = [
    {
      'ID': '1',
      'Nama': '',
      'KKM': '',
      'Nilai': '',
      'Status': '',
    },
    {
      'ID': '1',
      'Nama': '',
      'KKM': '',
      'Nilai': '',
      'Status': '',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [

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
              "Graduation",
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
                      DataColumn(label: Text('Nama')),
                      DataColumn(label: Text('KKM')),
                      DataColumn(label: Text('Nilai')),
                      DataColumn(label: Text('Status')),
                    ],
                    rows: trainingScheduleList.map((data) {
                      return DataRow(cells: [
                        DataCell(Text(data['ID'] ?? 'N/A')), 
                        DataCell(Text(data['Nama'] ?? 'N/A')), 
                        DataCell(Text(data['KKM'] ?? 'N/A')), 
                        DataCell(Text(data['Nilai'] ?? 'N/A')), 
                        DataCell(Text(data['Status'] ?? 'N/A')), 
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
