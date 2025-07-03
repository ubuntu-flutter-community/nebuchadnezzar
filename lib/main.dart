import 'package:flutter/material.dart';
import 'package:flutter_vodozemac/flutter_vodozemac.dart' as vod;
import 'package:system_theme/system_theme.dart';
import 'package:yaru/yaru.dart';

import 'app/view/nebuchadnezzar.dart';
import 'common/platforms.dart';
import 'register_dependencies.dart';

void main() async {
  await YaruWindowTitleBar.ensureInitialized();

  await vod.init(wasmPath: './assets/assets/vodozemac/');

  if (!Platforms.isLinux) {
    await SystemTheme.accentColor.load();
  }

  registerDependencies();

  runApp(const Nebuchadnezzar());
}
