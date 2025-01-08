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
    final bytes =
        (await event.downloadAndDecryptAttachment(getThumbnail: getThumbnail))
            .bytes;

    final cover = put(
      id: event.eventId,
      data: bytes,
    );
    if (cover != null) {
      _propertiesChangedController.add(true);
    }
    return cover;
  }

  Future<Uint8List?> downloadMxcCached({
    required Uri uri,
    num? width,
    num? height,
    ThumbnailMethod? thumbnailMethod,
    bool isThumbnail = false,
    bool? animated,
  }) async {
    final bytes = await _client.downloadMxcCached(
      uri,
      width: width,
      height: height,
      thumbnailMethod: thumbnailMethod,
      isThumbnail: isThumbnail,
      animated: animated,
      httpHeaders: httpHeaders,
    );

    final cover = put(
      id: uri.toString(),
      data: bytes,
    );
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

extension _ClientDownloadContentExtension on Client {
  Future<Uint8List> downloadMxcCached(
    Uri mxc, {
    num? width,
    num? height,
    bool isThumbnail = false,
    bool? animated,
    ThumbnailMethod? thumbnailMethod,
    required Map<String, String> httpHeaders,
  }) async {
    final cacheKey = isThumbnail
        ? await mxc.getThumbnailUri(
            this,
            width: width,
            height: height,
            animated: animated,
            method: thumbnailMethod!,
          )
        : mxc;

    final cachedData = await database?.getFile(cacheKey);
    if (cachedData != null) return cachedData;

    final httpUri = isThumbnail
        ? await mxc.getThumbnailUri(
            this,
            width: width,
            height: height,
            animated: animated,
            method: thumbnailMethod,
          )
        : await mxc.getDownloadUri(this);

    final response = await httpClient.get(
      httpUri,
      headers: accessToken == null ? null : httpHeaders,
    );
    if (response.statusCode != 200) {
      throw Exception();
    }
    final remoteData = response.bodyBytes;

    await database?.storeFile(cacheKey, remoteData, 0);

    return remoteData;
  }
}
