// TMOD Installer (c) by Tricked-dev <tricked@tricked.pro>
//
// TMOD Installer is licensed under a
// Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc-nd/3.0/>.

import 'package:file_selector/file_selector.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:argoninstaller/config.dart';
import 'package:argoninstaller/src/models/models.dart';
import 'package:argoninstaller/src/utils.dart';
import 'dart:io';
import 'package:isar/isar.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart';

class Launcher extends StatefulWidget {
  const Launcher({Key? key, this.controller, required this.mcv})
      : super(key: key);
  final String mcv;

  final ScrollController? controller;
  @override
  _LauncherState createState() => _LauncherState();
}

class _LauncherState extends State<Launcher> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _modfolder = "";
  String _newmodfolder = "";
  @override
  Widget build(BuildContext context) {
    var versions = Config.isar.versions.where().findAllSync();
    var version =
        versions.firstWhereOrNull((element) => element.version == widget.mcv);
    _modfolder = getModFolder(widget.mcv);

    const spacer = SizedBox(height: 10.0);
    const biggerSpacer = SizedBox(height: 40.0);
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Refresh mod folder",
              style: FluentTheme.of(context).typography.subtitle),
          spacer,
          const flutter.SelectableText(
            "This will empty the current mod folder and install all mods from this version that you installed",
          ),
          spacer,
          FilledButton(
              child: const Text("Click here!"),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _refresh(context, version),
                );
              }),
          biggerSpacer,
          Text("Mod folder",
              style: FluentTheme.of(context).typography.subtitle),
          spacer,
          flutter.SelectableText(
            "Current directory $_modfolder ${_modfolder == Config.getValue("mod_folder") ? "(Default)" : ""}",
          ),
          spacer,
          FilledButton(
            child: Text("Select new directory"),
            onPressed: () async {
              var dir = await getDirectoryPath(
                initialDirectory: _modfolder,
              );
              if (dir == null) return;
              var r = await Directory(dir).exists();
              if (r) {
                final data = Version()
                  ..version = widget.mcv
                  ..moddir = dir;
                if (version?.id != null) {
                  data.id = version?.id;
                }
                await Config.isar.writeTxn((isar) async {
                  data.id = await isar.versions.put(data);
                });
                setState(() {});
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _invaliddir(context),
                );
              }
            },
          )
          // TextBox(
          //   placeholder: 'Change ',
          //   onEditingComplete: () {},
          //   onChanged: (v) {
          //     _newmodfolder = v;
          //   },
          //   suffix: IconButton(
          //     icon: const Icon(FluentIcons.add_to),
          //     onPressed: () async {
          //       var fold = _newmodfolder
          //           .replaceFirst(
          //               "~", Platform.environment['HOME'] ?? "NO_HOME")
          //           .replaceFirst("%APPDATA%",
          //               Platform.environment['APPDATA'] ?? "NO_APPDATA");
          // var r = await Directory(fold).exists();
          // if (r) {
          //   final data = Version()
          //     ..version = widget.mcv
          //     ..moddir = fold;
          //   if (version?.id != null) {
          //     data.id = version?.id;
          //   }
          //   await Config.isar.writeTxn((isar) async {
          //     data.id = await isar.versions.put(data);
          //   });
          //   setState(() {});
          // } else {
          //   showDialog(
          //     context: context,
          //     builder: (BuildContext context) => _invaliddir(context),
          //   );
          // }
          //     },
          //   ),
          // ),
        ]);
  }

  Widget _invaliddir(BuildContext context) {
    return ContentDialog(
      title: const Text("Directory does not exist"),
      content: const Text("beep boop"),
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

  Widget _refresh(BuildContext context, Version? version) {
    return ContentDialog(
      title: const Text(
          "Refresh mod folder this will delete the mod folder and replace the mods"),
      content: const Text("This action CANNOT be undone"),
      actions: <Widget>[
        FilledButton(
          onPressed: () async {
            var backupDir = "${Directory(_modfolder).parent.path}/mods.back";
            try {
              await Directory(backupDir).delete(recursive: true);
            } catch (e) {
              print("Backup mods folder doesn't exist");
            }
            try {
              await Directory(_modfolder).rename(
                backupDir,
              );
              await File("$backupDir/hi.txt").writeAsString(
                  "Accidentally clicked this button? dw just rename this folder to mods");

              // await Directory(_modfolder).delete(recursive: true);
              await Directory(_modfolder).create();
              var files = Directory("${Config.appDir}/modlists/${widget.mcv}/")
                  .listSync();
              for (var element in files) {
                if (element.statSync().type == FileSystemEntityType.file) {
                  await File(element.path)
                      .copy("$_modfolder/${basename(element.path)}");
                }
              }
            } catch (e) {
              print(e);
              print("Failed to refresh mod folder");
            }
            Navigator.of(context).pop();
          },
          child: const Text('Continue'),
        ),
        FilledButton(
          onPressed: () async {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
