import 'package:flutter/material.dart';
import 'custom_navbar.dart';
import 'api_services.dart';

class UserDetailsScreen extends StatefulWidget {
  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _agencyNameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _visaTetoController = TextEditingController();
  final TextEditingController _sponsorController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _agencyNameController.dispose();
    _positionController.dispose();
    _visaTetoController.dispose();
    _sponsorController.dispose();
    super.dispose();
  }

  Future<void> _submitUserDetails() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.submitUserDetails(
        agencyName: _agencyNameController.text.trim(),
        position: _positionController.text.trim(),
        visaTeto: _visaTetoController.text.trim(),
        sponsor: _sponsorController.text.trim(),
      );

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data submitted successfully')),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => CustomNavBarPage()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Submission failed'),
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

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
        backgroundColor: Color.fromARGB(255, 250, 195, 213),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.pink[50]!],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(_agencyNameController, 'Agency Name'),
                _buildTextField(_positionController, 'Position'),
                _buildTextField(_visaTetoController, 'Visa Teto'),
                _buildTextField(_sponsorController, 'Sponsor'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitUserDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 250, 195, 213),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Finish'),
                            SizedBox(width: 8),
                            Icon(Icons.check),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
