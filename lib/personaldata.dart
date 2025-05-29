import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'UserDocumentsScreen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Data'),
        backgroundColor: Color.fromARGB(255, 250, 195, 213),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color.fromARGB(255, 250, 195, 213)!],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(_idCardController, 'ID Card Number'),
                _buildTextField(_citizenIdController, 'Citizen ID'),
                _buildTextField(_passportNumberController, 'Passport Number'),
                _buildTextField(_familyCardController, 'Family Card Number'),
                _buildTextField(_birthPlaceController, 'Birth Place'),
                _buildDateField(_birthDateController, 'Birth Date'),
                _buildTextField(_diplomaNumberController, 'Diploma Number'),
                _buildDateField(_preMedicalController, 'Pre Medical Checkup Date'),
                _buildDateField(_fullMedicalController, 'Full Medical Checkup Date'),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserDocumentsScreen(),
                            ),
                          );
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) => (value == null || value.isEmpty) ? 'Please enter $label' : null,
      ),
    );
  }

  Widget _buildDateField(TextEditingController controller, String label) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
          suffixIcon: Icon(Icons.calendar_today),
        ),
        readOnly: true,
        onTap: () async {
          final DateTime? picked = await showDatePicker(
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
