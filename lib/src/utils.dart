// TMOD Installer (c) by tricked
// 
// TMOD Installer is licensed under a
// Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License.
// 
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc-nd/3.0/>.

import 'dart:convert';
import 'dart:io';

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

Future<void> installMod(Mod mod, DownloadMod version) async {
  final response = await http.get(Uri.parse(version.url));
  // var hashdata = version.hash.split(";");
  //TODO HASHING
  // if (hashdata[0] == "sha1") {
  //   var fileHash = sha1.convert(response.bodyBytes);
  //   if (fileHash != hashdata[1]) {
  //     throw ErrorHint("Hash does not match!");
  //   }
  // } else if (hashdata[0] == "sha256") {
  //   var fileHash = sha256.convert(response.bodyBytes);
  //   print("FILEHASH ${fileHash} DATA ${version.hash}");
  //   if (fileHash != hashdata[1]) {
  //     throw ErrorHint("Hash does not match!");
  //   }
  // } else if (hashdata[0] == "md5") {
  //   var fileHash = md5.convert(response.bodyBytes);
  //   if (fileHash != hashdata[1]) {
  //     throw ErrorHint("Hash does not match!");
  //   }
  // }
  File("${Config.directory}/${version.filename}")
      .writeAsBytes(response.bodyBytes);

  var currentMods = json.decode(Config.preferences?.getString("mods") ?? "{}");
  currentMods[mod.id] = Map();
  currentMods[mod.id][version.mcversion] = version.filename;
  Config.preferences?.setString("mods", json.encode(currentMods));
}
