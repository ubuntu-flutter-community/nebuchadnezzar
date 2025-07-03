import 'dart:async';
import 'dart:typed_data';

import 'package:matrix/matrix.dart';

class LocalImageService {
  LocalImageService({required Client client}) : _client = client;

  final Client _client;

  final _propertiesChangedController = StreamController<bool>.broadcast();
  Stream<bool> get propertiesChanged => _propertiesChangedController.stream;

  final _store = <String, Uint8List?>{};
  int get storeLength => _store.length;

  Future<Uint8List?> downloadImage({
    required Event event,
    required bool getThumbnail,
  }) async {
    final bytes = (await event.downloadAndDecryptAttachment(
      getThumbnail: getThumbnail,
    )).bytes;

    final cover = put(id: event.eventId, data: bytes);
    if (cover != null) {
      _propertiesChangedController.add(true);
    }
    return cover;
  }

  Map<String, String> get httpHeaders => {
    'authorization': 'Bearer ${_client.accessToken}',
  };

  Uint8List? put({required String id, Uint8List? data}) =>
      _store.containsKey(id)
      ? _store.update(id, (value) => data)
      : _store.putIfAbsent(id, () => data);

  Uint8List? get(String? id) => id == null ? null : _store[id];

  Future<void> dispose() async => _propertiesChangedController.close();
}
