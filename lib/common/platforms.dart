import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:xdg_directories/xdg_directories.dart';

import '../app/app_config.dart';
import '../extensions/event_x.dart';

class Platforms {
  static bool get isWeb => kIsWeb;
  static bool get isLinux => !kIsWeb && Platform.isLinux;
  static bool get isFuchsia => !kIsWeb && Platform.isFuchsia;
  static bool get isWindows => !kIsWeb && Platform.isWindows;
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;
  static bool get isIOS => !kIsWeb && Platform.isIOS;
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  static bool get isDesktop => !kIsWeb && (isLinux || isWindows || isMacOS);
  static bool get isMobile => !kIsWeb && (isIOS || isAndroid || isFuchsia);

  static Future<String?> getDownloadsDefaultDir() async {
    String? path;
    if (Platforms.isLinux) {
      path = getUserDirectory('DOWNLOAD')?.path;
    } else if (Platforms.isMacOS || Platforms.isIOS || Platforms.isWindows) {
      path = (await getDownloadsDirectory())?.path;
    } else if (Platforms.isAndroid) {
      final androidDir = Directory('/storage/emulated/0/Download');
      if (androidDir.existsSync()) {
        path = androidDir.path;
      }
    }
    if (path != null) {
      return p.join(path, AppConfig.appName);
    }
    return null;
  }

  static Future<Directory?> getTempDir() async {
    _tempDirectory ??= await getTemporaryDirectory();
    return _tempDirectory;
  }

  static Directory? _tempDirectory;
  static Future<String> getTempFilePath(String fileName) async {
    _tempDirectory = await getTempDir();
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

  static Future<String> getDownloadFilePath(
    String fileName, {
    required SubDir subDir,
  }) async {
    final downloadsDir = await getDownloadsDefaultDir();
    if (downloadsDir == null) {
      throw Exception('Failed to get downloads directory');
    }
    final baseDirPath = p.join(downloadsDir, subDir.name);

    if (!Directory(baseDirPath).existsSync()) {
      Directory(baseDirPath).createSync(recursive: true);
    }

    final path = p.join(baseDirPath, fileName);
    return path;
  }
}

enum SubDir {
  audio('Audio'),
  voice('Voice'),
  video('Video'),
  files('Files'),
  images('Images');

  final String name;
  const SubDir(this.name);

  static SubDir fromEvent(Event event) =>
      switch ((event.messageType, event.isVoice)) {
        (MessageTypes.Image, _) => SubDir.images,
        (MessageTypes.Audio, true) => SubDir.voice,
        (MessageTypes.Audio, _) => SubDir.audio,
        (MessageTypes.Video, _) => SubDir.video,
        _ => SubDir.files,
      };
}
