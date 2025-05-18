import 'package:flutter/material.dart';
import 'dataPersonal.dart';

class CompleteDataPage extends StatefulWidget {
  const CompleteDataPage({Key? key}) : super(key: key);

  @override
  _CompleteDataPageState createState() => _CompleteDataPageState();
}

class _CompleteDataPageState extends State<CompleteDataPage> {
  final Map<String, TextEditingController> controllers = {};
  String selectedOption = 'ex';

  final Map<String, String> previousData = {
    'ID PMI': '12345',
    'Tgl. Pendaftaran': '2024-01-01',
    'Nama Lengkap': 'Dewi Ayu',
    'Tempat Lahir': 'Bandung',
    'Tgl. Lahir': '2000-12-12',
    'NIK': '3201011234567890',
  };

  @override
  void initState() {
    super.initState();
    for (var key in _formFields) {
      controllers[key] = TextEditingController(text: previousData[key] ?? '');
    }
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  List<String> get _formFields => [
        'ID PMI',
        'Tgl. Pendaftaran',
        'Nama Lengkap',
        'Tempat Lahir',
        'Tgl. Lahir',
        'NIK',
        'No. KK',
        'No. Paspor',
        'No. KTP',
        'No. Ijazah',
        'Full Medical',
        'Pra Medical',
        'Jabatan',
        'Visa',
        'Status Pernikahan',
        'Sponsor',
        'Tgl. Pendaftaran ID',
        'Tgl. Keberangkatan',
        'Tgl. Kepulangan',
        'Pass Foto',
        'Foto Visa',
        'Foto KTP',
        'Foto Akta Kelahiran',
        'Foto KK',
        'SKCK',
        'Foto PP',
        'Foto Surat Izin',
        'Foto Ijazah',
      ];

  void _clearData() {
    for (var controller in controllers.values) {
      controller.clear();
    }
  }

  void _deleteData() {
    setState(() {
      for (var controller in controllers.values) {
        controller.clear();
      }
      selectedOption = 'ex';
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Data berhasil dihapus'),
      backgroundColor: const Color.fromARGB(255, 247, 198, 229),
    ));
  }

  void _saveData() {
    print('Data tersimpan!');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Data berhasil disimpan'),
      backgroundColor: const Color.fromARGB(255, 247, 198, 229),
    ));
  }

  void _navigateToEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PersonalDataPage()), 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Personal Data"),
        foregroundColor: Colors.pinkAccent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                children: [
                  for (var field in controllers.entries)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: TextField(
                        controller: field.value,
                        enabled: false, // tidak bisa diedit di sini
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
                          onChanged: null, // disabled
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: _navigateToEdit,
                    icon: Icon(Icons.edit),
                    label: Text('Edit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 247, 198, 229),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _saveData,
                    icon: Icon(Icons.save),
                    label: Text('Save'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 247, 198, 229),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _clearData,
                    icon: Icon(Icons.clear),
                    label: Text('Clear'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 247, 198, 229),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _deleteData,
                    icon: Icon(Icons.delete),
                    label: Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 247, 198, 229),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
