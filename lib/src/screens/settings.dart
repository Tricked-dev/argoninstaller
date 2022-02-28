// TMOD Installer (c) by tricked
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
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '../../theme.dart';
import '../utils.dart';

const List<String> accentColorNames = [
  'System',
  'Yellow',
  'Orange',
  'Red',
  'Magenta',
  'Purple',
  'Blue',
  'Teal',
  'Green',
];

class Settings extends StatefulWidget {
  const Settings({Key? key, this.controller}) : super(key: key);

  final ScrollController? controller;
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // const Settings({Key? key, }) : super(key: key);
  final _clearController = TextEditingController();
  String current = "";
  @override
  void initState() {
    super.initState();
    _clearController.addListener(() {
      if (_clearController.text.length == 1 && mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _clearController.dispose();
    super.dispose();
  }

  String _modfolder = "";
  @override
  Widget build(BuildContext context) {
    var modfolder = Config.preferences?.getString("modfolder");

    final appTheme = context.watch<AppTheme>();
    final tooltipThemeData = TooltipThemeData(decoration: () {
      const radius = BorderRadius.zero;
      final shadow = [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          offset: const Offset(1, 1),
          blurRadius: 10.0,
        ),
      ];
      final border = Border.all(color: Colors.grey[100], width: 0.5);
      if (FluentTheme.of(context).brightness == Brightness.light) {
        return BoxDecoration(
          color: Colors.white,
          borderRadius: radius,
          border: border,
          boxShadow: shadow,
        );
      } else {
        return BoxDecoration(
          color: Colors.grey,
          borderRadius: radius,
          border: border,
          boxShadow: shadow,
        );
      }
    }());

    const spacer = SizedBox(height: 10.0);
    const biggerSpacer = SizedBox(height: 40.0);
    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Settings')),
      scrollController: widget.controller,
      children: [
        Text('Theme mode', style: FluentTheme.of(context).typography.subtitle),
        spacer,
        ...List.generate(ThemeMode.values.length, (index) {
          final mode = ThemeMode.values[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: RadioButton(
              checked: appTheme.mode == mode,
              onChanged: (value) {
                if (value) {
                  Config.preferences?.setInt("theme", index);
                  appTheme.mode = mode;
                }
              },
              content: Text('$mode'.replaceAll('ThemeMode.', '')),
            ),
          );
        }),
        biggerSpacer,
        Text('Accent Color',
            style: FluentTheme.of(context).typography.subtitle),
        spacer,
        Wrap(children: [
          Tooltip(
            style: tooltipThemeData,
            child: _buildColorBlock(appTheme, systemAccentColor, -1),
            message: accentColorNames[0],
          ),
          ...List.generate(Colors.accentColors.length, (index) {
            final color = Colors.accentColors[index];
            return Tooltip(
              style: tooltipThemeData,
              message: accentColorNames[index + 1],
              child: _buildColorBlock(appTheme, color, index),
            );
          }),
        ]),
        biggerSpacer,
        Text("Mod repo's", style: FluentTheme.of(context).typography.subtitle),
        const flutter.SelectableText(
          "Repos are split by ',' the available repos are: skyclient,feather,std. Use urls for external ones.\nA restart is required after updating the repos",
        ),
        spacer,
        TextBox(
          controller: _clearController,
          // header: 'Repos split by ","',
          placeholder: 'Insert repos',
          onEditingComplete: () {
            // print("Hello!");
            // Config.preferences?.setStringList("repos", current.split(","));
          },
          onChanged: (v) {
            current = v;
          },
          suffix: IconButton(
            icon: const Icon(FluentIcons.add_to),
            onPressed: () async {
              Config.preferences?.setStringList("repos", current.split(","));
              fetchData();
              setState(() {});
              // _clearController.clear();
            },
          ),
        ),
        biggerSpacer,
        Text("Disable icons",
            style: FluentTheme.of(context).typography.subtitle),
        const flutter.SelectableText(
          "Having icons may cause rendering issues this feature disables icons",
        ),
        spacer,
        Row(
          children: [
            Checkbox(
              checked: !Config.icons,
              onChanged: (value) => setState(() {
                if (value != null && value == false) {
                  Config.icons = true;
                } else {
                  Config.icons = false;
                }
              }),
            ),
          ],
        ),
        biggerSpacer,
        Text("Mod folder", style: FluentTheme.of(context).typography.subtitle),
        flutter.SelectableText(
          "Current directory $modfolder",
        ),
        spacer,
        TextBox(
          // controller: _clearController,
          // header: 'Repos split by ","',
          placeholder: 'Change modfolder',
          onEditingComplete: () {
            // print("Hello!");
            // Config.preferences?.setStringList("repos", current.split(","));
          },
          onChanged: (v) {
            _modfolder = v;
          },
          suffix: IconButton(
            icon: const Icon(FluentIcons.add_to),
            onPressed: () async {
              var fold = _modfolder
                  .replaceFirst("~", Platform.environment['HOME'] ?? "NO_HOME")
                  .replaceFirst("%APPDATA%",
                      Platform.environment['APPDATA'] ?? "NO_APPDATA");
              var r = await Directory(fold).exists();
              if (r) {
                setState(() {
                  Config.preferences?.setString("modfolder", fold);
                });
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _invaliddir(),
                );
              }

              // _clearController.clear();
            },
          ),
        ),
        biggerSpacer,
        Row(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 4),
              child: FilledButton(
                child: const Text("Discord"),
                onPressed: () async => launch("https://discord.gg/wU9kyjdJup"),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 4),
              child: FilledButton(
                child: const Text("Github"),
                onPressed: () async =>
                    launch("https://github.com/Tricked-dev/tmodinstaller"),
              ),
            )
          ],
        ),
        spacer,
        const Text(
            "TMod Installer created by Tricked-dev licensed under: Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License."),
      ],
    );
  }

  Widget _invaliddir() {
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

  Widget _buildColorBlock(AppTheme appTheme, AccentColor color, int index) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Button(
        onPressed: () {
          Config.preferences?.setInt("color", index);
          appTheme.color = color;
        },
        style: ButtonStyle(padding: ButtonState.all(EdgeInsets.zero)),
        child: Container(
          height: 40,
          width: 40,
          color: color,
          alignment: Alignment.center,
          child: appTheme.color == color
              ? Icon(
                  FluentIcons.check_mark,
                  color: color.basedOnLuminance(),
                  size: 22.0,
                )
              : null,
        ),
      ),
    );
  }
}
