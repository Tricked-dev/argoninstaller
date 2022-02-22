import 'package:flutter/material.dart';

var versions = ["1.8.9", "1.3.5", "3.6.7"];

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const SelectableText("Back to main menu"),
          ...versions.map((e) => SelectableText(e))
        ],
      ),
    );
  }
}
