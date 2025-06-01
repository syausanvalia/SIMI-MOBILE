import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
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
        'errors': data['errors'], 
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
          'errors': jsonResponse['errors'] 
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
 static Future<List<Map<String, String>>> fetchTrainingSchedule() async {
  try {
    final token = await AuthMiddleware.getToken();
    final url = Uri.parse('$baseUrl/api/auth/user/training-schedules');

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final List<Map<String, String>> result = [];

      for (var item in data['data']) {
        final training = item['training'];
        final schedules = training['schedules'] as List;

        for (var schedule in schedules) {
          result.add({
            'ID': item['id'].toString(),
            'Materi': schedule['training_material'] ?? '',
            'Lokasi': schedule['location'] ?? '',
            'Hari': schedule['day'] ?? '',
            'Jam': schedule['time'] ?? '',
            'Durasi': schedule['duration'].toString(),
            'Mulai': schedule['start_date'] ?? '',
            'Selesai': schedule['end_date'] ?? '',
          });
        }
      }

      return result;
    } else {
      throw Exception('Failed to load training schedule. Status: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching training schedule: $e');
  }
}

static Future<List<Map<String, dynamic>>> fetchExamScores() async {
  try {
    final token = await AuthMiddleware.getToken();
    final url = Uri.parse('$baseUrl/api/auth/exam-scores');

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true && data['data'] != null) {
        return List<Map<String, dynamic>>.from(data['data']);
      }
      return [];
    } else {
      throw Exception('Failed to load exam scores. Status: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching exam scores: $e');
  }
}

static Future<Map<String, dynamic>> postPersonalData({
  required String idCardNumber,
  required String citizenId,
  required String passportNumber,
  required String familyCardNumber,
  required String birthPlace,
  required String birthDate,
  required String diplomaNumber,
  required String preMedicalCheckup,
  required String fullMedicalCheckup,
}) async {
  try {
    final token = await AuthMiddleware.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/personal-data'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_card_number': idCardNumber,
        'citizen_id': citizenId,
        'passport_number': passportNumber,
        'family_card_number': familyCardNumber,
        'birth_place': birthPlace,
        'birth_date': birthDate,
        'diploma_number': diplomaNumber,
        'pre_medical_checkup': preMedicalCheckup,
        'full_medical_checkup': fullMedicalCheckup,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return {
        'success': true,
        'message': data['message'],
        'data': data['data'],
      };
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Failed to save personal data',
        'errors': data['errors'],
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'Error occurred: $e',
    };
  }
}

static Future<Map<String, dynamic>> uploadUserDocuments({
  required Map<String, String> documents,
}) async {
  try {
    final token = await AuthMiddleware.getToken();
    
    var uri = Uri.parse('$baseUrl/api/auth/user-documents');
    var request = http.MultipartRequest('POST', uri);
  
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    for (var entry in documents.entries) {
      var file = File(entry.value);
      var stream = http.ByteStream(file.openRead());
      var length = await file.length();
      
      var multipartFile = http.MultipartFile(
        entry.key,
        stream,
        length,
        filename: entry.value.split('/').last,
      );
      
      request.files.add(multipartFile);
    }

    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    var data = jsonDecode(responseData);

    if (response.statusCode == 201) {
      return {
        'success': true,
        'message': data['message'],
        'data': data['data'],
      };
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Failed to upload documents',
        'errors': data['errors'],
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'Error occurred: $e',
    };
  }
}

static Future<Map<String, dynamic>> submitUserDetails({
  required String agencyName,
  required String position,
  required String visaTeto,
  required String sponsor,
}) async {
  try {
    final token = await AuthMiddleware.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/user-details'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'agency_name': agencyName,
        'position': position,
        'visa_teto': visaTeto,
        'sponsor': sponsor,
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return {
        'success': true,
        'message': data['message'],
        'data': data['data'],
      };
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Submission failed',
        'errors': data['errors'] ?? {},
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'Error occurred: $e',
    };
  }
}
  static Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final token = await AuthMiddleware.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/api/auth/user-profile'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': data['data'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to fetch data',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error occurred: $e',
      };
    }
  }
   static Future<Map<String, dynamic>> updateUserProfile(Map<String, dynamic> userData) async {
  try {
    final token = await AuthMiddleware.getToken();
    final uri = Uri.parse('$baseUrl/api/auth/user-profile');

    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    userData.forEach((key, value) async {
      if (value is File) {
        final file = await http.MultipartFile.fromPath(key, value.path);
        request.files.add(file);
      } else {
        request.fields[key] = value.toString();
      }
    });

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {
        'success': true,
        'message': data['message'] ?? 'Profil berhasil diperbarui',
      };
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Gagal memperbarui profil',
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'Terjadi kesalahan: $e',
    };
  }
}
static Future<List<Map<String, dynamic>>> getTravelLogs() async {
  try {
    final token = await AuthMiddleware.getToken(); 
    final response = await http.get(
      Uri.parse('$baseUrl/api/auth/travel-logs'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        return List<Map<String, dynamic>>.from(data['data']);
      }
    }
    return [];
  } catch (e) {
    print('Error fetching travel logs: $e');
    return [];
  }
}

}
