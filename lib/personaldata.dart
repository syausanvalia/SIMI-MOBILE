import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:lottie/lottie.dart';
import 'completedata.dart'; // Pastikan file ini ada
import 'UserDocumentsScreen.dart';
import 'api_services.dart';
import 'dashboard.dart';

class PersonalDataScreen extends StatefulWidget {
  @override
  _PersonalDataScreenState createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _idCardController = TextEditingController();
  TextEditingController _citizenIdController = TextEditingController();
  TextEditingController _passportNumberController = TextEditingController();
  TextEditingController _familyCardController = TextEditingController();
  TextEditingController _birthPlaceController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();
  TextEditingController _diplomaNumberController = TextEditingController();
  TextEditingController _preMedicalController = TextEditingController();
  TextEditingController _fullMedicalController = TextEditingController();
  TextEditingController _nikController = TextEditingController();

  bool _isLoading = false;
  bool _alreadySubmitted = false;

  @override
  void initState() {
    super.initState();
    _generateRandomIdPmi();
    _checkIfDataAlreadySubmitted();
  }

  void _generateRandomIdPmi() {
    final random = Random();
    String randomId = '';
    for (int i = 0; i < 6; i++) {
      randomId += random.nextInt(10).toString();
    }
    _idCardController.text = randomId;
  }

  Future<void> _checkIfDataAlreadySubmitted() async {
    final result = await ApiService.getUserProfile();

    if (result['success']) {
      final personalData = result['data']['personal_data'];

      // Cek jika field penting dari personal data tidak null / kosong
      final isFilled = personalData != null &&
          personalData['citizen_id'] != null &&
          personalData['citizen_id'].toString().isNotEmpty;

      if (isFilled) {
        setState(() {
          _alreadySubmitted = true;
        });

        Future.delayed(Duration.zero, () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset('assets/lottie/classtidakbisadiakses.json',
                      width: 180, height: 180, repeat: true),
                  SizedBox(height: 16),
                  Text(
                    'Anda sudah mengisi data dan dokumen, silahkan ke halaman berikut jika ingin mengubah.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => CompletaData()),
                    );
                  },
                  child: Text('OK'),
                )
              ],
            ),
          );
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Gagal memuat data')),
      );
    }
  }

  Future<void> _submitPersonalData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.postPersonalData(
        idCardNumber: _idCardController.text,
        citizenId: _citizenIdController.text,
        passportNumber: _passportNumberController.text,
        familyCardNumber: _familyCardController.text,
        birthPlace: _birthPlaceController.text,
        birthDate: _birthDateController.text,
        diplomaNumber: _diplomaNumberController.text,
        preMedicalCheckup: _preMedicalController.text,
        fullMedicalCheckup: _fullMedicalController.text,
      );

      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Personal data saved successfully')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserDocumentsScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response['message']), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('An error occurred: $e'),
            backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_alreadySubmitted) {
      return Scaffold(
        backgroundColor: Colors.white,
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF9F8FC),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.pink),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CustomNavBarPage()),
            );
          },
        ),
        centerTitle: true,
        title: Text(
          'Personal Data',
          style: TextStyle(color: Colors.pink, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.pink),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Complete your data here !",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 32),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade100,
                    ),
                    child: TextFormField(
                      controller: _idCardController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'ID PMI',
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildPlainField(_citizenIdController, 'No. KTP'),
                  SizedBox(height: 20),
                  _buildPlainField(_nikController, 'NIK'),
                  SizedBox(height: 20),
                  _buildPlainField(_familyCardController, 'No. KK'),
                  SizedBox(height: 20),
                  _buildPlainField(_passportNumberController, 'No. Paspor'),
                  SizedBox(height: 20),
                  _buildPlainField(_birthPlaceController, 'Tempat Lahir'),
                  SizedBox(height: 20),
                  _buildDateOnlyField(_birthDateController, 'Tgl. Lahir'),
                  SizedBox(height: 20),
                  _buildPlainField(_diplomaNumberController, 'No. Ijazah'),
                  SizedBox(height: 20),
                  _buildDateOnlyField(_preMedicalController, 'Pra Medical'),
                  SizedBox(height: 20),
                  _buildDateOnlyField(_fullMedicalController, 'Full Medical'),
                  SizedBox(height: 32),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitPersonalData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 250, 195, 213),
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white))
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Next',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlainField(TextEditingController controller, String label) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: label,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.black54),
        ),
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Please enter $label' : null,
      ),
    );
  }

  Widget _buildDateOnlyField(TextEditingController controller, String label) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          hintText: label,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          border: InputBorder.none,
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.calendar_today, size: 20, color: Colors.grey),
          ),
          hintStyle: TextStyle(color: Colors.black54),
        ),
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (picked != null) {
            controller.text = DateFormat('yyyy-MM-dd').format(picked);
          }
        },
      ),
    );
  }
}
