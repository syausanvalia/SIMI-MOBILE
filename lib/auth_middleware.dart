import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMiddleware {
  static const String tokenKey = 'auth_token';
  static const String userDataKey = 'user_data';

  /// Cek apakah user sudah login
  static Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(tokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Simpan token dan data user ke SharedPreferences
  static Future<void> saveAuthData(String token, Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
    await prefs.setString(userDataKey, jsonEncode(userData));
  }

  /// Ambil token dari SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  /// Ambil data user sebagai JSON string
  static Future<String?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userDataKey);
  }

  /// Ambil data user sebagai Map (decode dari JSON)
  static Future<Map<String, dynamic>?> getUserDataMap() async {
    final data = await getUserData();
    if (data == null) return null;
    try {
      return jsonDecode(data);
    } catch (e) {
      return null;
    }
  }

  /// Hapus token dan data user dari SharedPreferences (logout)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
    await prefs.remove(userDataKey);
  }
}