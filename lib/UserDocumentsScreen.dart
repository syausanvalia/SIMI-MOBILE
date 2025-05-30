import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:simi/UserDocumentsScreen.dart';
import 'UserDetails.dart';
import 'api_services.dart';

class UserDocumentsScreen extends StatefulWidget {
  @override
  _UserDocumentsScreenState createState() => _UserDocumentsScreenState();
}

class _UserDocumentsScreenState extends State<UserDocumentsScreen> {
  Map<String, String?> documents = {
    'vaccine_certificate': null,
    'permit_letter': null,
    'police_clearance': null,
    'marriage_certificate': null,
    'passport': null,
    'identity_card': null,
    'diploma': null,
    'family_register': null,
  };

  Map<String, String?> fileNames = {}; // Untuk menampilkan nama file ke UI

  bool _isLoading = false;

  Future<void> pickFile(String documentType) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        documents[documentType] = result.files.single.path;
        fileNames[documentType] = result.files.single.name;
      });
    } else {
      // Optional: bisa kasih feedback kalau gagal pilih file
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick file.')),
      );
    }
  }

  Future<void> uploadDocuments() async {
    if (documents.values.any((value) => value == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload all required documents')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, String> filesToUpload = Map.fromEntries(
        documents.entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );

      final response = await ApiService.uploadUserDocuments(
        documents: filesToUpload,
      );

      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Documents uploaded successfully')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailsScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
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
                  String? displayName = fileNames[documentType];

                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(documentType),
                      subtitle: displayName != null
                          ? Text(displayName)
                          : Text('No file selected'),
                      trailing: ElevatedButton(
                        onPressed: () => pickFile(documentType),
                        child: Text('Pick File'),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _isLoading ? null : uploadDocuments,
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Row(
                            children: [
                              Text('Next'),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward),
                            ],
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 250, 195, 213),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
