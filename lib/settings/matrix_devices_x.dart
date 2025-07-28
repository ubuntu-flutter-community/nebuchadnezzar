import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:yaru/yaru.dart';

IconData _getIconFromName(String displayname) {
  final name = displayname.toLowerCase();
  if ({'android'}.any((s) => name.contains(s))) {
    return YaruIcons.smartphone;
  }
  if ({'ios', 'ipad', 'iphone', 'ipod'}.any((s) => name.contains(s))) {
    return YaruIcons.apple;
  }
  if ({
    'web',
    'http://',
    'https://',
    'firefox',
    'chrome',
    '/_matrix',
    'safari',
    'opera',
  }.any((s) => name.contains(s))) {
    return YaruIcons.globe;
  }
  if ({
    'desktop',
    'windows',
    'macos',
    'linux',
    'ubuntu',
  }.any((s) => name.contains(s))) {
    return YaruIcons.computer;
  }
  return YaruIcons.phone;
}

extension DeviceExtension on Device {
  String get displayname =>
      (displayName?.isNotEmpty ?? false) ? displayName! : 'Unknown device';

  IconData get icon => _getIconFromName(displayname);
}

extension DeviceKeysExtension on DeviceKeys {
  String get displayname => (deviceDisplayName?.isNotEmpty ?? false)
      ? deviceDisplayName!
      : 'Unknown device';

  IconData get icon => _getIconFromName(displayname);
}
