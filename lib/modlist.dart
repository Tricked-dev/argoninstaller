// import 'package:flutter/material.dart';
// import 'package:tmodinstaller/navBar.dart';
// import 'package:tmodinstaller/utils.dart';
import 'package:fluent_ui/fluent_ui.dart';

import 'models.dart';

class ModListsPage extends StatefulWidget {
  const ModListsPage({Key? key, required this.mods}) : super(key: key);
  final List<Mod> mods;
  @override
  State<ModListsPage> createState() => _ModLists();
}

class _ModLists extends State<ModListsPage> {
  String selectedVersion = "unknown";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
        child: ListView.builder(
            //       children: <Widget>[
            //   ...widget.mods.map(
            //     (e) => Card(
            //         child: Column(
            //       children: <Widget>[
            //         ListTile(
            //           leading: Image.network(e.icon),
            //           title: Text(e.display),
            //           subtitle: Text(e.description),
            //           onTap: () {
            // showDialog(
            //   context: context,
            //   builder: (BuildContext context) =>
            //       _buildPopupDialog(context, e),
            // );
            //           },
            //         ),
            //       ],
            //     )),
            //   )
            // ]
            itemCount: widget.mods.length,
            itemBuilder: (context, index) {
              var mod = widget.mods[index];
              return ListTile(
                  leading: Image.network(mod.icon),
                  title: Text(mod.display),
                  subtitle: Text(mod.description),
                  trailing: IconButton(
                    // child: Text("Install"),
                    icon: Icon(FluentIcons.installation),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildPopupDialog(context, mod),
                      );
                    },
                  ),
                  isThreeLine: true);
            }));
  }

  Widget _installer(BuildContext context, Mod mod, DownloadMod version) {
    return ContentDialog(
      title: Text('Installing ${mod.display} ${version.version}'),
      content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [ProgressBar()]),
      // content: Form(
      //     child: Form(
      //   child: DropdownButton<String>(
      //     items: [
      //       ...download.map((value) {
      //         return DropdownMenuItem<String>(
      //           value: "${value.url}",
      //           child: Text("${value.mcversion} v${value.version}"),
      //         );
      //       })
      //     ],
      //     icon: const Icon(Icons.keyboard_arrow_down),
      //     value: selectedVersion,
      //     onChanged: (v) {
      //       setState(() {
      //         if (v != null) selectedVersion = v;
      //       });
      //       print(v);
      //     },
      //   ),
      // )),
      actions: <Widget>[
        // TextButton()
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Install'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildPopupDialog(BuildContext context, Mod mod) {
    var download = mod.downloads;
    if (download.isEmpty) {
      return const ContentDialog(
        title: Text("No mods found weird.."),
      );
    }
    selectedVersion = "${mod.downloads[0].url}";
    return ContentDialog(
      title: Text('Install ${mod.display}'),
      content: Form(
          child: Center(
        child: DropDownButton(
          items: [
            ...download.map((value) {
              return DropDownButtonItem(
                // value: "${value.url}",
                leading: const Icon(FluentIcons.align_left),
                title: Text("${value.mcversion} v${value.version}"),
                onTap: () => debugPrint('left'),
              );
            })
          ],
          // icon: const Icon(Icons.keyboard_arrow_down),
          // value: selectedVersion,
          // onChanged: (v) {
          //   setState(() {
          //     if (v != null) selectedVersion = v;
          //   });
          //   print(v);
          // },
        ),
      )),
      actions: <Widget>[
        // TextButton()
        TextButton(
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
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
