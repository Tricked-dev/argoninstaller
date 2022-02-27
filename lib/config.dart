// TMOD Installer (c) by tricked
//
// TMOD Installer is licensed under a
// Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc-nd/3.0/>.

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmodinstaller/src/models/models.dart';
import 'package:tmodinstaller/src/utils.dart';

class Config {
  static SharedPreferences? preferences;
  static String _directory = "";
  static String _appDir = "";
  static bool _icons = true;
  static bool _newMenu = true;
  static late Isar isar;

  static Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
    var dir = Config.preferences?.getString("modfolder");
    if (dir == null) {
      _directory = defaultMinecraft[defaultTargetPlatform]!;
      Config.preferences?.setString("modfolder", _directory);
    } else {
      _directory = dir;
    }
    _newMenu = preferences?.getBool("new_menu") ?? true;
    _icons = preferences?.getBool("icons") ?? true;

    var appdir = Config.preferences?.getString("appdir");
    if (appdir == null) {
      _appDir = defaultDirectories[defaultTargetPlatform] ??
          (await getApplicationSupportDirectory()).path;
      Directory(_appDir).createSync(recursive: true);
    } else {
      _appDir = appdir;
    }
  }

  static Future<void> initDb() async {
    isar = await Isar.open(
      schemas: [InstalledModSchema],
      name: "data",
      directory: Config.appDir,
      inspector: true,
    );
  }

  static set directory(String v) {
    Config.preferences?.setString("modfolder", v);
    _directory = v;
  }

  static String get directory {
    return _directory;
  }

  static set appDir(String v) {
    Config.preferences?.setString("appdir", v);
    _appDir = v;
  }

  static String get appDir {
    return _appDir;
  }

  static set icons(bool v) {
    Config.preferences?.setBool("icons", v);
    _icons = v;
  }

  static bool get icons {
    return _icons;
  }

  static set newMenu(bool v) {
    Config.preferences?.setBool("new_menu", v);
    _newMenu = v;
  }

  static bool get newMenu {
    return _newMenu;
  }
}
