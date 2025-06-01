import 'package:flutter/material.dart';
import 'package:simi/homepage.dart';
import 'GoogleSuccessPage.dart';
import 'login.dart';
import 'custom_navbar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('id'),
        const Locale('en'),
      ],
      initialRoute: '/homepage',
      onGenerateRoute: (settings) {
        if (settings.name?.startsWith('/google-success') ?? false) {
          return MaterialPageRoute(
            builder: (context) => const GoogleSuccessPage(),
            settings: settings,
          );
        }

        switch (settings.name) {
          case '/homepage':
            return MaterialPageRoute(builder: (_) => const HomePage());
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginPage());
          case '/dashboard':
            return MaterialPageRoute(builder: (_) => const CustomNavBarPage());
          default:
            return MaterialPageRoute(builder: (_) => const HomePage());
        }
      },
    );
  }
}
