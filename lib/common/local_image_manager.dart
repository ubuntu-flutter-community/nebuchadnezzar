import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';

class LocalImageManager {
  final Map<String, Command<DownloadImageCapsule, Uint8List?>>
  _downloadImageCapsules = {};
  Command<DownloadImageCapsule, Uint8List?> getImageDownloadCommand(
    Event event,
  ) => _downloadImageCapsules.putIfAbsent(
    event.eventId,
    () => Command.createAsyncWithProgress(
      (param, handle) => downloadImage(
        event: param.event,
        shallBeThumbnail: param.shallBeThumbnail,
        onDownloadProgress: (progress) {
          if (progress / 100 <= 1) {
            handle.updateProgress(progress / 100);
          }
        },
      ),
      initialValue: getImageFromCache(event.eventId),
    ),
  );

  Future<Uint8List> downloadImage({
    required Event event,
    bool shallBeThumbnail = true,
    void Function(int)? onDownloadProgress,
  }) async {
    final bytes = (await event.downloadAndDecryptAttachment(
      getThumbnail: shallBeThumbnail && event.hasThumbnail,
      onDownloadProgress: onDownloadProgress,
    )).bytes;

    return _updateOrPut(id: event.eventId, data: bytes) ?? bytes;
  }

  final _cache = <String, Uint8List?>{};

  Uint8List? _updateOrPut({required String id, Uint8List? data}) =>
      _cache.containsKey(id)
      ? _cache.update(id, (value) => data)
      : _cache.putIfAbsent(id, () => data);

  Uint8List? getImageFromCache(String? id) => id == null ? null : _cache[id];
}

class DownloadImageCapsule {
  DownloadImageCapsule({required this.event, required this.shallBeThumbnail});

  final Event event;
  final bool shallBeThumbnail;
}
