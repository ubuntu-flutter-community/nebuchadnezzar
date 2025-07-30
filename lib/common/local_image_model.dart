import 'dart:async';
import 'dart:typed_data';

import 'package:matrix/matrix.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import 'local_image_service.dart';

class LocalImageModel extends SafeChangeNotifier {
  LocalImageModel({required LocalImageService service}) : _service = service {
    _propertiesChangedSub ??= _service.propertiesChanged.listen(
      (_) => notifyListeners(),
    );
  }

  final LocalImageService _service;
  StreamSubscription<bool>? _propertiesChangedSub;

  int get storeLength => _service.storeLength;
  Uint8List? get(String? id) => _service.get(id);

  Future<Uint8List?> downloadImage({
    required Event event,
    required bool cache,
  }) async => _service.downloadImage(event: event, cache: cache);

  @override
  Future<void> dispose() async {
    await _propertiesChangedSub?.cancel();
    super.dispose();
  }
}
