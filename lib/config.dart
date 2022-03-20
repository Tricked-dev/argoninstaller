// TMOD Installer (c) by tricked
//
// TMOD Installer is licensed under a
// Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc-nd/3.0/>.

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:argoninstaller/src/models/models.dart';
import 'package:argoninstaller/src/utils.dart';

class Config {
  static File _configFile = File("");
  static String _appdir = "";
  static Map _config = json.decode(_configFile.readAsStringSync());
  static late Isar isar;

  static Future<void> initDb() async {
    isar = await Isar.open(
      schemas: [InstalledModSchema, VersionSchema],
      name: "data",
      directory: _appdir,
      inspector: false,
    );
  }

  static init() async {
    _appdir = defaultDirectories[defaultTargetPlatform] ??
        (await getApplicationSupportDirectory()).path;
    _configFile = File("$_appdir/settings.json");

    if (!_configFile.existsSync()) {
      _configFile.createSync(recursive: true);
      _configFile.writeAsStringSync(json.encode({}));
    }
    await initDb();
  }

  Config(File configFile) {
    _configFile = configFile;
    _config = json.decode(configFile.readAsStringSync());
  }

  static final Map defaultConfigMap = {
    "icons": true,
    "theme": 0,
    "color": -1,
    "use_top_nav": false,
    "mod_repos": ["std", "skyclient"],
    "mod_folder": "${defaultMinecraft[defaultTargetPlatform]}",
  };

  static void change(String key, value) {
    Config(_configFile).Change(key, value);
  }

  void Change(String key, value) {
    _config[key] = value;
    Save();
  }

  static Map toMap() {
    return Config(_configFile).ToMap();
  }

  Map ToMap() {
    return _config;
  }

  static dynamic getValue(String key, {dynamic defaultValue}) {
    return Config(_configFile).GetValue(key, defaultValue: defaultValue);
  }

  dynamic GetValue(String key, {dynamic defaultValue}) {
    if (!_config.containsKey(key)) {
      _config[key] = defaultConfigMap[key] ?? defaultValue;
      Save();
    }
    return _config[key] ?? defaultValue;
  }

  static void save() {
    Config(_configFile).Save();
  }

  void Save() {
    try {
      _configFile.writeAsStringSync(json.encode(_config));
    } on FileSystemException {}
  }

  static set appDir(String v) {
    Config.change("app_dir", v);
    _appdir = v;
  }

  static String get appDir {
    return _appdir;
  }
}
