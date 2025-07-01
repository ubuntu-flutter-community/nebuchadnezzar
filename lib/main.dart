import 'package:flutter/material.dart';
import 'package:system_theme/system_theme.dart';
import 'package:yaru/yaru.dart';

import 'app/view/nebuchadnezzar.dart';
import 'common/platforms.dart';
import 'register_dependencies.dart';

void main() async {
  await YaruWindowTitleBar.ensureInitialized();

  if (!Platforms.isLinux) {
    await SystemTheme.accentColor.load();
  }

  registerDependencies();

  runApp(const Nebuchadnezzar());
}
