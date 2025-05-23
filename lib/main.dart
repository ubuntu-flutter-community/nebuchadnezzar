import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:system_theme/system_theme.dart';
import 'package:window_manager/window_manager.dart';
import 'package:yaru/yaru.dart';

import 'app/view/nebuchadnezzar.dart';
import 'register_dependencies.dart';

void main() async {
  await YaruWindowTitleBar.ensureInitialized();
  WindowManager.instance
    ..setMinimumSize(const Size(500, 700))
    ..setSize(const Size(950, 820));

  if (kIsWeb || !Platform.isLinux) {
    await SystemTheme.accentColor.load();
  }

  registerDependencies();

  runApp(const Nebuchadnezzar());
}
