// import 'package:flutter/material.dart';
import 'package:tmodinstaller/models.dart';
import 'package:tmodinstaller/theme.dart';
import 'package:tmodinstaller/utils.dart';
import 'modlist.dart';
import 'navBar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstore/localstore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
// import 'package:window_manager/window_manager.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _TModInstallerPageState.fetchData();
  runApp(const TModInstallerApp());
}

class TModInstallerApp extends StatelessWidget {
  const TModInstallerApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AppTheme(),
        builder: (context, _) {
          final appTheme = context.watch<AppTheme>();
          return FluentApp(
            title: 'Tricked mod Installer',
            debugShowCheckedModeBanner: false,
            color: appTheme.color,
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              accentColor: appTheme.color,
              visualDensity: VisualDensity.standard,
              focusTheme: FocusThemeData(
                glowFactor: is10footScreen() ? 2.0 : 0.0,
              ),
            ),
            theme: ThemeData(
              accentColor: appTheme.color,
              visualDensity: VisualDensity.standard,
              focusTheme: FocusThemeData(
                glowFactor: is10footScreen() ? 2.0 : 0.0,
              ),
            ),
            home: const TModInstallerPage(title: 'Tricked mod Installer'),
          );
        });
  }
}

class TModInstallerPage extends StatefulWidget {
  const TModInstallerPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TModInstallerPage> createState() => _TModInstallerPageState();
}

class _TModInstallerPageState extends State<TModInstallerPage> {
  final db = Localstore.instance;
  int index = 0;
  // List<Mod> mods = [];
  // List<DownloadMod> versions = [];

  final settingsController = ScrollController();

  @override
  void dispose() {
    settingsController.dispose();
    super.dispose();
  }

  static Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('https://tmod.deno.dev/skyclient.json'));
    var data = json.decode(response.body);

    mods = [
      ...mods,
      ...data["mods"].map((x) {
        x["repo"] = data["id"];
        return Mod.fromJson(x);
      })
    ];

    final feat =
        await http.get(Uri.parse('https://tmod.deno.dev/feather.json'));
    var featdata = json.decode(feat.body);

    mods = [
      ...mods,
      ...featdata["mods"].map((x) {
        x["repo"] = featdata["id"];
        return Mod.fromJson(x);
      })
    ];
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<AppTheme>();
    return FutureBuilder<void>(future: () async {
      return;
    }(), builder: (context, snapshot) {
      List<String> versions = Set.of(mods
          .map((x) => x.downloads.map((x) => x.mcversion))
          .expand((i) => i)).toList();

      // snapshot.data.
      // // print(mods);
      // // print(versions);
      return NavigationView(
        appBar: NavigationAppBar(
          title: () {
            // return const DragToMoveArea(
            //   child: Align(
            //     alignment: AlignmentDirectional.centerStart,
            //     child: Text("a"),
            //   ),
            // );
          }(),
          // actions: DragToMoveArea(
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     // children: const [Spacer(), WindowButtons()],
          //   ),
          // ),
        ),
        pane: NavigationPane(
          selected: index,
          onChanged: (i) => setState(() => index = i),
          size: const NavigationPaneSize(
            openMinWidth: 250,
            openMaxWidth: 320,
          ),
          header: Container(
            height: kOneLineTileHeight,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: const FlutterLogo(
              style: FlutterLogoStyle.horizontal,
              size: 100,
            ),
          ),
          // displayMode: appTheme.displayMode,
          // indicatorBuilder: () {
          //   switch (appTheme.indicator) {
          //     case NavigationIndicators.end:
          //       return NavigationIndicator.end;
          //     case NavigationIndicators.sticky:
          //     default:
          //       return NavigationIndicator.sticky;
          //   }
          // }(),
          items: [
            ...versions.map(
              (e) => PaneItem(
                icon: const Icon(FluentIcons.game),
                title: Text(e),
              ),
            )
            // It doesn't look good when resizing from compact to open
            // PaneItemHeader(header: Text('User Interaction')),
            // PaneItem(
            //   icon: const Icon(FluentIcons.checkbox_composite),
            //   title: const Text('Inputs'),
            // ),
            // PaneItem(
            //   icon: const Icon(FluentIcons.text_field),
            //   title: const Text('Forms'),
            // ),
            // PaneItemSeparator(),
            // PaneItem(
            //   icon: const Icon(FluentIcons.color),
            //   title: const Text('Colors'),
            // ),
            // PaneItem(
            //   icon: const Icon(FluentIcons.icon_sets_flag),
            //   title: const Text('Icons'),
            // ),
            // PaneItem(
            //   icon: const Icon(FluentIcons.plain_text),
            //   title: const Text('Typography'),
            // ),
            // PaneItem(
            //   icon: const Icon(FluentIcons.cell_phone),
            //   title: const Text('Mobile'),
            // ),
            // PaneItem(
            //   icon: Icon(
            //     appTheme.displayMode == PaneDisplayMode.top
            //         ? FluentIcons.more
            //         : FluentIcons.more_vertical,
            //   ),
            //   title: const Text('Others'),
            //   infoBadge: const InfoBadge(
            //     source: Text('9'),
            //   ),
            // ),
          ],
          // autoSuggestBox: AutoSuggestBox(
          //   controller: TextEditingController(),
          //   items: const ['Item 1', 'Item 2', 'Item 3', 'Item 4'],
          // ),
          autoSuggestBoxReplacement: const Icon(FluentIcons.search),
          footerItems: [
            PaneItemSeparator(),
            PaneItem(
              icon: const Icon(FluentIcons.settings),
              title: const Text('Settings'),
            ),
            // _LinkPaneItemAction(
            //   icon: const Icon(FluentIcons.open_source),
            //   title: const Text('Source code'),
            //   link: 'https://github.com/bdlukaa/fluent_ui',
            // ),
          ],
        ),

        // appBar: NavigationAppBar(title: Text("Fluent Design App Bar")),
        // content: comp,
        content: NavigationBody(index: index, children: [
          ...versions.map((version) => ModListsPage(
                mods: [
                  ...mods.where((x) => x.downloads
                      .where((x) => x.mcversion == version)
                      .isNotEmpty)
                ],
              ))
          // const InputsPage(),
          // const Forms(),
          // const ColorsPage(),
          // const IconsPage(),
          // const TypographyPage(),
          // const Mobile(),
          // const Others(),
          // Settings(controller: settingsController),
        ]),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: _incrementCounter,
        //   tooltip: 'Increment',
        //   child: const Icon(Icons.add),
        // ),
      );
    });
  }
}
