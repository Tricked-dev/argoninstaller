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
import 'package:tmodinstaller/src/screens/mod.dart';
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

    return Column(
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
                              style:
                                  FluentTheme.of(context).typography.bodyLarge!,
                              overflow: TextOverflow.fade),
                          DefaultTextStyle(
                            child: flutter.SelectableText(mod.description),
                            style: FluentTheme.of(context).typography.body!,
                            overflow: TextOverflow.fade,
                          ),
                        ],
                      ),
                    ),
                  ]),
                );
              }),
              onPressed: () {
                Navigator.push(
                  context,
                  FluentPageRoute(
                      builder: (context) => ModScreen(
                          mcv: widget.version,
                          mod: mod,
                          modver: mod.downloads.firstWhere((element) =>
                              element.mcversions.contains(widget.version)))),
                );
              });
        })
      ],
    );
  }
}
