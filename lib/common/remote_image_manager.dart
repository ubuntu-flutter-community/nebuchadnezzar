import 'dart:async';

import 'package:matrix/matrix.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import 'remote_image_service.dart';

class RemoteImageManager extends SafeChangeNotifier {
  RemoteImageManager({required RemoteImageService service})
    : _remoteImageService = service {
    _propertiesChangedSub ??= _remoteImageService.propertiesChanged.listen(
      (_) => notifyListeners(),
    );
  }

  final RemoteImageService _remoteImageService;
  Map<String, String> get httpHeaders => _remoteImageService.httpHeaders;
  StreamSubscription<bool>? _propertiesChangedSub;
  Uri? getAvatarUri(Uri? key) => _remoteImageService.get(key);
  Map<Uri, Uri?> get store => _remoteImageService.store;
  Future<Uri?> fetchAvatarUri({
    required Uri uri,
    num? width,
    num? height,
    ThumbnailMethod? method,
    bool? animated = false,
  }) async => _remoteImageService.fetchAvatarUri(
    uri: uri,
    animated: animated,
    height: height,
    width: width,
    method: method,
  );

  @override
  Future<void> dispose() async {
    await _propertiesChangedSub?.cancel();
    super.dispose();
  }
}
