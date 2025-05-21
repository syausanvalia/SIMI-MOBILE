import 'package:flutter/material.dart';
import 'GoogleSuccessPage.dart';
import 'login.dart';
import 'custom_navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: GlobalKey<NavigatorState>(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        if (settings.name?.startsWith('/google-success') ?? false) {
          return MaterialPageRoute(
            builder: (context) => const GoogleSuccessPage(),
            settings: settings,
          );
        }
        
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginPage());
          case '/dashboard':
            return MaterialPageRoute(builder: (_) => const CustomNavBarPage());
          default:
            return MaterialPageRoute(builder: (_) => const LoginPage());
        }
      },
    );
  }
}