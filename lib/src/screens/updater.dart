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

class Updater extends StatefulWidget {
  const Updater({Key? key, this.controller}) : super(key: key);

  final ScrollController? controller;
  @override
  _UpdaterState createState() => _UpdaterState();
}

class _UpdaterState extends State<Updater> {
  String _directory = "";
  bool _icons = true;
  @override
  Widget build(BuildContext context) {
    final padding = PageHeader.horizontalPadding(context);
    var dir = Config.preferences?.getString("modfolder");
    if (dir == null) {
      _directory = defaultMinecraft[defaultTargetPlatform]!;
    } else {
      _directory = dir;
    }
    var files = Directory(_directory)
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
                  var noicons = Config.preferences?.getBool("noicons");
                  if (noicons != null && noicons == true) {
                    _icons = false;
                  }
                  Mod? foundMod;
                  currentMods.forEach((key, value) {
                    if (value == basename(mod.path)) {
                      foundMod =
                          mods.firstWhere((element) => element.id == key);
                    }
                  });
                  if (foundMod == null) {
                    mods.forEach((modList) {
                      modList.downloads.forEach((element) {
                        if (element.filename == basename(mod.path)) {
                          var currentMods = json.decode(
                              Config.preferences?.getString("mods") ?? "{}");
                          currentMods[modList.id] = element.filename;
                          Config.preferences
                              ?.setString("mods", json.encode(currentMods));
                        }
                      });
                    });
                  }

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
                            SizedBox(height: 50),
                            if (_icons && foundMod != null)
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
                                      child: Text(foundMod?.display ??
                                          basename(mod.path)),
                                      style: const TextStyle().copyWith(
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.fade),
                                  if (foundMod != null)
                                    DefaultTextStyle(
                                      child: Text(foundMod!.description),
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
                          ]),
                        );
                      }),
                      onPressed: () {
                        // showDialog(
                        //   context: context,
                        //   builder: (BuildContext context) =>
                        //       _buildPopupDialog(context, mod),
                        // );
                      });
                })
              ])
        ]);
  }
}
