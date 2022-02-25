// TMOD Installer (c) by Tricked-dev <tricked@tricked.pro>
//
// TMOD Installer is licensed under a
// Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc-nd/3.0/>.

// TMOD Installer (c) by tricked
//
// TMOD Installer is licensed under a
// Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc-nd/3.0/>.
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
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

class ModScreen extends StatefulWidget {
  ModScreen(
      {Key? key, this.controller, required this.mod, required this.modver})
      : super(key: key);
  Mod mod;
  DownloadMod modver;
  final ScrollController? controller;
  @override
  _ModScreenState createState() => _ModScreenState();
}

class _ModScreenState extends State<ModScreen> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
        header: const PageHeader(title: Text('Mod Downloader')),
        scrollController: widget.controller,
        children: [
          Column(
            children: [
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            if (Config.icons)
                              Padding(
                                  padding: const EdgeInsets.only(right: 14),
                                  child: Image.network(
                                    widget.mod.icon,
                                    width: 128,
                                    height: 128,
                                  )),
                            Column(
                              children: [
                                DefaultTextStyle(
                                  child: Text(
                                    widget.mod.display,
                                  ),
                                  style: const TextStyle().copyWith(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(widget.mod.description)
                              ],
                            ),
                          ],
                        ),
                        if (widget.mod.meta["body_url"] != null)
                          FutureBuilder<http.Response>(
                              future: http
                                  .get(Uri.parse(widget.mod.meta["body_url"]!)),
                              builder: ((context, snapshot) {
                                if (snapshot.error != null) {
                                  return Text(
                                      "Error fetching data ${snapshot.error}");
                                }
                                if (!snapshot.hasData) {
                                  return const Text("Description loading....");
                                }

                                return SizedBox(
                                    height: 600,
                                    // width: 500,
                                    child: Markdown(
                                      data: snapshot.data!.body,
                                      selectable: true,
                                    ));
                              }))
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        FilledButton(
                            child: Text("Return"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        FilledButton(
                          child: Text("Install Mod"),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildPopupDialog(
                                      context, widget.mod, widget.modver),
                            );
                          },
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => _installer(
                                  context, widget.mod, widget.modver),
                            );
                          },
                        )
                        // Text(
                        //     "This is a long text this is a long test this is This is a long text this is a long test this is This is a long text this is a long test this is This is a long text this is a long test this is This is a long text this is a long test this is This is a long text this is a long test this is ")
                      ],
                    ),
                  )
                ],
              ),
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
                  value: value.url, child: Text("v${value.version}")))
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
