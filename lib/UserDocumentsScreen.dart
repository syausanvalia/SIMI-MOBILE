import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:simi/UserDocumentsScreen.dart';
import 'UserDetails.dart';

class UserDocumentsScreen extends StatefulWidget {
  @override
  _UserDocumentsScreenState createState() => _UserDocumentsScreenState();
}

class _UserDocumentsScreenState extends State<UserDocumentsScreen> {
  Map<String, String?> documents = {
    'Vaccine Certificate': null,
    'Permit Letter': null,
    'Police Clearance': null,
    'Marriage Certificate': null,
    'Passport': null,
    'Identity Card': null,
    'Diploma': null,
    'Family Register': null,
  };

  Future<void> pickFile(String documentType) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
    );

    if (result != null) {
      setState(() {
        documents[documentType] = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Documents'),
        backgroundColor: Colors.pink[100],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.pink[50]!],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16.0),
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  String documentType = documents.keys.elementAt(index);
                  String? fileName = documents[documentType];

                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(documentType),
                      subtitle: fileName != null
                          ? Text(fileName)
                          : Text('No file selected'),
                      trailing: ElevatedButton(
                        onPressed: () => pickFile(documentType),
                        child: Text('Upload'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 250, 195, 213),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back),
                        SizedBox(width: 8),
                        Text('Previous'),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 250, 195, 213),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailsScreen(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Text('Next'),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 250, 195, 213),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
