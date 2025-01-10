import 'dart:async';

import 'package:matrix/matrix.dart';

import '../common/logging.dart';

class RemoteImageService {
  RemoteImageService({required Client client}) : _client = client;
  final Client _client;
  final _propertiesChangedController = StreamController<bool>.broadcast();
  Stream<bool> get propertiesChanged => _propertiesChangedController.stream;

  Map<String, String> get httpHeaders => {
        'authorization': 'Bearer ${_client.accessToken}',
      };

  Future<Uri?> fetchAvatarUri({
    required Uri uri,
    num? width,
    num? height,
    ThumbnailMethod? method = ThumbnailMethod.scale,
    bool? animated = false,
  }) async {
    Uri? albumArtUrl;
    try {
      albumArtUrl = put(
        key: uri,
        url: await uri.getThumbnailUri(
          _client,
          animated: animated,
          height: height,
          width: width,
          method: method,
        ),
      );
    } on Exception catch (_) {
      printMessageInDebugMode('Could not find profile (anymore)');
    }
    _propertiesChangedController.add(true);

    return albumArtUrl;
  }

  final _store = <Uri, Uri?>{};
  Map<Uri, Uri?> get store => _store;

  Uri? put({required Uri key, Uri? url}) {
    return _store.containsKey(key)
        ? _store.update(key, (value) => url)
        : _store.putIfAbsent(key, () => url);
  }

  Uri? get(Uri? key) => key == null ? null : _store[key];

  Future<void> dispose() async => _propertiesChangedController.close();
}
