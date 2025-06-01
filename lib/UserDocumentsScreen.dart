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

  Map<String, String?> fileNames = {};
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Upload Your Documents",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 32),
              Expanded(
                child: ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    String documentType = documents.keys.elementAt(index);
                    String? displayName = fileNames[documentType];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          title: Text(
                            documentType.replaceAll('_', ' ').toUpperCase(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: displayName != null
                              ? Text(
                                  displayName,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                )
                              : null,
                          trailing: ElevatedButton(
                            onPressed: () => pickFile(documentType),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 250, 195, 213),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            child: Text(
                              'Choose File',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : uploadDocuments,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 250, 195, 213),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 18),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}