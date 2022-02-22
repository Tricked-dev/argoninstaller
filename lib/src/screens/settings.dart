import 'package:flutter/foundation.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:provider/provider.dart';
import 'package:tmodinstaller/config.dart';
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

  @override
  Widget build(BuildContext context) {
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
