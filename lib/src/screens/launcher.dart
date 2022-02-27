// TMOD Installer (c) by Tricked-dev <tricked@tricked.pro>
//
// TMOD Installer is licensed under a
// Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc-nd/3.0/>.

import 'package:flutter/foundation.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:provider/provider.dart';
import 'package:tmodinstaller/config.dart';
import 'package:tmodinstaller/src/models/models.dart';
import 'package:tmodinstaller/src/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '../../theme.dart';
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
          flutter.SelectableText(
            "This will empty the current mod folder and install all mods from this version that you installed",
          ),
          FilledButton(
              child: Text("Click here!"),
              onPressed: () async {
                await Directory(_modfolder).delete(recursive: true);
                await Directory(_modfolder).create();
                var files =
                    Directory("${Config.appDir}/modlists/${widget.mcv}/")
                        .listSync();
                for (var element in files) {
                  await File(element.path)
                      .copy("$_modfolder/${basename(element.path)}");
                  // element.("$_modfolder/${basename(element.path)}");
                }
                ;
              }),
          biggerSpacer,
          Text("Mod folder",
              style: FluentTheme.of(context).typography.subtitle),
          spacer,
          flutter.SelectableText(
            "Current directory $_modfolder",
          ),
          spacer,
          TextBox(
            placeholder: 'Change ',
            onEditingComplete: () {},
            onChanged: (v) {
              _newmodfolder = v;
            },
            suffix: IconButton(
              icon: const Icon(FluentIcons.add_to),
              onPressed: () async {
                var fold = _newmodfolder
                    .replaceFirst(
                        "~", Platform.environment['HOME'] ?? "NO_HOME")
                    .replaceFirst("%APPDATA%",
                        Platform.environment['APPDATA'] ?? "NO_APPDATA");
                var r = await Directory(fold).exists();
                if (r) {
                  final data = Version()
                    ..version = widget.mcv
                    ..moddir = fold;
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
            ),
          ),
        ]);
  }

  Widget _invaliddir(BuildContext context) {
    return ContentDialog(
      title: Text("Directory does not exist"),
      content: Text("beep boop"),
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
}
