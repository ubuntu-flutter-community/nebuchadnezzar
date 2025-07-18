import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:matrix/encryption/utils/key_verification.dart';
import 'package:matrix/matrix.dart';
import 'package:mime/mime.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import '../common/logging.dart';
import '../common/platforms.dart';
import '../encryption/view/key_verification_dialog.dart';
import 'settings_service.dart';

class SettingsModel extends SafeChangeNotifier {
  SettingsModel({
    required Client client,
    required SettingsService settingsService,
  }) : _client = client,
       _settingsService = settingsService;

  final Client _client;
  final SettingsService _settingsService;
  StreamSubscription<bool>? _propertiesChangedSub;

  Future<void> init() async {
    if (_client.isLogged()) {
      await getDevices();
      await getMyProfile();
    }

    _propertiesChangedSub ??= _settingsService.propertiesChanged.listen(
      (_) => notifyListeners(),
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    return _propertiesChangedSub?.cancel();
  }

  bool get showChatAvatarChanges => _settingsService.showAvatarChanges;
  void setShowAvatarChanges(bool value) =>
      _settingsService.setShowAvatarChanges(value);

  bool get showChatDisplaynameChanges =>
      _settingsService.showChatDisplaynameChanges;
  void setShowChatDisplaynameChanges(bool value) =>
      _settingsService.setShowChatDisplaynameChanges(value);

  List<String> get defaultReactions => _settingsService.defaultReactions;
  void setDefaultReactions(List<String> value) =>
      _settingsService.setDefaultReactions(value);

  int get themModeIndex => _settingsService.themModeIndex;
  void setThemModeIndex(int i) => _settingsService.setThemModeIndex(i);

  Profile? _myProfile;
  Profile? get myProfile => _myProfile;
  CachedPresence? get presence => _presence;
  CachedPresence? _presence;

  Stream<CachedPresence?> get presenceStream => _client.onPresenceChanged.stream
      .where((cachedPresence) => cachedPresence.userid == _client.userID);

  Future<void> setStatus(String? text) => _client.userID == null
      ? Future.value()
      : _client.setPresence(
          _client.userID!,
          PresenceType.online,
          statusMsg: text,
        );

  Future<Profile?> getMyProfile({Function(String error)? onFail}) async {
    if (_client.userID == null) return null;
    try {
      _presence = await _client.fetchCurrentPresence(_client.userID!);
      _myProfile = await _client.getProfileFromUserId(_client.userID!);
      notifyListeners();
    } on Exception catch (e, s) {
      onFail?.call(e.toString());
      printMessageInDebugMode(e, s);
    }

    return _myProfile;
  }

  Map<String, DeviceKeysList> get userDeviceKeys => _client.userDeviceKeys;
  DeviceKeys? getDeviceKeys(Device device) =>
      userDeviceKeys[_client.userID]?.deviceKeys[device.deviceId];
  Stream<List<Device>?> get deviceStream =>
      _client.onSync.stream.asyncMap((e) async => _client.getDevices());
  String? get myDeviceId => _client.deviceID;
  List<Device>? _devices;
  List<Device>? get devices => _devices;
  Future<void> getDevices() async {
    _devices = await _client.getDevices() ?? [];
    notifyListeners();
  }

  Future<void> deleteDevice(String id) async {
    try {
      await _client.uiaRequestBackground((auth) async {
        await _client.deleteDevice(id, auth: auth);
      });
      await getDevices();
    } on Exception catch (e, s) {
      printMessageInDebugMode(e, s);
    }
  }

  Future<void> verifyDeviceAction(Device device, BuildContext context) async {
    final keyVerification = await _client
        .userDeviceKeys[_client.userID!]!
        .deviceKeys[device.deviceId]!
        .startVerification();
    keyVerification.onUpdate = () async {
      if ({
        KeyVerificationState.error,
        KeyVerificationState.done,
      }.contains(keyVerification.state)) {
        await getDevices();
      }
    };
    if (!context.mounted) return;
    await KeyVerificationDialog(
      request: keyVerification,
      verifyOther: true,
    ).show(context);
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
      if (Platforms.isLinux) {
        xFile = await openFile();
      } else {
        final result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.any,
        );
        xFile = result?.files
            .map((f) => XFile(f.path!, mimeType: lookupMimeType(f.path!)))
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
