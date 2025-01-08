import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:matrix/matrix.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_config.dart';

class ChatDownloadService {
  ChatDownloadService({
    required Client client,
    required SharedPreferences preferences,
  })  : _client = client,
        _preferences = preferences;

  // ignore: unused_field
  final Client _client;
  final SharedPreferences _preferences;
  final _propertiesChangedController = StreamController<bool>.broadcast();
  Stream<bool> get propertiesChanged => _propertiesChangedController.stream;

  String? isEventDownloaded(Event event) {
    var path = _preferences.getString(event.eventId);
    return path != null && File(path).existsSync() ? path : null;
  }

  Future<void> init() async {}

  // TODO: use dio to download then decrypt with client, to show the download progress
  Future<void> safeFile(Event event) async {
    if (event.attachmentMxcUrl == null) {
      return;
    }
    MatrixFile? file;
    String? path;
    if (isMobilePlatform) {
      file = await event.downloadAndDecryptAttachment();
      path = await FilePicker.platform.saveFile(
        fileName: file.name,
        bytes: file.bytes,
      );
    } else {
      final directoryPath = await FilePicker.platform.getDirectoryPath();
      if (directoryPath != null) {
        file = await event.downloadAndDecryptAttachment();
        path = '$directoryPath/${file.name}';
        final download = File(path);
        await download.writeAsBytes(file.bytes);
      }
    }

    if (file != null && path != null) {
      if (await _preferences.setString(event.eventId, path)) {
        _propertiesChangedController.add(true);
      }
    }
  }

  Future<void> dispose() async => _propertiesChangedController.close();
}
