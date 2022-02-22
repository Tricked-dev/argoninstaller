import 'package:shared_preferences/shared_preferences.dart';

class Config {
  static SharedPreferences? preferences;

  static Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }
}
