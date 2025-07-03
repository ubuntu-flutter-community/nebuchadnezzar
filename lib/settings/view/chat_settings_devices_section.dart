import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/date_time_x.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/common_widgets.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../matrix_devices_x.dart';
import '../settings_model.dart';

class ChatSettingsDevicesSection extends StatelessWidget with WatchItMixin {
  const ChatSettingsDevicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final devices = watchStream(
      (SettingsModel m) => m.deviceStream,
      initialValue: di<SettingsModel>().devices,
    ).data;
    return YaruSection(
      headline: Text(l10n.devices),
      child: devices == null
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(kBigPadding),
                child: Progress(),
              ),
            )
          : Column(
              children: devices
                  .map((d) => _DeviceTile(key: ValueKey(d.deviceId), device: d))
                  .toList(),
            ),
    );
  }
}

class _DeviceTile extends StatelessWidget {
  const _DeviceTile({super.key, required this.device});

  final Device device;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final settingsModel = di<SettingsModel>();
    final keys = di<SettingsModel>().getDeviceKeys(device);
    final isOwnDevice = device.deviceId == settingsModel.myDeviceId;

    return YaruTile(
      leading: IconButton.outlined(
        onPressed: () =>
            di<SettingsModel>().verifyDeviceAction(device, context),
        icon: Icon(
          device.icon,
          color: keys == null
              ? theme.disabledColor
              : keys.blocked
              ? colorScheme.error
              : keys.verified
              ? colorScheme.success
              : colorScheme.warning,
        ),
      ),
      trailing: !isOwnDevice
          ? IconButton(
              onPressed: () => settingsModel.deleteDevice(device.deviceId),
              icon: Icon(YaruIcons.trash, color: context.colorScheme.error),
            )
          : null,
      subtitle: Text(
        DateTime.fromMillisecondsSinceEpoch(
          device.lastSeenTs ?? 0,
        ).formatAndLocalize(context, simple: true),
      ),
      title: SelectableText(device.displayName ?? device.deviceId),
    );
  }
}
