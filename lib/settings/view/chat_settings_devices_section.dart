import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../app/view/error_page.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/common_widgets.dart';
import '../../extensions/date_time_x.dart';
import '../../l10n/l10n.dart';
import '../account_manager.dart';
import '../matrix_devices_x.dart';

class ChatSettingsDevicesSection extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const ChatSettingsDevicesSection({super.key});

  @override
  State<ChatSettingsDevicesSection> createState() =>
      _ChatSettingsDevicesSectionState();
}

class _ChatSettingsDevicesSectionState
    extends State<ChatSettingsDevicesSection> {
  late Future<List<Device>?> _devicesFuture;

  @override
  void initState() {
    super.initState();
    _getFuture();
  }

  void _getFuture() {
    _devicesFuture = di<AccountManager>().getDevices();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final devices = watchStream((AccountManager m) => m.deviceStream).data;

    return FutureBuilder(
      future: _devicesFuture,
      builder: (context, snapshot) {
        return YaruSection(
          headline: Text(l10n.devices),
          child: snapshot.hasError
              ? Center(child: ErrorBody(error: snapshot.error.toString()))
              : !snapshot.hasData
              ? const Center(child: Progress())
              : Column(
                  children: (devices ?? snapshot.data ?? [])
                      .map(
                        (d) => _DeviceTile(
                          key: ValueKey(d.deviceId),
                          device: d,
                          onDone: () async => _getFuture(),
                        ),
                      )
                      .toList(),
                ),
        );
      },
    );
  }
}

class _DeviceTile extends StatelessWidget {
  const _DeviceTile({super.key, required this.device, this.onDone});

  final Device device;
  final Future<void> Function()? onDone;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final keys = di<AccountManager>().getDeviceKeys(device);
    final isOwnDevice = device.deviceId == di<AccountManager>().myDeviceId;

    return YaruTile(
      leading: IconButton.outlined(
        onPressed: () => di<AccountManager>().verifyDeviceAction(
          device: device,
          context: context,
          onDone: onDone,
        ),
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
              onPressed: () => showFutureLoadingDialog(
                context: context,
                future: () =>
                    di<AccountManager>().deleteDevice(device.deviceId),
              ),
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
