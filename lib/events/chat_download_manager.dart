import 'dart:async';

import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import '../extensions/event_x.dart';
import 'chat_download_service.dart';

class ChatDownloadManager extends SafeChangeNotifier {
  ChatDownloadManager({required ChatDownloadService service})
    : _service = service {
    _propertiesChangedSub = _service.propertiesChanged.listen(
      (_) => notifyListeners(),
    );
  }

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

  String? isEventDownloaded(Event event) => _service.isEventDownloaded(event);
  Future<void> safeFile({
    required Event event,
    required String confirmButtonText,
    required String dialogTitle,
  }) async => _service.safeFile(
    event: event,
    confirmButtonText: confirmButtonText,
    dialogTitle: dialogTitle,
  );

  @override
  Future<void> dispose() async {
    await _propertiesChangedSub?.cancel();
    super.dispose();
  }
}
