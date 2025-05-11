import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dataPersonal.dart';
import 'upDokumen.dart';

void main() {
  runApp(MaterialApp(
    home: PersonalData2Page(),
    debugShowCheckedModeBanner: false,
  ));
}

class PersonalData2Page extends StatefulWidget {
  @override
  _PersonalData2PageState createState() => _PersonalData2PageState();
}

class _PersonalData2PageState extends State<PersonalData2Page> {
  String? selectedStatus;
  int _currentIndex = 1;

  final List<String> statusOptions = ['Belum Menikah', 'Menikah'];

  final TextEditingController _tglPendaftaranController = TextEditingController();
  final TextEditingController _tglKeberangkatanController = TextEditingController();
  final TextEditingController _tglKepulanganController = TextEditingController();

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  void dispose() {
    _tglPendaftaranController.dispose();
    _tglKeberangkatanController.dispose();
    _tglKepulanganController.dispose();
    super.dispose();
  }

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PersonalDataPage()),
                      );
                    },
                    child: const Icon(Icons.arrow_back_ios_new, size: 20),
                  ),
                  const Text(
                    "complete the following documents !",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UploadDocumentsPage()),
                      );
                    },
                    child: const Icon(Icons.arrow_forward_ios, size: 20),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSingleField("Jabatan"),
                    const SizedBox(height: 16),
                    buildSingleField("VISA"),
                    const SizedBox(height: 16),
                    buildDropdownField("Status Pernikahan"),
                    const SizedBox(height: 16),
                    buildSingleField("Sponsor"),
                    const SizedBox(height: 24),
                    buildDateField("Tgl. Pendaftaran ID", _tglPendaftaranController),
                    const SizedBox(height: 16),
                    buildDateField("Tgl. Keberangkatan", _tglKeberangkatanController),
                    const SizedBox(height: 16),
                    buildDateField("Tgl. Kepulangan", _tglKepulanganController),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSingleField(String label) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: const UnderlineInputBorder(),
      ),
    );
  }

  Widget buildDropdownField(String label) {
    return InputDecorator(
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(label),
          value: selectedStatus,
          isExpanded: true,
          items: statusOptions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              selectedStatus = newValue;
            });
          },
        ),
      ),
    );
  }

  Widget buildDateField(String label, TextEditingController controller) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              labelText: label,
              border: const UnderlineInputBorder(),
            ),
            onTap: () => _selectDate(context, controller),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.calendar_today_outlined, size: 20),
          onPressed: () => _selectDate(context, controller),
        ),
      ],
    );
  }
}
