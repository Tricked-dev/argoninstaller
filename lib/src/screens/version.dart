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

import 'dart:convert';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:tmodinstaller/config.dart';
import 'package:tmodinstaller/src/screens/launcher.dart';
import 'package:tmodinstaller/src/screens/mod.dart';
import 'package:tmodinstaller/src/screens/modlist.dart';
import 'package:tmodinstaller/src/screens/updater.dart';
import 'package:tmodinstaller/src/utils.dart';
import '../models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'package:crypto/crypto.dart';

class VersionPage extends StatefulWidget {
  const VersionPage({Key? key, required this.mods, required this.version})
      : super(key: key);
  final List<Mod> mods;
  final String version;
  @override
  State<VersionPage> createState() => _VersionPage();
}

class _VersionPage extends State<VersionPage> {
  int currentIndex = 0;
  late List<Tab> tabs;

  @override
  void initState() {
    super.initState();
    tabs = List.generate(3, (index) {
      late Tab tab;
      tab = Tab(
        text: Text(index == 1
            ? "Mod Installer"
            : index == 2
                ? "Mod Updater"
                : "Launcher"),
        //   _handleTabClosed(tab);
        // },
      );
      return tab;
    });
  }
  // void initState() {
  //   tabs.add(Tab(text: Text("Mod Installer"),  onClosed: () {
  //         _handleTabClosed(tab);
  //       },))
  // }

  @override
  Widget build(BuildContext context) {
    Directory("${Config.appDir}/modlists/${widget.version}/").create();
    final padding = PageHeader.horizontalPadding(context);

    return Container(
      // height: 300,
      decoration: BoxDecoration(
          // color: FluentTheme.of(context).accentColor.resolve(context),
          // border: Border.all(
          //     color: FluentTheme.of(context).accentColor, width: 1.0),
          ),
      child: TabView(
        currentIndex: currentIndex,
        onChanged: _handleTabChanged,
        // onReorder: (oldIndex, newIndex) {
        //   setState(() {
        //     if (oldIndex < newIndex) {
        //       newIndex -= 1;
        //     }
        //     final Tab item = tabs.removeAt(oldIndex);
        //     tabs.insert(newIndex, item);
        //     if (currentIndex == newIndex) {
        //       currentIndex = oldIndex;
        //     } else if (currentIndex == oldIndex) {
        //       currentIndex = newIndex;
        //     }
        //   });
        // },
        // onNewPressed: () {
        //   setState(() {
        //     late Tab tab;
        //     tab = Tab(
        //       text: Text('Document ${tabs.length}'),
        //       onClosed: () {
        //         _handleTabClosed(tab);
        //       },
        //     );
        //     tabs.add(tab);
        //   });
        // },
        tabs: tabs,
        bodies: List.generate(
          tabs.length,
          (index) => ScaffoldPage.scrollable(
              // header: PageHeader(title: Text('${widget.version} Mods')),
              children: [
                index == 1
                    ? ModListsPage(mods: widget.mods, version: widget.version)
                    : index == 2
                        ? Updater(version: widget.version)
                        : Launcher(mcv: widget.version)
              ]),
        ),
      ),
    );
  }

  void _handleTabChanged(int index) {
    setState(() => currentIndex = index);
  }
}
