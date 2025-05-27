import 'dart:convert';
import 'package:flutter/foundation.dart'; // Untuk kIsWeb
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'auth_middleware.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class ApiService {
  static const String baseUrl =
      'https://saddlebrown-louse-528508.hostingersite.com';

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
      final callbackUrlScheme = 'com.example.simi';
      final authUrl = '$baseUrl/api/auth/google?platform=mobile';

      print('Starting Google Auth with URL: $authUrl');

      final result = await FlutterWebAuth.authenticate(
        url: authUrl,
        callbackUrlScheme: callbackUrlScheme,
      );

      print('Auth Result: $result'); 

      final uri = Uri.parse(result);
      final encodedData = uri.queryParameters['data'];

      if (encodedData == null) {
        print('No encoded data found in callback'); 
        return {
          'success': false,
          'message': 'Data tidak ditemukan dari callback URL.',
        };
      }

      final decodedJson = json.decode(utf8.decode(base64.decode(encodedData)));
      print('Decoded JSON: $decodedJson'); 

      final token = decodedJson['token'];
      final status = decodedJson['status'] ?? false;

      if (status && token != null) {
        await AuthMiddleware.saveAuthData(token, decodedJson['data']);
        return {
          'success': true,
          'token': token,
          'message': 'Login sukses',
        };
      } else {
        return {
          'success': false,
          'message': decodedJson['message'] ?? 'Login gagal',
        };
      }
    } catch (e) {
      print('Google login error: $e'); 
      return {
        'success': false,
        'message': 'Kesalahan saat login Google: $e',
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

    await AuthMiddleware.logout();
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

  static Future<Map<String, dynamic>> sendOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/forgot-password'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);
      return {
        'success': response.statusCode == 200,
        'message': data['message'],
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> verifyOtp(
      String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/verify-opt'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'otp': otp,
        }),
      );

      final data = jsonDecode(response.body);
      return {
        'success': response.statusCode == 200,
        'message': data['message'],
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> resetPassword(String email, String otp,
      String password, String passwordConfirmation) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/reset-password'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'otp': otp,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      final data = jsonDecode(response.body);
      return {
        'success': response.statusCode == 200,
        'message': data['message'],
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  static Future<List<dynamic>> getNews({String? token}) async {
    try {
      token ??= await AuthMiddleware.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/api/auth/news'),
        headers: {
          'Accept': 'application/json',
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        return data['data'];
      } else {
        throw Exception(data['message'] ?? 'Gagal memuat berita');
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke API: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getJobs() async {
    try {
      final token = await AuthMiddleware.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/api/auth/jobs'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getTrainings() async {
    try {
      final token = await AuthMiddleware.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/api/auth/trainings'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> getTrainingRegistrations() async {
    try {
      final token = await AuthMiddleware.getToken();
      if (token == null) {
        throw Exception('Token tidak ditemukan. Silakan login ulang.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/auth/training-registrations'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == true || data['success'] == true) {
          return {
            'success': true,
            'data': data['data'] ?? [],
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Gagal mengambil data.',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Gagal mengambil data. Status: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> postTrainingRegistration(
      int trainingId) async {
    try {
      final token = await AuthMiddleware.getToken();

      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/training-registrations'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'training_id': trainingId,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['status'] == true) {
        return {
          'success': true,
          'message': data['message'],
          'data': data['data'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Pendaftaran gagal',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> submitPayment({
    required int trainingRegistrationId,
    required String invoiceCode,
    required DateTime transferDate,
    required String transferTime,
    required File proofOfTransfer,

   
  }) async {
    
    try {
      final token = await AuthMiddleware.getToken();
      var request = http.MultipartRequest(
          'POST', Uri.parse('$baseUrl/api/auth/payments'));

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      String formattedDate = DateFormat('yyyy-MM-dd').format(transferDate);

      request.fields.addAll({
        'training_registration_id': trainingRegistrationId.toString(),
        'invoice_code': invoiceCode,
        'transfer_date': formattedDate,
        'transfer_time': transferTime,
      });

      // Log sebelum mengirim request
      print('Sending fields:');
      request.fields.forEach((key, value) {
        print('$key: $value');
      });

      // Tambahkan file
      var fileStream = http.ByteStream(proofOfTransfer.openRead());
      var length = await proofOfTransfer.length();
      
      var multipartFile = http.MultipartFile(
        'proof_of_transfer',
        fileStream,
        length,
        filename: proofOfTransfer.path.split('/').last,
      );
      
      request.files.add(multipartFile);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return {
          'success': true,
          'message': jsonResponse['message'] ?? 'Pembayaran berhasil'
        };
      } else {
        final jsonResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': jsonResponse['message'] ?? 'Gagal mengirim pembayaran',
          'errors': jsonResponse['errors'] // tambahkan ini untuk melihat detail error
        };
      }
    } catch (e) {
      print('Error exception: $e');
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }
  
static Future<Map<String, dynamic>> cancelTrainingRegistration(int id) async {
  try {
    final token = await AuthMiddleware.getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/api/auth/training-registrations/$id/cancel'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['status'] == true) {
      return {
        'success': true,
        'message': data['message'],
      };
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Pembatalan gagal',
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
