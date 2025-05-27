import 'package:shared_preferences/shared_preferences.dart';

class PaymentStatusManager {
  static const String _keyPrefix = 'payment_status_';

  static Future<void> setPaymentStatus(int trainingId, bool isPaid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${_keyPrefix}$trainingId', isPaid);
  }

  static Future<bool> getPaymentStatus(int trainingId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('${_keyPrefix}$trainingId') ?? false;
  }
}