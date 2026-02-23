import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:xdg_directories/xdg_directories.dart';

import 'app/app_config.dart';
import 'common/platforms.dart';

Directory? _tempDirectory;
Future<String> getTempFilePath(String fileName) async {
  _tempDirectory = (Platforms.isLinux
      ? configHome
      : await getTemporaryDirectory());
  if (_tempDirectory == null) {
    throw Exception('Failed to get temporary directory');
  }
  final baseDirPath = p.join(_tempDirectory!.path, AppConfig.appName);

  if (!Directory(baseDirPath).existsSync()) {
    Directory(baseDirPath).createSync();
  }

  final path = p.join(baseDirPath, fileName);
  return path;
}
