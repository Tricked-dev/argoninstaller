import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:tmodinstaller/config.dart';
import 'package:tmodinstaller/src/utils.dart';
import '../models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'package:crypto/crypto.dart';

class ModListsPage extends StatefulWidget {
  const ModListsPage({Key? key, required this.mods, required this.version})
      : super(key: key);
  final List<Mod> mods;
  final String version;
  @override
  State<ModListsPage> createState() => _ModLists();
}

class _ModLists extends State<ModListsPage> {
  String selectedVersion = "unknown";
  bool _icons = true;
  String _directory = "";
  @override
  Widget build(BuildContext context) {
    final padding = PageHeader.horizontalPadding(context);
    var dir = Config.preferences?.getString("modfolder");
    if (dir == null) {
      _directory = defaultMinecraft[defaultTargetPlatform]!;
    } else {
      _directory = dir;
    }
    var noicons = Config.preferences?.getBool("noicons");
    if (noicons != null && noicons == true) {
      _icons = false;
    }
    return ScaffoldPage.scrollable(
        header: PageHeader(title: Text('${widget.version} Mods')),
        children: [
          GridView.extent(
            shrinkWrap: true,
            maxCrossAxisExtent: 300,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,

            // scrollDirection: Axis.vertical,
            padding: EdgeInsets.only(
              top: kPageDefaultVerticalPadding,
              right: padding,
              left: padding,
            ),
            children: [
              ...widget.mods.map((mod) {
                final style = FluentTheme.of(context);
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
                          if (_icons)
                            Padding(
                                padding: const EdgeInsets.only(right: 14),
                                child: Image.network(
                                  mod.icon,
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
                                    child: Text(mod.display),
                                    style: const TextStyle().copyWith(
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.fade),
                                DefaultTextStyle(
                                  child: Text(mod.description),
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
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildPopupDialog(context, mod),
                      );
                    });
              })
            ],

            // shrinkWrap: true,
            // itemCount: widget.mods.length,
            // itemBuilder: (context, index) {
            //   var mod = widget.mods[index];
            // return TappableListTile(
            //     leading: _icons ? Image.network(mod.icon) : null,
            //     title: Text(mod.display),
            //     subtitle: Text(mod.description),
            //     onTap: () {
            // showDialog(
            //   context: context,
            //   builder: (BuildContext context) =>
            //       _buildPopupDialog(context, mod),
            // );
            //     },
            //   );
            // })
          )
        ]);
  }

  Future<void> _install(DownloadMod version) async {
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
    File("${_directory}/${version.filename}").writeAsBytes(response.bodyBytes);
    // response.bodyBytes
  }

  Widget _installer(BuildContext context, Mod mod, DownloadMod version) {
    return FutureBuilder(
      future: _install(version),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ContentDialog(
            title: const Text("Mod installed!"),
            content:
                const Text("Succesfully installed the mod - press esc to exit"),
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
          title: Text('Installing ${mod.display} ${version.version}'),
          content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [const ProgressBar()]),
        );
      },
    );
  }

  Widget _buildPopupDialog(BuildContext context, Mod mod) {
    var download = mod.downloads;
    if (download.isEmpty) {
      return ContentDialog(
        title: Text("No mods found weird.."),
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
    if (mod.id == "INVALID") {
      return ContentDialog(
        title: Text("You cant install this"),
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
    selectedVersion = "${download[0].url}";
    return ContentDialog(
      title: Text('Install ${mod.display}'),
      content: SizedBox(
          width: 200,
          // child: Center(
          child: Combobox<String>(
            items: [
              ...download.map((value) {
                return ComboboxItem<String>(
                    value: "${value.url}",
                    child: Text("${value.mcversion} v${value.version}"));
              })
            ],
            icon: const Icon(FluentIcons.azure_key_vault),
            value: selectedVersion,
            onChanged: (v) {
              setState(() {
                if (v != null) selectedVersion = v;
              });
              // print(v);
            },
            // ),
          )),
      actions: <Widget>[
        // TextButton()
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            showDialog(
              context: context,
              builder: (BuildContext context) => _installer(
                  context,
                  mod,
                  mod.downloads
                      .firstWhere((element) => element.url == selectedVersion)),
            );
          },
          child: const Text('Install'),
        ),
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
