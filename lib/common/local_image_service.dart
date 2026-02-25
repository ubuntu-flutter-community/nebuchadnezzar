import 'dart:async';
import 'dart:typed_data';

import 'package:matrix/matrix.dart';

class LocalImageService {
  LocalImageService({required Client client}) : _client = client;

  final Client _client;
  final _store = <String, Uint8List?>{};
  int get storeLength => _store.length;

  Future<Uint8List?> downloadImage({
    required Event event,
    required bool shallBeThumbnail,
  }) async {
    final bytes = (await event.downloadAndDecryptAttachment(
      getThumbnail: shallBeThumbnail && event.hasThumbnail,
    )).bytes;

    final cover = put(id: event.eventId, data: bytes);

    return cover;
  }

  Map<String, String> get httpHeaders => {
    'authorization': 'Bearer ${_client.accessToken}',
  };

  Uint8List? put({required String id, Uint8List? data}) =>
      _store.containsKey(id)
      ? _store.update(id, (value) => data)
      : _store.putIfAbsent(id, () => data);

  Uint8List? getImageFromCache(String? id) => id == null ? null : _store[id];
}
