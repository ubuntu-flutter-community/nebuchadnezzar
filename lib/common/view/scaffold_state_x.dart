import 'dart:io';

import 'package:flutter/material.dart';

extension ScaffoldStateX on ScaffoldState {
  void showDrawer() => Platform.isMacOS ? openEndDrawer() : openDrawer();
  void hideDrawer() => Platform.isMacOS ? closeEndDrawer() : closeDrawer();
}
