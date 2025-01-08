import 'dart:async';

import 'package:matrix/matrix.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import 'chat_download_service.dart';

class ChatDownloadModel extends SafeChangeNotifier {
  ChatDownloadModel({required ChatDownloadService service})
      : _service = service;

  final ChatDownloadService _service;
  StreamSubscription<bool>? _propertiesChangedSub;

  String? isEventDownloaded(Event event) => _service.isEventDownloaded(event);
  Future<void> safeFile(Event event) async => _service.safeFile(event);

  void init() => _propertiesChangedSub =
      _service.propertiesChanged.listen((_) => notifyListeners());

  @override
  Future<void> dispose() async {
    await _propertiesChangedSub?.cancel();
    super.dispose();
  }
}
