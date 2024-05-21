import 'package:shared_preferences/shared_preferences.dart';

class CashNetwork {
  static late SharedPreferences sharedPreferences;
  static Future cashInitialization() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> insertToCash(
      {required String key, required String value}) async {
    return await sharedPreferences.setString(key, value);
  }

  static String getCashData({required String key}) {
    return sharedPreferences.getString(key) ?? '';
  }

  static Future<bool> deleteCashItem({required String key}) async {
    return await sharedPreferences.remove(key);
  }

  static Future<bool> clearCash() async {
    return await sharedPreferences.clear();
  }
}
