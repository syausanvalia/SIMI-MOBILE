import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'completeData.dart';
import 'dataPersonal2.dart';

class UploadDocumentsPage extends StatefulWidget {
  @override
  _UploadDocumentsPageState createState() => _UploadDocumentsPageState();
}

class _UploadDocumentsPageState extends State<UploadDocumentsPage> {
 String selectedOption = 'ex';
 Map<String, String?> uploadedFiles = {};

  final List<String> documents = [
    "Pass Foto", "VISA", "Foto KTP", "Akta Kelahiran", "Foto KK",
    "SKCK", "PP", "Surat Izin", "Foto Ijazah",
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PersonalData2Page()),
                      );
                    },
                    child: const Icon(Icons.arrow_back_ios_new, size: 20),
                  ),
                  const Text(
                    "Complete the following documents!",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 20),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...documents.map((doc) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: buildUploadField(doc),
                        )),
                    const SizedBox(height: 24),
                    buildRadioButtons(),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CompleteDataPage()),
                          );
                          print(uploadedFiles);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 3,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          shadowColor: Colors.black.withOpacity(0.2),
                        ),
                        child: const Text(
                          "SAVE",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
       ),
      ),
   );
  }

  Widget buildUploadField(String label) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(label, style: const TextStyle(fontSize: 14)),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: InkWell(
            onTap: () => pickFile(label),
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(
                  uploadedFiles[label] != null ? "File Selected" : "Upload",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildRadioButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio<String>(
          value: 'ex',
          groupValue: selectedOption,
          onChanged: (value) {
            setState(() => selectedOption = value!);
          },
          activeColor: Color(0xFFFFC0CB),
        ),
        const Text("ex"),
        const SizedBox(width: 24),
        Radio<String>(
          value: 'non',
          groupValue: selectedOption,
          onChanged: (value) {
            setState(() => selectedOption = value!);
          },
        ),
        const Text("non"),
      ],
    );
  }

  Future<void> pickFile(String fieldName) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result != null && result.files.single.path != null) {
      setState(() {
        uploadedFiles[fieldName] = result.files.single.path;
      });
    }
  }
}
