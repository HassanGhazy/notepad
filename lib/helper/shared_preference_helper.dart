import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  SharedPreferenceHelper._();
  static SharedPreferenceHelper sharedPreference = SharedPreferenceHelper._();
  SharedPreferences? prefs;
  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveStringData(String name, String value) async {
    await prefs!.setString(name, value);
  }

  String? getStringData(String key) {
    return prefs!.getString(key);
  }

  Future<void> saveIntData(String name, int value) async {
    await prefs!.setInt(name, value);
  }

  int? getIntData(String key) {
    return prefs!.getInt(key);
  }
}
