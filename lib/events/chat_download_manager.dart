import 'dart:async';

import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import '../extensions/event_x.dart';
import 'chat_download_service.dart';

class ChatDownloadManager extends SafeChangeNotifier {
  ChatDownloadManager({required ChatDownloadService service})
    : _service = service;

  final ChatDownloadService _service;
  StreamSubscription<bool>? _propertiesChangedSub;

  final _downloadCommands = <Event, Command<void, MatrixFile?>>{};
  Command<void, MatrixFile?> getDownloadCommand(Event event) =>
      _downloadCommands.putIfAbsent(
        event,
        () => Command.createAsyncWithProgress(
          (_, handle) => event.downloadAndDecryptAttachment(
            onDownloadProgress: (v) {
              // the amount of downloaded bytes is v
              // the total size of the file is event.fileSize
              final progress = event.fileSize != null && event.fileSize! > 0
                  ? v / event.fileSize!
                  : null;
              handle.updateProgress(progress ?? 0);
            },
          ),
          initialValue: null,
        ),
      );

  final _saveFileCommands =
      <
        Event,
        Command<({String confirmButtonText, String dialogTitle}), String?>
      >{};
  Command<({String confirmButtonText, String dialogTitle}), String?>
  getSaveFileCommand(Event event) => _saveFileCommands.putIfAbsent(
    event,
    () => Command.createAsync(
      (param) => _service.safeFile(
        event: event,
        confirmButtonText: param.confirmButtonText,
        dialogTitle: param.dialogTitle,
      ),
      initialValue: null,
    ),
  );

  @override
  Future<void> dispose() async {
    await _propertiesChangedSub?.cancel();
    super.dispose();
  }
}
