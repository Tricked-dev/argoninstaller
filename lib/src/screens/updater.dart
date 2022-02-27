// TMOD Installer (c) by tricked
//
// TMOD Installer is licensed under a
// Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc-nd/3.0/>.

import 'dart:convert';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:provider/provider.dart';
import 'package:tmodinstaller/config.dart';
import 'package:tmodinstaller/src/models/models.dart';
import 'package:tmodinstaller/src/utils.dart';
import 'dart:io';
import 'package:path/path.dart';
import '../../theme.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';

class Updater extends StatefulWidget {
  const Updater({Key? key, this.controller, required this.version})
      : super(key: key);
  final String version;
  final ScrollController? controller;
  @override
  _UpdaterState createState() => _UpdaterState();
}

class _UpdaterState extends State<Updater> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var updater_enabled = false;
    final padding = PageHeader.horizontalPadding(context);
//  await Directory("${Config.appDir}/modlists/${mcv}/").create(recursive: true);
    var files = Directory("${Config.appDir}/modlists/${widget.version}/")
        .listSync()
        .where((x) => x.statSync().type == FileSystemEntityType.file);
    List<InstalledMod> currentMods = Config.isar.installedMods
        .buildQuery<InstalledMod>()
        .findAllSync()
        .where((element) => element.mcv == widget.version)
        .toList();
    return Column(children: [
      Center(
        child: OutlinedButton(onPressed: () {}, child: Text("Update all")),
      ),
      Column(children: [
        ...files.map((mod) {
          final style = FluentTheme.of(context);

          // Mod? foundMod;
          // DownloadMod? current;
          // DownloadMod? update;
          currentMods.forEach((element) {
            print(element.mcv);
          });
          print(currentMods);
          var data = currentMods
              .firstWhereOrNull((x) => x.filename == basename(mod.path));

          // print(data?.mcv);
          var foundMod =
              mods.firstWhereOrNull((element) => element.id == data?.modId);

          var update = foundMod?.downloads.firstWhereOrNull((element) {
            return element.filename != basename(mod.path) &&
                element.mcversions.contains(widget.version);
          });
          var current = foundMod?.downloads.firstWhereOrNull((element) =>
                  element.filename == basename(mod.path) &&
                  element.mcversions.contains(widget.version)) ??
              update;
          print(update?.filename);
          print(current?.filename);
          print(data?.filename);
          return HoverButton(
              autofocus: true,
              builder: ((p0, state) {
                final Color _tileColor = () {
                  if (state.isFocused) {
                    return style.accentColor.resolve(context);
                  }
                  return ButtonThemeData.uncheckedInputColor(style, state);
                }();
                return Container(
                  // color: _tileColor,
                  decoration: ShapeDecoration(
                    shape: const ContinuousRectangleBorder(),
                    color: _tileColor,
                  ),

                  child: Row(children: <Widget>[
                    SizedBox(height: 100),
                    if (Config.icons && foundMod != null)
                      Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: Image.network(
                            foundMod.icon,
                            width: 128,
                            height: 128,
                          )),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DefaultTextStyle(
                              child: Text(foundMod == null
                                  ? basename(mod.path)
                                  : "${foundMod.display} ${current?.version} - ${current?.mcversions[0]}"),
                              style: const TextStyle().copyWith(
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.fade),
                          if (foundMod != null)
                            DefaultTextStyle(
                              child:
                                  flutter.SelectableText(foundMod.description),
                              style: const TextStyle(),
                              overflow: TextOverflow.fade,
                            ),
                          if (foundMod == null)
                            const DefaultTextStyle(
                              child:
                                  Text("Could not find the origin of this mod"),
                              style: const TextStyle(),
                              overflow: TextOverflow.fade,
                            ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(right: 14),
                        child: Row(
                          children: [
                            if (update != null &&
                                foundMod != null &&
                                update.version != current?.version)
                              OutlinedButton(
                                  child: Text("Update"),
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          _installer(context, foundMod, update,
                                              mod, data!.mcv),
                                    );
                                    if (data != null) {
                                      await Config.isar.writeTxn((isar) async {
                                        await Config.isar.installedMods
                                            .delete(data.id!);
                                      });
                                    }
                                    // await installMod(
                                    //     foundMod!, update!);
                                    // await mod.delete();
                                    setState(() {});
                                  }),
                            const SizedBox(
                              width: 4,
                            ),
                            OutlinedButton(
                                child: Text("Delete"),
                                onPressed: () async {
                                  await mod.delete();
                                  if (data != null) {
                                    await Config.isar.writeTxn((isar) async {
                                      await Config.isar.installedMods
                                          .delete(data.id!);
                                    });
                                  }
                                  setState(() {});
                                })
                          ],
                        )),
                  ]),
                );
              }),
              onPressed: () {});
        })
      ])
    ]);
  }

  Widget _installer(BuildContext context, Mod mod, DownloadMod version,
      FileSystemEntity modPath, String mcv) {
    return FutureBuilder(
      future: installMod(mod, version, mcv),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ContentDialog(
            title: const Text("Mod updated!"),
            content: const Text("Succesfully updated the mod"),
            actions: <Widget>[
              FilledButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await modPath.delete();
                },
                child: const Text('Close'),
              ),
            ],
          );
        }
        if (snapshot.hasError) {
          return ContentDialog(
            title: Text(
                "Failed to install mod, this is likely due to a hash mismatch"),
            actions: <Widget>[
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        }
        return ContentDialog(
          title: Text('Updating ${mod.display} ${version.version}'),
          content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [const ProgressBar()]),
        );
      },
    );
  }
}
