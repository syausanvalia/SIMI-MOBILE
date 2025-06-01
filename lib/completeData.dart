import 'package:flutter/material.dart';
import 'package:simi/api_services.dart';
import 'edit_buttom_sheet.dart';

class CompletaData extends StatefulWidget {
  const CompletaData({super.key});

  @override
  State<CompletaData> createState() => _CompletaDataState();
}

class _CompletaDataState extends State<CompletaData> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  // Peta nama label ke nama field di backend
  final Map<String, String> fieldKeyMap = {
    // Personal Data
    "No KTP": "id_card_number",
    "No KK": "family_card_number",
    "No Paspor": "passport_number",
    "Tempat Lahir": "birth_place",
    "Tanggal Lahir": "birth_date",
    "No Ijazah": "diploma_number",
    "Pre Medical": "pre_medical_checkup",
    "Full Medical": "full_medical_checkup",

    // Documents
    "Sertifikat Vaksin": "vaccine_certificate",
    "Surat Izin": "permit_letter",
    "SKCK": "police_clearance",
    "Akte Nikah": "marriage_certificate",
    "Paspor": "passport",
    "KTP": "identity_card",
    "Ijazah": "diploma",
    "Kartu Keluarga": "family_register",

    // User Details
    "Nama Agency": "agency_name",
    "Posisi": "position",
    "Visa TETO": "visa_teto",
    "Sponsor": "sponsor",
  };

  // Tentukan bagian data dari field
  String getSection(String label) {
    if ([
      "No KTP",
      "No KK",
      "No Paspor",
      "Tempat Lahir",
      "Tanggal Lahir",
      "No Ijazah",
      "Pre Medical",
      "Full Medical"
    ].contains(label)) return "personal_data";

    if ([
      "Sertifikat Vaksin",
      "Surat Izin",
      "SKCK",
      "Akte Nikah",
      "Paspor",
      "KTP",
      "Ijazah",
      "Kartu Keluarga"
    ].contains(label)) return "user_documents";

    return "user_details";
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final result = await ApiService.getUserProfile();
    if (result['success']) {
      setState(() {
        userData = result['data'];
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  Map<String, String> _formatPersonalData() {
    final personal = userData?['personal_data'] ?? {};
    return {
      "No KTP": personal['id_card_number'] ?? '',
      "No KK": personal['family_card_number'] ?? '',
      "No Paspor": personal['passport_number'] ?? '',
      "Tempat Lahir": personal['birth_place'] ?? '',
      "Tanggal Lahir": personal['birth_date'] ?? '',
      "No Ijazah": personal['diploma_number'] ?? '',
      "Pre Medical": personal['pre_medical_checkup'] ?? '',
      "Full Medical": personal['full_medical_checkup'] ?? '',
    };
  }

  Map<String, String> _formatUserDetails() {
    final details = userData?['user_details'] ?? {};
    return {
      "Nama Agency": details['agency_name'] ?? '',
      "Posisi": details['position'] ?? '',
      "Visa TETO": details['visa_teto'] ?? '',
      "Sponsor": details['sponsor'] ?? '',
    };
  }

  Map<String, String> _formatUserDocuments() {
    final documents = userData?['user_documents'] ?? {};
    return {
      "Sertifikat Vaksin": documents['vaccine_certificate'] ?? '',
      "Surat Izin": documents['permit_letter'] ?? '',
      "SKCK": documents['police_clearance'] ?? '',
      "Akte Nikah": documents['marriage_certificate'] ?? '',
      "Paspor": documents['passport'] ?? '',
      "KTP": documents['identity_card'] ?? '',
      "Ijazah": documents['diploma'] ?? '',
      "Kartu Keluarga": documents['family_register'] ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Informasi Pengguna"),
          backgroundColor: Colors.pink[300],
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Informasi Pengguna"),
        foregroundColor: Colors.pink,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("🧍 Data Pribadi"),
            ..._buildInfoList(_formatPersonalData(), context),
            const SizedBox(height: 24),

            _buildSectionTitle("📁 Dokumen Pengguna"),
            ..._buildInfoList(_formatUserDocuments(), context, isDocument: true),
            const SizedBox(height: 24),

            _buildSectionTitle("🏢 Detail Pengguna"),
            ..._buildInfoList(_formatUserDetails(), context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.pink,
        ),
      ),
    );
  }

  List<Widget> _buildInfoList(
    Map<String, String> data,
    BuildContext context, {
    bool isDocument = false,
  }) {
    return data.entries.map((entry) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: ListTile(
          title: Text(entry.key),
          subtitle: Text(entry.value),
          trailing: Hero(
            tag: '${entry.key}-edit',
            child: IconButton(
              icon: const Icon(Icons.edit, color: Colors.pink),
              onPressed: () {
                showEditBottomSheet(
                  context,
                  entry.key,
                  entry.value,
                  (newValue) async {
                    final fieldName = fieldKeyMap[entry.key];
                    final section = getSection(entry.key);

                    if (fieldName == null) return;

                          final updateData = {
                          fieldName: newValue,
                  };


                    final result = await ApiService.updateUserProfile(updateData);

                    if (result['success']) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Berhasil diperbarui")),
                      );
                      fetchUserData();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Gagal memperbarui: ${result['message']}")),
                      );
                    }
                  },
                );
              },
            ),
          ),
          onTap: isDocument
              ? () {
                  // Implementasi preview dokumen jika perlu
                }
              : null,
        ),
      );
    }).toList();
  }
}
