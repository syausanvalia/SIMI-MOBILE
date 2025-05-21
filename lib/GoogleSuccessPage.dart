import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_middleware.dart';

class GoogleSuccessPage extends StatefulWidget {
  const GoogleSuccessPage({super.key});

  @override
  _GoogleSuccessPageState createState() => _GoogleSuccessPageState();
}

class _GoogleSuccessPageState extends State<GoogleSuccessPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleRedirectData();
    });
  }

  Future<void> _handleRedirectData() async {
    try {
      final dataParam = Uri.base.fragment.contains('?')
          ? Uri.splitQueryString(Uri.base.fragment.split('?')[1])['data']
          : Uri.base.queryParameters['data'];

      if (dataParam == null) {
        _redirectTo('/login');
        return;
      }

      final decodedJson = json.decode(utf8.decode(base64.decode(dataParam))) 
          as Map<String, dynamic>;

      final token = decodedJson['token'];
      final userData = decodedJson['data'];

      if (token != null) {
        await AuthMiddleware.saveAuthData(token, userData ?? {});
        _redirectTo('/dashboard');
      } else {
        _redirectTo('/login');
      }
    } catch (e) {
      print('❌ Error parsing Google success data: $e');
      if (mounted) {
        _redirectTo('/login');
      }
    }
  }

  void _redirectTo(String route) {
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Menyelesaikan login Google...')),
    );
  }
}