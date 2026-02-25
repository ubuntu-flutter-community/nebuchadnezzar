import 'dart:async';
import 'dart:io';

import 'package:matrix/matrix.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/external_path_service.dart';

class ChatExportService {
  ChatExportService({
    required Client client,
    required SharedPreferences preferences,
    required ExternalPathService externalPathService,
  }) : _client = client,
       _preferences = preferences,
       _externalPathService = externalPathService;

  // ignore: unused_field
  final Client _client;
  final SharedPreferences _preferences;
  final ExternalPathService _externalPathService;

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
    final path = await _externalPathService.pickLocationAndExportFile(
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
