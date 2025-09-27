import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:matrix/encryption/utils/key_verification.dart';
import 'package:matrix/matrix.dart';
import 'package:mime/mime.dart';

import '../common/logging.dart';
import '../common/platforms.dart';
import '../encryption/view/key_verification_dialog.dart';
import '../common/xtypegroup_x.dart';

class AccountManager {
  AccountManager({required Client client}) : _client = client;

  final Client _client;

  Stream<CachedPresence?> get presenceStream => _client.onPresenceChanged.stream
      .where((cachedPresence) => cachedPresence.userid == _client.userID);

  Future<void> setStatus(String? text) => _client.userID == null
      ? Future.value()
      : _client.setPresence(
          _client.userID!,
          PresenceType.online,
          statusMsg: text,
        );

  Future<Profile?> getMyProfile() async {
    try {
      return _client.fetchOwnProfile();
    } on Exception catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }

  Future<List<Device>?> getDevices() async {
    try {
      return _client.getDevices();
    } on Exception catch (e, s) {
      printMessageInDebugMode(e, s);
      return null;
    }
  }

  Map<String, DeviceKeysList> get userDeviceKeys => _client.userDeviceKeys;
  DeviceKeys? getDeviceKeys(Device device) =>
      userDeviceKeys[_client.userID]?.deviceKeys[device.deviceId];
  Stream<List<Device>?> get deviceStream =>
      _client.onSync.stream.asyncMap((e) async => _client.getDevices());
  String? get myDeviceId => _client.deviceID;

  Future<void> deleteDevice(String id) async {
    try {
      await _client.uiaRequestBackground((auth) async {
        await _client.deleteDevice(id, auth: auth);
      });
    } on Exception catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }

  Future<void> verifyDeviceAction({
    required Device device,
    required BuildContext context,
    required Future<void> Function()? onDone,
  }) async {
    final keyVerification = await _client
        .userDeviceKeys[_client.userID!]!
        .deviceKeys[device.deviceId]!
        .startVerification();
    keyVerification.onUpdate = () async {
      if ({
        KeyVerificationState.error,
        KeyVerificationState.done,
      }.contains(keyVerification.state)) {
        await onDone?.call();
      }
    };
    if (!context.mounted) return;
    await KeyVerificationDialog(
      request: keyVerification,
      verifyOther: true,
    ).show(context);
  }

  Future<void> setMyProfilAvatar({
    required String wrongFileFormat,
    bool clear = false,
  }) async {
    if (clear) {
      try {
        await _client.setAvatar(null);
      } on Exception catch (e, s) {
        printMessageInDebugMode(e, s);
        rethrow;
      }
    }

    try {
      XFile? xFile;
      if (Platforms.isLinux) {
        xFile = await openFile(
          acceptedTypeGroups: <XTypeGroup>[
            XTypeGroupX.jpgsTypeGroup,
            XTypeGroupX.pngTypeGroup,
          ],
        );
      } else {
        final result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.image,
        );
        xFile = result?.files
            .map((f) => XFile(f.path!, mimeType: lookupMimeType(f.path!)))
            .toList()
            .firstOrNull;
      }

      if (xFile == null) {
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
        printMessageInDebugMode(wrongFileFormat);
        throw Exception(wrongFileFormat);
      }

      await _client.setAvatar(avatarDraftFile);
    } on Exception catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }

  Future<void> setDisplayName({required String name}) async {
    if (_client.userID == null) return;
    try {
      await _client.setDisplayName(_client.userID!, name);
    } on Exception catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }

  Stream<Profile?> get myProfileStream =>
      _client.onUserProfileUpdate.stream.asyncMap((u) async => getMyProfile());
}
