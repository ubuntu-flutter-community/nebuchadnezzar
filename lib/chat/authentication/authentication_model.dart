import 'package:matrix/matrix.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import '../../common/logging.dart';

class AuthenticationModel extends SafeChangeNotifier {
  AuthenticationModel({required Client client}) : _client = client;

  final Client _client;

  bool _processingAccess = false;
  bool get processingAccess => _processingAccess;
  void _setProcessingAccess(bool value) {
    if (value == _processingAccess) return;
    _processingAccess = value;
    notifyListeners();
  }

  bool _showPassword = false;
  bool get showPassword => _showPassword;
  void toggleShowPassword({bool? forceValue}) {
    _showPassword = forceValue ?? !_showPassword;
    notifyListeners();
  }

  Future<void> login({
    required String homeServer,
    required String username,
    required String password,
    required Function(String error) onFail,
    required Future Function() onSuccess,
  }) async {
    _setProcessingAccess(true);
    try {
      await _client.checkHomeserver(Uri.https(homeServer, ''));

      await _client.login(
        LoginType.mLoginPassword,
        password: password,
        identifier: AuthenticationUserIdentifier(user: username),
      );
      await _client.firstSyncReceived;
      await _client.roomsLoading;
      await _loadMediaConfig();
      await onSuccess();
    } on Exception catch (e, s) {
      await onFail(e.toString());
      printMessageInDebugMode(e, s);
    } finally {
      _setProcessingAccess(false);
    }
  }

  Future logout({
    required Function(String error) onFail,
  }) async {
    _setProcessingAccess(true);
    try {
      await _client.logout();
    } on Exception catch (e) {
      onFail(e.toString());
    } finally {
      _setProcessingAccess(false);
    }
  }

  int get maxUploadSize => _mediaConfig?.mUploadSize ?? 100 * 1000 * 1000;
  MediaConfig? _mediaConfig;

  Future<void> _loadMediaConfig() async {
    _mediaConfig = await _client.getConfig();
  }
}
