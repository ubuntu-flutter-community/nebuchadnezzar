import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../common/date_time_x.dart';
import '../../../common/view/build_context_x.dart';
import '../../../common/view/common_widgets.dart';
import '../../../common/view/snackbars.dart';
import '../../../common/view/ui_constants.dart';

import '../../common/chat_model.dart';
import '../matrix_devices_x.dart';
import '../settings_model.dart';
import 'chat_my_user_avatar.dart';
import 'logout_button.dart';

class SettingsDialog extends StatefulWidget with WatchItStatefulWidgetMixin {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late final TextEditingController _displayNameController;
  late final TextEditingController _idController;

  @override
  void initState() {
    super.initState();
    final settingsModel = di<SettingsModel>();
    settingsModel.init();
    _displayNameController =
        TextEditingController(text: settingsModel.myProfile?.displayName ?? '');
    _idController = TextEditingController(text: di<ChatModel>().myUserId);
  }

  @override
  void dispose() {
    super.dispose();
    _displayNameController.dispose();
    _idController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settingsModel = di<SettingsModel>();

    final profile = watchStream(
      (SettingsModel m) => m.myProfileStream,
      initialValue: settingsModel.myProfile,
      preserveState: false,
    ).data;

    final devices = watchStream(
      (SettingsModel m) => m.deviceStream,
      initialValue: settingsModel.devices,
    ).data;

    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      title: YaruDialogTitleBar(
        title: Text(l10n.settings),
        border: BorderSide.none,
        backgroundColor: Colors.transparent,
      ),
      scrollable: true,
      content: SizedBox(
        width: 450,
        child: Column(
          spacing: 2 * kBigPadding,
          children: [
            ChatMyUserAvatar(
              key: ValueKey(profile?.avatarUrl),
              uri: profile?.avatarUrl,
              dimension: 100,
              iconSize: 70,
            ),
            YaruSection(
              headline: Text(l10n.account),
              child: Column(
                children: [
                  YaruTile(
                    title: TextField(
                      controller: _displayNameController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          style: IconButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(6),
                                bottomRight: Radius.circular(6),
                              ),
                            ),
                          ),
                          onPressed: profile?.displayName !=
                                  _displayNameController.text
                              ? () => di<SettingsModel>().setDisplayName(
                                    name: _displayNameController.text,
                                    onFail: (e) =>
                                        showErrorSnackBar(context, e),
                                  )
                              : null,
                          icon: const Icon(YaruIcons.save),
                        ),
                        contentPadding: const EdgeInsets.all(10.5),
                        label: Text(l10n.editDisplayname),
                      ),
                    ),
                  ),
                  YaruTile(
                    title: TextField(
                      enabled: false,
                      controller: _idController,
                    ),
                    trailing: const LogoutButton(),
                  ),
                ],
              ),
            ),
            const ChatEventSettings(),
            YaruSection(
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
                          .map(
                            (d) => DeviceTile(device: d),
                          )
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeviceTile extends StatelessWidget {
  const DeviceTile({
    super.key,
    required this.device,
  });

  final Device device;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
              icon: Icon(
                YaruIcons.trash,
                color: context.colorScheme.error,
              ),
            )
          : null,
      subtitle: Text(
        DateTime.fromMillisecondsSinceEpoch(
          device.lastSeenTs ?? 0,
        ).formatAndLocalize(l10n, simple: true),
      ),
      title: SelectableText(device.displayName ?? device.deviceId),
    );
  }
}

class ChatEventSettings extends StatelessWidget with WatchItMixin {
  const ChatEventSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settingsModel = di<SettingsModel>();

    return YaruSection(
      // TODO: localize
      headline: const Text('Show these events in the chat'),
      child: Column(
        children: [
          YaruTile(
            title: Text(l10n.changedTheChatAvatar('"UserABC"')),
            trailing: CommonSwitch(
              value: watchPropertyValue(
                (SettingsModel m) => m.showChatAvatarChanges,
              ),
              onChanged: settingsModel.setShowAvatarChanges,
            ),
          ),
          YaruTile(
            title: Text(l10n.changedTheDisplaynameTo('"UserABC"', '"UserXYZ"')),
            trailing: CommonSwitch(
              value: watchPropertyValue(
                (SettingsModel m) => m.showChatDisplaynameChanges,
              ),
              onChanged: settingsModel.setShowChatDisplaynameChanges,
            ),
          ),
        ],
      ),
    );
  }
}
