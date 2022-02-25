// TMOD Installer (c) by tricked
//
// TMOD Installer is licensed under a
// Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc-nd/3.0/>.

import 'dart:convert';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as flutter;
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
  @override
  Widget build(BuildContext context) {
    final padding = PageHeader.horizontalPadding(context);

    return ScaffoldPage.scrollable(
        header: PageHeader(title: Text('${widget.version} Mods')),
        children: [
          Column(
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
                          SizedBox(height: 100),
                          if (Config.icons)
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
                                  child:
                                      flutter.SelectableText(mod.description),
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
                        builder: (BuildContext context) => _buildPopupDialog(
                            context,
                            mod,
                            mod.downloads.firstWhere((element) =>
                                element.mcversions.contains(widget.version))),
                      );
                    });
              })
            ],
          )
        ]);
  }

  Widget _installer(BuildContext context, Mod mod, DownloadMod version) {
    return FutureBuilder(
      future: installMod(mod, version),
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

  String _selectedVersion = "";

  Widget _buildPopupDialog(BuildContext context, Mod mod, DownloadMod version) {
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
    _selectedVersion = version.url;
    return ContentDialog(
      title: Text('Install ${mod.display}'),
      content: SizedBox(
          width: 300,
          // child: Center(
          child: Combobox<String>(
            placeholder: Text('Select a version'),
            isExpanded: true,
            items: [
              ...download.map((value) => ComboboxItem<String>(
                  value: value.url,
                  child: Text("${widget.version} v${value.version}")))
            ],
            value: _selectedVersion,
            onChanged: (v) {
              if (v != null) setState(() => _selectedVersion = v);
            },
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
                  mod.downloads.firstWhere(
                      (element) => element.url == _selectedVersion)),
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
