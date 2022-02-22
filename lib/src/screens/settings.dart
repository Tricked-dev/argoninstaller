import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:provider/provider.dart';
import 'package:tmodinstaller/config.dart';
import 'dart:io';
import '../../theme.dart';

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
  bool _checked = false;
  final _clearController = TextEditingController();
  String current = "";
  @override
  void initState() {
    super.initState();
    _clearController.addListener(() {
      print(_clearController.value);
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
    var icons = Config.preferences?.getBool("noicons");
    var modfolder = Config.preferences?.getString("modfolder");
    if (icons != null && icons == true) {
      _checked = true;
    }
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
          "Repos are split by ',' the default repos are https://tmod.deno.dev/skyclient.json,https://tmod.deno.dev/feather.json\nA restart is required after updating the repos",
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
            onPressed: () {
              print(current);
              Config.preferences?.setStringList("repos", current.split(","));

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
              checked: _checked,
              onChanged: (value) => setState(() {
                if (value != null && value == true) {
                  Config.preferences?.setBool("noicons", true);
                  _checked = true;
                } else {
                  Config.preferences?.setBool("noicons", false);
                  _checked = false;
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
        // OutlinedButton(
        //   child: Text("Change folder!"),
        //   onPressed: () async {
        //     String? path = await FilesystemPicker.open(
        //       title: 'Save to folder',
        //       context: context,
        //       rootDirectory: Directory("/"),
        //       fsType: FilesystemType.folder,
        //       pickText: 'Save file to this folder',
        //       folderIconColor: Colors.teal,
        //     );
        //     print(path);
        //   },
        // )
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