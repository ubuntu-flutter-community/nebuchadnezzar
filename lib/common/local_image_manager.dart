import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import 'local_image_service.dart';

class LocalImageManager extends SafeChangeNotifier {
  LocalImageManager({required LocalImageService service}) : _service = service;

  final LocalImageService _service;
  StreamSubscription<bool>? _propertiesChangedSub;

  int get storeLength => _service.storeLength;
  Uint8List? getImageFromCache(String? id) => _service.getImageFromCache(id);

  final Map<String, Command<DownloadImageCapsule, Uint8List?>>
  _downloadImageCapsules = {};
  Command<DownloadImageCapsule, Uint8List?> getImageDownloadCommand(
    Event event,
  ) => _downloadImageCapsules.putIfAbsent(
    event.eventId,
    () => Command.createAsync(
      (param) => _service.downloadImage(
        event: param.event,
        shallBeThumbnail: param.shallBeThumbnail,
      ),
      initialValue: _service.getImageFromCache(event.eventId),
    ),
  );

  Future<Uint8List?> downloadImage({
    required Event event,
    bool shallBeThumbnail = true,
  }) async =>
      _service.downloadImage(event: event, shallBeThumbnail: shallBeThumbnail);

  @override
  Future<void> dispose() async {
    await _propertiesChangedSub?.cancel();
    super.dispose();
  }
}

class DownloadImageCapsule {
  DownloadImageCapsule({required this.event, required this.shallBeThumbnail});

  final Event event;
  final bool shallBeThumbnail;
}
