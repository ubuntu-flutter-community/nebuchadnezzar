import 'dart:async';

import 'package:matrix/matrix.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import 'remote_image_service.dart';

class RemoteImageManager extends SafeChangeNotifier {
  RemoteImageManager({required RemoteImageService service})
    : _onlineArtService = service {
    _propertiesChangedSub ??= _onlineArtService.propertiesChanged.listen(
      (_) => notifyListeners(),
    );
  }

  final RemoteImageService _onlineArtService;
  Map<String, String> get httpHeaders => _onlineArtService.httpHeaders;
  StreamSubscription<bool>? _propertiesChangedSub;
  Uri? getAvatarUri(Uri? key) => _onlineArtService.get(key);
  Map<Uri, Uri?> get store => _onlineArtService.store;
  Future<Uri?> fetchAvatarUri({
    required Uri uri,
    num? width,
    num? height,
    ThumbnailMethod? method,
    bool? animated = false,
  }) async => _onlineArtService.fetchAvatarUri(
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
