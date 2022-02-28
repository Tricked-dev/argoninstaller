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
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:isar/isar.dart';
import 'package:tmodinstaller/config.dart';
import 'models/models.dart';
import 'package:collection/collection.dart';

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

class UtilMod {
  final String name;
  final String mcv;

  UtilMod(this.name, this.mcv);

  write(Uint8List bytes) async {
    try {
      await Future.wait([
        File("${Config.appDir}/modlists/${mcv}/${name}").writeAsBytes(bytes),
        File("${getModFolder(mcv)}/${name}").writeAsBytes(bytes)
      ]);
    } catch (e) {
      print(e);
    }
  }

  delete() async {
    try {
      await Future.wait([
        File("${Config.appDir}/modlists/${mcv}/${name}").delete(),
        File("${getModFolder(mcv)}/${name}").delete()
      ]);
    } catch (e) {
      print(e);
    }
  }
}

Future<void> installMod(Mod mod, DownloadMod version, String mcv) async {
  final response = await http.get(Uri.parse(version.url));
  //TODO: Hashing!
  await Directory("${Config.appDir}/modlists/${mcv}/").create(recursive: true);

  UtilMod(version.filename, mcv).write(response.bodyBytes);

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

String getModFolder(String mcv) {
  var versions = Config.isar.versions.where().findAllSync();
  var version = versions.firstWhereOrNull((element) => element.version == mcv);
  return version?.moddir ?? Config.directory;
}

Future<void> fetchData() async {
  mods = [];
  //TODO save mods somewhere for offline
  try {
    var repos = Config.preferences?.getStringList("repos");
    if (repos != null) {
      for (var repo in repos) {
        var trimmed = repo.trim();
        //Prevent leading commas from erroring shit
        if (trimmed == "") continue;
        final res = await http.get(Uri.parse(trimmed.startsWith("http")
            ? trimmed
            : "https://tmod.deno.dev/$trimmed.json"));
        var data = json.decode(res.body);

        mods = [
          ...mods,
          ...data["mods"].map((x) {
            x["repo"] = data["id"];
            x["meta"].removeWhere((k, v) => v == null);
            if (x["icon"] == null)
              x["icon"] =
                  "https://raw.githubusercontent.com/Tricked-dev/tmodinstaller/master/linux/debian/usr/share/icons/hicolor/256x256/apps/tmodinstaller.png";

            return Mod.fromJson(x);
          })
        ];
      }
    } else {
      final response =
          await http.get(Uri.parse('https://tmod.deno.dev/std.json'));
      var data = json.decode(response.body);

      mods = [
        ...mods,
        ...data["mods"].map((x) {
          x["repo"] = data["id"];
          x["meta"].removeWhere((k, v) => v == null);
          if (x["icon"] == null)
            x["icon"] =
                "https://raw.githubusercontent.com/Tricked-dev/tmodinstaller/master/linux/debian/usr/share/icons/hicolor/256x256/apps/tmodinstaller.png";
          return Mod.fromJson(x);
        })
      ];
    }
  } catch (_) {
    print(_);
    mods = [
      Mod(
          categories: [],
          repo: "INVALID",
          display: "INVALID REPO DETECTED",
          description:
              "PLEASE ENSURE THAT ALL REPOS ARE VALID AND WORKING BEFORE ADDING THEM",
          id: "INVALID",
          downloads: [
            DownloadMod(
                filename: "INVALID",
                mcversions: ["0.0.0"],
                version: "0.0.0",
                hash: "sha1;null",
                url: "")
          ],
          nicknames: [],
          conflicts: [],
          forgeid: "INVALID",
          meta: {},
          icon:
              "https://cdn-images-1.medium.com/max/1200/1*5-aoK8IBmXve5whBQM90GA.png")
    ];
  }
}
