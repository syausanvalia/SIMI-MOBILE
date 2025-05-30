import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:simi/api_services.dart';

Future<void> showEditBottomSheet(
  BuildContext context,
  String title,
  String initialValue,
  Future<void> Function(dynamic) onSave,

) async {
  final controller = TextEditingController(text: initialValue);
  File? selectedFile;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Edit $title",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: title,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final picker = ImagePicker();
                    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      selectedFile = File(pickedFile.path);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Gambar dipilih: ${pickedFile.name}")),
                      );
                    }
                  },
                  icon: const Icon(Icons.image),
                  label: const Text("Pilih Gambar"),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(type: FileType.any);
                    if (result != null && result.files.single.path != null) {
                      selectedFile = File(result.files.single.path!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("File dipilih: ${result.files.single.name}")),
                      );
                    }
                  },
                  icon: const Icon(Icons.attach_file),
                  label: const Text("Pilih File"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                final value = selectedFile ?? controller.text;
                await onSave(value);

                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.save),
              label: const Text("Simpan"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> showFilePickerBottomSheet(
  BuildContext context,
  String title,
  String initialValue,
  Function(String) onSave,
) async {
  final controller = TextEditingController(text: initialValue);

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Edit $title",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: title,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  allowMultiple: false,
                  type: FileType.any,
                );

                if (result != null && result.files.single.path != null) {
                  final file = File(result.files.single.path!);
                  final uploadResult = await ApiService.updateUserProfile({'document': file});

                  if (uploadResult['success']) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(uploadResult['message'])));
                    onSave(file.path);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(uploadResult['message'])));
                  }
                }
              },
              icon: const Icon(Icons.upload_file),
              label: const Text("Upload File"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                onSave(controller.text);
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.save),
              label: const Text("Simpan"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      );
    },
  );
}

