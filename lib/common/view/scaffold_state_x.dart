import 'package:flutter/material.dart';

import '../platforms.dart';

extension ScaffoldStateX on ScaffoldState {
  void showDrawer() => Platforms.isMacOS ? openEndDrawer() : openDrawer();
  void hideDrawer() => Platforms.isMacOS ? closeEndDrawer() : closeDrawer();
}
