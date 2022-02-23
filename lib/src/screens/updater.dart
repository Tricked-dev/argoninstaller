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
    var updater_enabled = false;
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
          if (updater_enabled)
            Center(
              child:
                  OutlinedButton(onPressed: () {}, child: Text("Update all")),
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
                                    if (updater_enabled &&
                                        foundMod != null &&
                                        foundMod?.downloads[0].filename !=
                                            basename(mod.path))
                                      OutlinedButton(
                                          child: Text("Update"),
                                          onPressed: () async {
                                            final response = await http.get(
                                                Uri.parse(foundMod!
                                                    .downloads[0].url));
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
                                            File("${_directory}/${foundMod!.downloads[0].filename}")
                                                .writeAsBytes(
                                                    response.bodyBytes);
                                            var currentMods = json.decode(Config
                                                    .preferences
                                                    ?.getString("mods") ??
                                                "{}");
                                            currentMods[foundMod!.id] =
                                                foundMod!.downloads[0].filename;
                                            Config.preferences?.setString(
                                                "mods",
                                                json.encode(currentMods));
                                          }),
                                    SizedBox(
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
