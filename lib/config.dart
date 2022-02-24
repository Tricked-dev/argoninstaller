import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmodinstaller/src/utils.dart';

class Config {
  static SharedPreferences? preferences;
  static String _directory = "";

  static Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
    var dir = Config.preferences?.getString("modfolder");
    if (dir == null) {
      _directory = defaultMinecraft[defaultTargetPlatform]!;
      Config.preferences?.setString("modfolder", _directory);
    } else {
      _directory = dir;
    }
  }

  static set directory(String v) {
    Config.preferences?.setString("modfolder", v);
    _directory = v;
  }

  static String get directory {
    return _directory;
  }
}
