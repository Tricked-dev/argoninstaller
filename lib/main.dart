// ArgonInstaller (c) by tricked
//
// ArgonInstaller is licensed under a
// Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc-nd/3.0/>.

// import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:args/args.dart';
import 'package:flutter/foundation.dart';
import 'package:argoninstaller/config.dart';
import 'package:argoninstaller/src/screens/settings.dart';
import 'package:argoninstaller/src/screens/version.dart';
import 'package:argoninstaller/src/utils.dart';
import 'package:argoninstaller/theme.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  setPathUrlStrategy();
  await Config.init();
  await Future.wait([
    flutter_acrylic.Window.initialize(),
    fetchData(),
    WindowManager.instance.ensureInitialized()
  ]);

  var parser = ArgParser();
  parser.addOption("moddir",
      abbr: "d",
      callback: (v) => v != null ? Config.change("mod_folder", v) : null);
  parser.parse(args);

  windowManager.waitUntilReadyToShow().then((_) async {
    // Hide window title bar
    // if (defaultTargetPlatform == TargetPlatform.windows) {
    //   await windowManager.setTitleBarStyle('hidden');
    //   await windowManager.setMinimumSize(const Size(755, 545));
    // }
    // await windowManager.setSize(const Size(800, 600));
    await windowManager.center();
    await windowManager.show();
    await windowManager.setSkipTaskbar(false);
  });

  runApp(const ArgonInstallerApp());
}

class ArgonInstallerApp extends StatelessWidget {
  const ArgonInstallerApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AppTheme(),
        builder: (context, _) {
          final appTheme = context.watch<AppTheme>();
          //Quick and dirty way to set the color!
          var color = Config.getValue("color");
          if (color != null) {
            if (color == -1) {
              appTheme.rawColor = systemAccentColor;
            } else {
              appTheme.rawColor = Colors.accentColors[color];
            }
          }
          if (Config.getValue("use_top_nav", defaultValue: false)) {
            appTheme.rawDisplayMode = PaneDisplayMode.top;
          }

          var theme = Config.getValue("theme");
          if (theme != null) {
            appTheme.rawMode = ThemeMode.values[theme];
          }

          return FluentApp(
            title: 'Tricked mod Installer',
            debugShowCheckedModeBanner: false,
            themeMode: appTheme.mode,
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
            builder: (context, child) {
              return Directionality(
                textDirection: appTheme.textDirection,
                child: child!,
              );
            },
            initialRoute: '/',
            routes: {
              '/': (_) =>
                  const ArgonInstallerPage(title: 'Tricked mod Installer')
            },
            // home: const ArgonInstallerPage(title: 'Tricked mod Installer'),
          );
        });
  }
}

class ArgonInstallerPage extends StatefulWidget {
  const ArgonInstallerPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ArgonInstallerPage> createState() => _ArgonInstallerPageState();
}

class _ArgonInstallerPageState extends State<ArgonInstallerPage> {
  @override
  void initState() {
    super.initState();
  }

  int index = 0;

  final settingsController = ScrollController();

  @override
  void dispose() {
    settingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<AppTheme>();

    final List<String> lastversions = [
      "1.18.2",
      "1.18.1",
      "1.17.1",
      "1.16.5",
      // "1.15.2",
      // "1.14.4",
      // "1.13.2",
      "1.12.2",
      "1.8.9",
    ];
    List<String> versions = Set.of(Set.of(mods
        .map((x) => x.downloads.map((x) => x.mcversions))
        .expand((i) => i)).expand((i) => i)).where((element) {
      if (element.contains("w") ||
          element.contains("pre") ||
          element.contains("rc")) return false;
      var ver = element.split("-")[0];
      var t = ver.split(".");
      t.removeLast();
      //Removes single versions 1.18
      if (t.length == 1) return false;
      //Allows versions that aren't on the list - future proving
      if (lastversions.every((x) => x.contains(t.join(".")))) return true;
      //Remove versions that aren't the latest
      if (!lastversions.contains(ver)) return false;
      //This version is included in [`lastversions`]
      return true;
    }).toList();
    return NavigationView(
      // appBar: defaultTargetPlatform == TargetPlatform.windows
      //     ? NavigationAppBar(
      //         title: () {
      //           return const DragToMoveArea(
      //             child: Align(
      //               alignment: AlignmentDirectional.centerStart,
      //               child: Text("Argon Installer"),
      //             ),
      //           );
      //         }(),
      //         actions: DragToMoveArea(
      //           child: Row(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: const [Spacer(), WindowButtons()],
      //           ),
      //         ))
      //     : null,
      pane: NavigationPane(
        selected: index,
        onChanged: (i) => setState(() => index = i),
        size: const NavigationPaneSize(
          openMinWidth: 250,
          openMaxWidth: 320,
        ),
        header: !Config.getValue("use_top_nav", defaultValue: false)
            ? Container(
                height: kOneLineTileHeight,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SvgPicture.asset("assets/Logo.svg"))
            : null,
        displayMode: appTheme.displayMode,
        indicatorBuilder: () {
          switch (appTheme.indicator) {
            case NavigationIndicators.end:
              return NavigationIndicator.end;
            case NavigationIndicators.sticky:
            default:
              return NavigationIndicator.sticky;
          }
        }(),
        items: [
          ...versions.map(
            (e) => PaneItem(
              icon: const Icon(FluentIcons.game),
              title: Text(e),
            ),
          )
        ],
        autoSuggestBoxReplacement: const Icon(FluentIcons.search),
        footerItems: [
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.settings),
            title: const Text('Settings'),
          ),
        ],
      ),
      content: NavigationBody(index: index, children: [
        ...versions.map((version) => VersionPage(
              mods: [
                ...mods.where((x) => x.downloads
                    .where((x) => x.mcversions.contains(version))
                    .isNotEmpty)
              ],
              version: version,
            )),
        // Updater(),
        Settings(controller: settingsController),
      ]),
    );
  }
}

// class WindowButtons extends StatelessWidget {
//   const WindowButtons({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     assert(debugCheckHasFluentTheme(context));
//     assert(debugCheckHasFluentLocalizations(context));
//     final ThemeData theme = FluentTheme.of(context);
//     final buttonColors = WindowButtonColors(
//       iconNormal: theme.inactiveColor,
//       iconMouseDown: theme.inactiveColor,
//       iconMouseOver: theme.inactiveColor,
//       mouseOver: ButtonThemeData.buttonColor(
//           theme.brightness, {ButtonStates.hovering}),
//       mouseDown: ButtonThemeData.buttonColor(
//           theme.brightness, {ButtonStates.pressing}),
//     );
//     final closeButtonColors = WindowButtonColors(
//       mouseOver: Colors.red,
//       mouseDown: Colors.red.dark,
//       iconNormal: theme.inactiveColor,
//       iconMouseOver: Colors.red.basedOnLuminance(),
//       iconMouseDown: Colors.red.dark.basedOnLuminance(),
//     );
//     return Row(children: [
//       Tooltip(
//         message: FluentLocalizations.of(context).minimizeWindowTooltip,
//         child: MinimizeWindowButton(colors: buttonColors),
//       ),
//       Tooltip(
//         message: FluentLocalizations.of(context).restoreWindowTooltip,
//         child: WindowButton(
//           colors: buttonColors,
//           iconBuilder: (context) {
//             if (appWindow.isMaximized) {
//               return RestoreIcon(color: context.iconColor);
//             }
//             return MaximizeIcon(color: context.iconColor);
//           },
//           onPressed: appWindow.maximizeOrRestore,
//         ),
//       ),
//       Tooltip(
//         message: FluentLocalizations.of(context).closeWindowTooltip,
//         child: CloseWindowButton(colors: closeButtonColors),
//       ),
//     ]);
//   }
// }
