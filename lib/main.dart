// Removed: import 'dart:io';

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:system_theme/system_theme.dart';
import 'package:window_manager/window_manager.dart';
import 'package:yaru/yaru.dart';

import 'app/view/app.dart';
import 'register_dependencies.dart';

void main() async {
  // Ensure widgets are initialized before platform checks or plugin calls
  WidgetsFlutterBinding.ensureInitialized();

  await YaruWindowTitleBar.ensureInitialized();

  // Guard window manager calls for non-web platforms
  if (!kIsWeb) {
    await WindowManager.instance
        .ensureInitialized(); // Ensure initialized before use
    WindowManager.instance
      ..setMinimumSize(const Size(500, 700))
      ..setSize(const Size(950, 820));
  }

  // Load system theme only on non-web platforms
  // The original check `!Platform.isLinux` is implicitly handled by Yaru/GNOME theme on Linux.
  // This simplified check avoids dart:io on web.
  if (!kIsWeb && !Platform.isLinux) {
    await SystemTheme.accentColor.load();
  }

  // Register dependencies (will need internal checks for web compatibility)
  registerDependencies();

  runApp(const Nebuchadnezzar());
}
