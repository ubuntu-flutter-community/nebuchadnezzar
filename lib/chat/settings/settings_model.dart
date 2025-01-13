import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:matrix/matrix.dart';
import 'package:mime/mime.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import '../../common/logging.dart';

class SettingsModel extends SafeChangeNotifier {
  SettingsModel({required Client client}) : _client = client;
  final Client _client;

  Profile? _myProfile;
  Profile? get myProfile => _myProfile;
  Future<Profile?> getMyProfile({
    Function(String error)? onFail,
  }) async {
    if (_client.userID == null) return null;
    try {
      _myProfile = await _client.getProfileFromUserId(
        _client.userID!,
      );
    } on Exception catch (e, s) {
      onFail?.call(e.toString());
      printMessageInDebugMode(e, s);
    }

    return _myProfile;
  }

  String? get myDeviceId => _client.deviceID;
  List<Device>? _devices;
  List<Device>? get devices => _devices;
  Future<void> getDevices() async {
    _devices = await _client.getDevices() ?? [];
    notifyListeners();
  }

  // TODO: authenticate for some devices
  Future<void> deleteDevice(String id) async {
    await _client.deleteDevice(id);
    await getDevices();
  }

  bool _attachingAvatar = false;
  bool get attachingAvatar => _attachingAvatar;
  void setAttachingAvatar(bool value) {
    if (value == _attachingAvatar) return;
    _attachingAvatar = value;

    notifyListeners();
  }

  Future<void> setMyProfilAvatar({
    required Function(String error) onFail,
    required Function() onWrongFileFormat,
  }) async {
    setAttachingAvatar(true);

    try {
      XFile? xFile;
      if (Platform.isLinux) {
        xFile = await openFile();
      } else {
        final result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.any,
        );
        xFile = result?.files
            .map(
              (f) => XFile(
                f.path!,
                mimeType: lookupMimeType(f.path!),
              ),
            )
            .toList()
            .firstOrNull;
      }

      if (xFile == null) {
        setAttachingAvatar(false);
        return;
      }

      final mime = xFile.mimeType;
      final bytes = await xFile.readAsBytes();
      MatrixFile? avatarDraftFile;
      if (mime?.startsWith('image') == true) {
        avatarDraftFile = await MatrixImageFile.shrink(
          bytes: bytes,
          name: xFile.name,
          mimeType: mime,
          maxDimension: 1000,
          nativeImplementations: _client.nativeImplementations,
        );
      } else {
        onWrongFileFormat();
      }

      if (avatarDraftFile != null) {
        await _client.setAvatar(avatarDraftFile);
      }
    } on Exception catch (e, s) {
      onFail(e.toString());
      printMessageInDebugMode(e, s);
    }

    setAttachingAvatar(false);
  }

  Future<void> setDisplayName({
    required String name,
    required Function(String error) onFail,
  }) async {
    if (_client.userID == null) return;
    try {
      await _client.setDisplayName(_client.userID!, name);
    } on Exception catch (e, s) {
      onFail(e.toString());
      printMessageInDebugMode(e, s);
    }
  }

  Future<void> removeProfilAvatar() async {
    await _client.setAvatar(null);
  }

  Stream<Profile?> get myProfileStream =>
      _client.onUserProfileUpdate.stream.asyncMap((u) async => getMyProfile());
}
