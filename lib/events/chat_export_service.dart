import 'dart:async';
import 'dart:io';

import 'package:matrix/matrix.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/file_system_service.dart';

class ChatExportService {
  ChatExportService({
    required SharedPreferences preferences,
    required FileSystemService fileSystemService,
  }) : _preferences = preferences,
       _fileSystemService = fileSystemService;

  final SharedPreferences _preferences;
  final FileSystemService _fileSystemService;

  String? isEventExported(Event event) {
    var path = _preferences.getString(event.eventId);
    return path != null && File(path).existsSync() ? path : null;
  }

  Future<String?> pickLocationAndExportFile({
    required Event event,
    required String confirmButtonText,
    required String dialogTitle,
  }) async {
    if (event.attachmentMxcUrl == null) {
      return null;
    }
    final matrixFile = await event.downloadAndDecryptAttachment();
    final path = await _fileSystemService.pickLocationAndExportFile(
      confirmButtonText: confirmButtonText,
      dialogTitle: dialogTitle,
      bytes: matrixFile.bytes,
      name: matrixFile.name,
      id: event.eventId,
    );

    if (path != null) {
      if (await _preferences.setString(event.eventId, path)) {
        return path;
      }
    }
    return null;
  }
}
