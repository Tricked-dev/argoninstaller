// TMOD Installer (c) by tricked
//
// TMOD Installer is licensed under a
// Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc-nd/3.0/>.

import 'dart:convert';
import 'dart:io';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:tmodinstaller/config.dart';
import 'models/models.dart';

List<Mod> mods = [];

Map<TargetPlatform, String> defaultMinecraft = {
  TargetPlatform.linux: "${Platform.environment['HOME']}/.minecraft/mods",
  TargetPlatform.macOS:
      "${Platform.environment['HOME']}/Library/Application Support/minecraft/mods",
  TargetPlatform.windows: "${Platform.environment['APPDATA']}\\.minecraft\\mods"
};

Map<TargetPlatform, String> defaultDirectories = {
  TargetPlatform.linux: "${Platform.environment['HOME']}/.config/tmodinstaller",
};

Future<void> installMod(Mod mod, DownloadMod version, String mcv) async {
  final response = await http.get(Uri.parse(version.url));
  //TODO: Hashing!
  await Directory("${Config.appDir}/modlists/${mcv}/").create(recursive: true);
  await File("${Config.appDir}/modlists/${mcv}/${version.filename}")
      .writeAsBytes(response.bodyBytes);

  final data = InstalledMod()
    ..modId = mod.id
    ..repo = mod.repo
    ..url = version.url
    ..version = version.version
    ..mcv = mcv
    ..mcversions = version.mcversions
    ..filename = version.filename;
  await Config.isar.writeTxn((isar) async {
    data.id = await isar.installedMods.put(data);
  });
}
