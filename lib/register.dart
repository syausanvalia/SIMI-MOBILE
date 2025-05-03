import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(MaterialApp(
    home: RegisterPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String gender = 'female';
  bool passwordVisible = false;

  // Tambahkan controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                            activeColor:
                                const Color.fromARGB(255, 244, 238, 197),
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
                  Container(
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
                      onPressed: () {
                        String email = emailController.text.trim();

                        if (!email.contains('@gmail')) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Email must contain '@gmail'"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        }
                      },
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
