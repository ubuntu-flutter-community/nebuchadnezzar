import 'dart:io';

import 'package:flutter/foundation.dart'; // Added for kIsWeb
import 'package:flutter/material.dart';

extension ScaffoldStateX on ScaffoldState {
  // Use endDrawer only on macOS desktop, otherwise use standard drawer
  void showDrawer() =>
      (!kIsWeb && Platform.isMacOS) ? openEndDrawer() : openDrawer();
  void hideDrawer() =>
      (!kIsWeb && Platform.isMacOS) ? closeEndDrawer() : closeDrawer();
}
