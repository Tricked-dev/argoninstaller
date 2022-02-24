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
  const Updater({Key? key, this.controller}) : super(key: key);

  final ScrollController? controller;
  @override
  _UpdaterState createState() => _UpdaterState();
}

class _UpdaterState extends State<Updater> {
  @override
  Widget build(BuildContext context) {
    var updater_enabled = false;
    final padding = PageHeader.horizontalPadding(context);

    var files = Directory(Config.directory)
        .listSync()
        .where((x) => x.statSync().type == FileSystemEntityType.file);
    Map<String, dynamic> currentMods =
        json.decode(Config.preferences?.getString("mods") ?? "{}");
    // print(mods);
    return ScaffoldPage.scrollable(
        header: const PageHeader(title: Text('Updater')),
        scrollController: widget.controller,
        children: [
          Center(
            child: OutlinedButton(onPressed: () {}, child: Text("Update all")),
          ),
          Column(
              // shrinkWrap: true,
              // maxCrossAxisExtent: 200,
              // mainAxisSpacing: 10,
              // crossAxisSpacing: 10,

              // // scrollDirection: Axis.vertical,
              // padding: EdgeInsets.only(
              //   top: kPageDefaultVerticalPadding,
              //   right: padding,
              //   left: padding,
              // ),
              children: [
                ...files.map((mod) {
                  final style = FluentTheme.of(context);

                  Mod? foundMod;
                  DownloadMod? current;
                  DownloadMod? update;

                  currentMods.forEach((modname, value) {
                    if (value.runtimeType == String) return;
                    var _foundMod = mods
                        .firstWhereOrNull((element) => element.id == modname);
                    value.forEach((_ver, value) {
                      if (value != basename(mod.path)) return;
                      if (_foundMod != null) {
                        foundMod = _foundMod;
                        var _update = _foundMod.downloads.firstWhereOrNull(
                            (element) => element.mcversion == _ver);
                        if (_update != null) {
                          current = _update;
                          if (basename(mod.path).toLowerCase() !=
                              _update.filename.toLowerCase()) {
                            update = _update;
                          }
                        }
                      }
                    });
                  });
                  //TODO fix importing mods - if even possible
                  // if (foundMod == null) {
                  //   mods.forEach((modList) {
                  //     modList.downloads.forEach((element) {
                  //       if (element.filename == basename(mod.path)) {
                  //         var currentMods = json.decode(
                  //             Config.preferences?.getString("mods") ?? "{}");
                  //         currentMods[modList.id] = element.filename;
                  //         Config.preferences
                  //             ?.setString("mods", json.encode(currentMods));
                  //       }
                  //     });
                  //   });
                  // }

                  var tileColor;
                  return HoverButton(
                      autofocus: true,
                      builder: ((p0, state) {
                        final Color _tileColor = () {
                          if (tileColor != null) {
                            return tileColor!.resolve(state);
                          } else if (state.isFocused) {
                            return style.accentColor.resolve(context);
                          }
                          return ButtonThemeData.uncheckedInputColor(
                              style, state);
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
                                    foundMod!.icon,
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
                                          : "${foundMod?.display} ${current?.version} - ${current?.mcversion}"),
                                      style: const TextStyle().copyWith(
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.fade),
                                  if (foundMod != null)
                                    DefaultTextStyle(
                                      child: flutter.SelectableText(
                                          foundMod!.description),
                                      style: const TextStyle(),
                                      overflow: TextOverflow.fade,
                                    ),
                                  if (foundMod == null)
                                    const DefaultTextStyle(
                                      child: Text(
                                          "Could not find the origin of this mod"),
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
                                    if (update != null && foundMod != null)
                                      OutlinedButton(
                                          child: Text("Update"),
                                          onPressed: () async {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  _installer(context, foundMod!,
                                                      update!, mod),
                                            );

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
      FileSystemEntity modPath) {
    return FutureBuilder(
      future: installMod(mod, version),
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
