import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: JobInfoPage(),
  ));
}

class JobInfoPage extends StatefulWidget {
  @override
  _JobInfoPageState createState() => _JobInfoPageState();
}

class _JobInfoPageState extends State<JobInfoPage> {
  int _currentIndex = 1;

  final List<Map<String, String>> jobList = [
    {
      'company': 'PT. Si Hao',
      'position': 'Baby Siter',
      'salary': 'IDK 15.000K',
      'desc':
          'Dicari tenaga ahli yang berpengalaman dalam mengasuh anak usia 6 tahun dan 12 tahun.'
    },
    {
      'company': 'CV. Naspad',
      'position': 'IT Controller',
      'salary': 'IDK 20.000K',
      'desc':
          'Bagi kalian yang memiliki antusiasi dalam bidang IT khususnya di design grafis, video kreator, DevOps dan .....'
    },
    {
      'company': 'CV. Naspad',
      'position': 'IT Controller',
      'salary': 'IDK 20.000K',
      'desc':
          'Bagi kalian yang memiliki antusiasi dalam bidang IT khususnya di design grafis, video kreator, DevOps dan .....'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Back Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back, size: 28),
                  ),
                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Informasi Pekerjaan",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.pinkAccent,
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),


            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: jobList.length,
                itemBuilder: (context, index) {
                  final job = jobList[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job['company']!,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          job['position']!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            text: job['salary'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: "/bulan",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          job['desc']!,
                          style: TextStyle(        
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
