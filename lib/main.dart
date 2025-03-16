import 'dart:io';

import 'package:flutter/material.dart';
import 'package:system_theme/system_theme.dart';
import 'package:yaru/yaru.dart';

import 'app/view/app.dart';
import 'register_dependencies.dart';

void main() async {
  await YaruWindowTitleBar.ensureInitialized();

  if (!Platform.isLinux) {
    await SystemTheme.accentColor.load();
  }

  registerDependencies();

  runApp(NebuchadnezzarApp(yaruApp: Platform.isLinux));
}
