import 'dart:async';

import 'package:matrix/matrix.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

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
