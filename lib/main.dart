import 'dart:io';

import 'package:flutter/material.dart';
import 'package:system_theme/system_theme.dart';
import 'package:window_manager/window_manager.dart';
import 'package:yaru/yaru.dart';

import 'app/view/app.dart';
import 'register_dependencies.dart';

void main() async {
  await YaruWindowTitleBar.ensureInitialized();
  WindowManager.instance
    ..setMinimumSize(const Size(500, 700))
    ..setSize(const Size(950, 820));

  if (!Platform.isLinux) {
    await SystemTheme.accentColor.load();
  }

  registerDependencies();

  runApp(NebuchadnezzarApp(yaruApp: Platform.isLinux));
}
