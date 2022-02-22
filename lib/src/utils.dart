import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'models/models.dart';

List<Mod> mods = [];

Map<TargetPlatform, String> defaultMinecraft = {
  TargetPlatform.linux: "${Platform.environment['HOME']}/.minecraft/mods",
  TargetPlatform.macOS:
      "${Platform.environment['HOME']}/Library/Application Support/minecraft/mods",
  TargetPlatform.windows: "${Platform.environment['APPDATA']}\\.minecraft\\mods"
};
