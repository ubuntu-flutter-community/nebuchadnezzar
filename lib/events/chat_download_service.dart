import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:matrix/matrix.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/platforms.dart';

class ChatDownloadService {
  ChatDownloadService({
    required Client client,
    required SharedPreferences preferences,
  }) : _client = client,
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

  Future<void> safeFile({
    required Event event,
    required String confirmButtonText,
    required String dialogTitle,
  }) async {
    if (event.attachmentMxcUrl == null) {
      return;
    }
    MatrixFile? file;
    String? path;
    if (Platforms.isMobile) {
      file = await event.downloadAndDecryptAttachment();
      path = await FilePicker.platform.saveFile(
        fileName: file.name,
        bytes: file.bytes,
      );
    } else {
      String? directoryPath;
      if (Platforms.isLinux) {
        directoryPath = await getDirectoryPath(
          confirmButtonText: confirmButtonText,
        );
      } else {
        directoryPath = await FilePicker.platform.getDirectoryPath(
          dialogTitle: dialogTitle,
        );
      }
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
