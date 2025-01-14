import 'dart:io';

import 'package:flutter/material.dart';
import 'package:system_theme/system_theme.dart';
import 'package:window_manager/window_manager.dart';
import 'package:yaru/yaru.dart';

import 'app/view/app.dart';
import 'common/view/ui_constants.dart';
import 'register.dart';

void main() async {
  if (isMobile) {
    WidgetsFlutterBinding.ensureInitialized();
  } else {
    await YaruWindowTitleBar.ensureInitialized();
    if (Platform.isMacOS) {
      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
    }
  }

  if (!Platform.isLinux) {
    await SystemTheme.accentColor.load();
  }

  registerDependencies();

  runApp(NebuchadnezzarApp(yaruApp: Platform.isLinux));
}
