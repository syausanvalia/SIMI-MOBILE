import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:simi/api_services.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String gender = 'female';
  bool passwordVisible = false;
  bool isLoading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void register() async {
    // Validasi input sebelum request ke API
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().length < 8 ||
        phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Harap isi semua data dengan benar.\nPassword minimal 8 karakter.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final result = await ApiService.register(
      nameController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim(),
      phoneController.text.trim(),
      gender == 'male' ? 'pria' : 'wanita',
    );

    setState(() {
      isLoading = false;
    });

    if (result['success']) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/lottie/success.json', height: 120),
              SizedBox(height: 16),
              Text(
                'Registrasi Berhasil!',
                style: TextStyle(
                  color: Colors.pink.shade300,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage()),
                  );
                },
                child: Text('Lanjut ke Login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade100,
                  foregroundColor: Colors.white,
                ),
              )
            ],
          ),
        ),
      );
    } else {
      // Tampilkan pesan error validasi detail jika ada
      String message = result['message'] ?? 'Gagal mendaftar';

      // Jika API mengembalikan errors detail (seperti validasi Laravel 422)
      if (result['errors'] != null) {
        final errors = result['errors'] as Map<String, dynamic>;
        message = errors.values
            .map((e) => (e as List).first.toString())
            .join('\n');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Welcome",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(2, 2),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Register if you don't have an account yet",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 24),
                  buildInputField(Icons.person, 'Name', nameController),
                  SizedBox(height: 16),
                  buildInputField(Icons.email, 'Email', emailController),
                  SizedBox(height: 16),
                  buildInputField(Icons.phone, 'Phone', phoneController),
                  SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: !passwordVisible,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Radio(
                            value: 'female',
                            groupValue: gender,
                            activeColor: Colors.pink.shade200,
                            onChanged: (value) {
                              setState(() {
                                gender = value.toString();
                              });
                            },
                          ),
                          Text('Female'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: 'male',
                            groupValue: gender,
                            activeColor: Color.fromARGB(255, 244, 238, 197),
                            onChanged: (value) {
                              setState(() {
                                gender = value.toString();
                              });
                            },
                          ),
                          Text('Male'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  isLoading
                      ? CircularProgressIndicator()
                      : Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.pink.shade100,
                                Color.fromARGB(255, 255, 243, 214),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ElevatedButton(
                            onPressed: register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              "REGISTER",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
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

  Widget buildInputField(
      IconData icon, String hintText, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
