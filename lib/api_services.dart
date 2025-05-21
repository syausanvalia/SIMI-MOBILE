import 'dart:convert';
import 'package:flutter/foundation.dart'; // Untuk kIsWeb
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'auth_middleware.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        await AuthMiddleware.saveAuthData(data['token'], data['data']);
        return {
          'success': true,
          'data': data['data'],
          'token': data['token'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login gagal',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      if (kIsWeb) {
        // Flutter Web → buka tab login
        final webUrl = '$baseUrl/api/auth/google?platform=web';
        await launchUrl(Uri.parse(webUrl), mode: LaunchMode.platformDefault);

        // User akan dialihkan ke halaman #/google-success?data=...
        // Tangani parsingnya di halaman Flutter Web `/google-success`

        return {
          'success': false,
          'message': 'Tunggu redirect ke halaman sukses.',
        };
      } else {
        // Flutter Mobile → WebAuth
        final redirectUrl =
            Uri.parse('$baseUrl/api/auth/google?platform=mobile');
        final callbackUrlScheme =
            'com.example.simi'; // Sesuaikan dengan Android/iOS config

        final result = await FlutterWebAuth.authenticate(
          url: redirectUrl.toString(),
          callbackUrlScheme: callbackUrlScheme,
        );

        final uri = Uri.parse(result);
        final encodedData = uri.queryParameters['data'];

        if (encodedData == null) {
          return {
            'success': false,
            'message': 'Data login tidak ditemukan dari server.',
          };
        }

        final decodedJson =
            json.decode(utf8.decode(base64.decode(encodedData)));
        final status = decodedJson['status'] ?? false;
        final message = decodedJson['message'] ?? 'Login gagal';
        final token = decodedJson['token'];

        if (status && token != null) {
          await AuthMiddleware.saveAuthData(token, decodedJson['data'] ?? {});
          return {
            'success': true,
            'message': message,
            'token': token,
          };
        } else {
          return {
            'success': false,
            'message': message,
          };
        }
      }
    } catch (e) {
      print("❌ Error saat login Google: $e");
      return {
        'success': false,
        'message': 'Kesalahan saat login: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> register(String username, String email,
      String password, String noTelp, String jk) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'no_telp': noTelp,
          'JK': jk,
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['status'] == true) {
        await AuthMiddleware.saveAuthData(data['token'], data['data']);
        return {
          'success': true,
          'data': data['data'],
          'token': data['token'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registrasi gagal',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  static Future<bool> logout() async {
  final token = await AuthMiddleware.getToken();

  if (token != null && token.isNotEmpty) {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/logout'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      print("❌ Error saat kirim logout: $e");
    }
  }

  await AuthMiddleware.logout(); // Tetap bersihkan data lokal
  return true;
}


  static Future<bool> isAuthenticated() async {
  final token = await AuthMiddleware.getToken();
  if (token == null || token.isEmpty) return false;

  try {
    final response = await http.get(
      Uri.parse('$baseUrl/api/check-token'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return response.statusCode == 200;
  } catch (_) {
    return false;
  }
}
static Future<Map<String, dynamic>> getDashboard() async {
  final token = await AuthMiddleware.getToken();
  if (token == null || token.isEmpty) {
    return {
      'success': false,
      'message': 'Token tidak ditemukan',
    };
  }

  try {
    final response = await http.get(
      Uri.parse('$baseUrl/api/auth/dashboard'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['status'] == true) {
      return {
        'success': true,
        'data': data['data'],
      };
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Gagal memuat dashboard',
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'Terjadi kesalahan: $e',
    };
  }
}

}
