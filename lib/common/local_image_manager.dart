import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import 'local_image_service.dart';

class LocalImageManager extends SafeChangeNotifier {
  LocalImageManager({required LocalImageService service}) : _service = service {
    _propertiesChangedSub ??= _service.propertiesChanged.listen(
      (_) => notifyListeners(),
    );
  }

  final LocalImageService _service;
  StreamSubscription<bool>? _propertiesChangedSub;

  int get storeLength => _service.storeLength;
  Uint8List? get(String? id) => _service.get(id);

  late final Command<
    ({Event event, bool cache, bool shallBeThumbnail}),
    Uint8List?
  >
  downloadImageCommand = Command.createAsync(
    (param) => _service.downloadImage(
      cache: param.cache,
      event: param.event,
      shallBeThumbnail: param.shallBeThumbnail,
    ),
    initialValue: null,
  );

  Future<Uint8List?> downloadImage({
    required Event event,
    required bool cache,
    bool shallBeThumbnail = true,
  }) async => _service.downloadImage(
    event: event,
    cache: cache,
    shallBeThumbnail: shallBeThumbnail,
  );

  @override
  Future<void> dispose() async {
    await _propertiesChangedSub?.cancel();
    super.dispose();
  }
}
