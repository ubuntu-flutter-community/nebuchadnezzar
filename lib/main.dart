import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:yaru/yaru.dart';

import 'app/view/app.dart';
import 'app_config.dart';
import 'common/view/ui_constants.dart';
import 'register.dart';

void main() async {
  if (isMobilePlatform) {
    WidgetsFlutterBinding.ensureInitialized();
  } else {
    await YaruWindowTitleBar.ensureInitialized();
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  registerDependencies();

  runApp(const NebuchadnezzarApp());
}
