import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/chat_model.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/confirm.dart';
import '../../common/view/snackbars.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';

// Credit: this code has been inspired by https://github.com/krille-chan/fluffychat permissions
// Thank you @krille-chan
class ChatPermissionsSettingsView extends StatelessWidget with WatchItMixin {
  final Room room;

  const ChatPermissionsSettingsView({required this.room, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final chatModel = di<ChatModel>();

    final powerLevelsContent =
        watchStream(
          (ChatModel m) => m.getPermissionsStream(room),
          initialValue:
              room.getState(EventTypes.RoomPowerLevels)?.content ?? {},
        ).data ??
        room.getState(EventTypes.RoomPowerLevels)?.content ??
        {};

    final powerLevels = Map<String, dynamic>.from(powerLevelsContent)
      ..removeWhere((k, v) => v is! int);
    final eventsPowerLevels = Map<String, int?>.from(
      powerLevelsContent.tryGetMap<String, int?>('events') ?? {},
    )..removeWhere((k, v) => v is! int);

    Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSmallPadding),
      child: YaruInfoBox(
        yaruInfoType: YaruInfoType.information,
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: kSmallPadding),
          child: Text(l10n.chatPermissionsDescription),
        ),
      ),
    );

    return YaruExpansionPanel(
      shrinkWrap: true,
      headers: [
        l10n.chatPermissions,
        l10n.notifications,
        l10n.configureChat,
      ].map((e) => Text(e, style: theme.textTheme.titleLarge)).toList(),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: kMediumPadding),
          child: Column(
            children: [
              for (final entry in powerLevels.entries)
                _ChatRoomPermissionTile(
                  permissionKey: entry.key,
                  permission: entry.value,
                  onChanged: (level) => chatModel.editPowerLevel(
                    room: room,
                    key: entry.key,
                    newLevel: level,
                    onFail: () =>
                        showSnackBar(context, content: Text(l10n.noPermission)),
                    onCustomPermissionsChosen: () => _showPermissionChooser(
                      context,
                      currentLevel: entry.value,
                    ),
                  ),
                  canEdit: room.canChangePowerLevel,
                ),
            ],
          ),
        ),
        Builder(
          builder: (context) {
            const key = 'rooms';
            final value = powerLevelsContent.containsKey('notifications')
                ? powerLevelsContent
                          .tryGetMap<String, Object?>('notifications')
                          ?.tryGet<int>('rooms') ??
                      0
                : 0;
            return Padding(
              padding: const EdgeInsets.only(bottom: kMediumPadding),
              child: _ChatRoomPermissionTile(
                permissionKey: key,
                permission: value,
                category: 'notifications',
                canEdit: room.canChangePowerLevel,
                onChanged: (level) => chatModel.editPowerLevel(
                  room: room,
                  key: key,
                  onFail: () =>
                      showSnackBar(context, content: Text(l10n.noPermission)),
                  onCustomPermissionsChosen: () =>
                      _showPermissionChooser(context, currentLevel: value),
                  newLevel: level,
                  category: 'notifications',
                ),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: kMediumPadding),
          child: Column(
            spacing: kMediumPadding,
            children: [
              for (final entry in eventsPowerLevels.entries)
                _ChatRoomPermissionTile(
                  permissionKey: entry.key,
                  category: 'events',
                  permission: entry.value ?? 0,
                  canEdit: room.canChangePowerLevel,
                  onChanged: (level) => di<ChatModel>().editPowerLevel(
                    room: room,
                    onFail: () =>
                        showSnackBar(context, content: Text(l10n.noPermission)),
                    key: entry.key,
                    onCustomPermissionsChosen: () => _showPermissionChooser(
                      context,
                      currentLevel: entry.value ?? 0,
                    ),
                    newLevel: level,
                    category: 'events',
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Future<int?> _showPermissionChooser(
    BuildContext context, {
    int currentLevel = 0,
  }) async {
    final l10n = context.l10n;
    final customLevel = await showConfirmDialogWithInput(
      context: context,
      title: l10n.setPermissionsLevel,
      initialText: currentLevel.toString(),
      keyboardType: TextInputType.number,
      autocorrect: false,
      validator: (text) {
        if (text.isEmpty) {
          return l10n.pleaseEnterANumber;
        }
        final level = int.tryParse(text);
        if (level == null) {
          return l10n.pleaseEnterANumber;
        }
        return null;
      },
    );
    if (customLevel == null) return null;
    return int.tryParse(customLevel);
  }
}

class _ChatRoomPermissionTile extends StatelessWidget {
  final String permissionKey;
  final int permission;
  final String? category;
  final void Function(int? level)? onChanged;
  final bool canEdit;

  const _ChatRoomPermissionTile({
    required this.permissionKey,
    required this.permission,
    this.category,
    required this.onChanged,
    required this.canEdit,
  });

  String getLocalizedPowerLevelString(BuildContext context) {
    final l10n = context.l10n;
    if (category == null) {
      switch (permissionKey) {
        case 'users_default':
          return l10n.defaultPermissionLevel;
        case 'events_default':
          return l10n.sendMessages;
        case 'state_default':
          return l10n.changeGeneralChatSettings;
        case 'ban':
          return l10n.banFromChat;
        case 'kick':
          return l10n.kickFromChat;
        case 'redact':
          return l10n.deleteMessage;
        case 'invite':
          return l10n.inviteOtherUsers;
      }
    } else if (category == 'notifications') {
      switch (permissionKey) {
        case 'rooms':
          return l10n.sendRoomNotifications;
      }
    } else if (category == 'events') {
      switch (permissionKey) {
        case EventTypes.RoomName:
          return l10n.changeTheNameOfTheGroup;
        case EventTypes.RoomTopic:
          return l10n.changeTheDescriptionOfTheGroup;
        case EventTypes.RoomPowerLevels:
          return l10n.changeTheChatPermissions;
        case EventTypes.HistoryVisibility:
          return l10n.changeTheVisibilityOfChatHistory;
        case EventTypes.RoomCanonicalAlias:
          return l10n.changeTheCanonicalRoomAlias;
        case EventTypes.RoomAvatar:
          return l10n.editRoomAvatar;
        case EventTypes.RoomTombstone:
          return l10n.replaceRoomWithNewerVersion;
        case EventTypes.Encryption:
          return l10n.enableEncryption;
        case 'm.room.server_acl':
          return l10n.editBlockedServers;
      }
    }
    return permissionKey;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final colorScheme = theme.colorScheme;

    final color = permission >= 100
        ? colorScheme.warning
        : permission >= 50
        ? colorScheme.link
        : colorScheme.success;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: kBigPadding),
      title: Text(
        getLocalizedPowerLevelString(context),
        style: theme.textTheme.titleSmall,
      ),
      trailing: Material(
        color: color.withAlpha(32),
        borderRadius: BorderRadius.circular(kYaruContainerRadius),
        child: DropdownButton<int>(
          isDense: true,
          style: TextStyle(color: colorScheme.onSurface),
          icon: const SizedBox.shrink(),
          padding: const EdgeInsets.symmetric(
            horizontal: kMediumPadding,
            vertical: kSmallPadding,
          ),
          borderRadius: BorderRadius.circular(kYaruContainerRadius),
          underline: const SizedBox.shrink(),
          onChanged: canEdit ? onChanged : null,
          value: permission,
          items: [
            DropdownMenuItem(
              value: permission < 50 ? permission : 0,
              child: Text(l10n.userLevel(permission < 50 ? permission : 0)),
            ),
            DropdownMenuItem(
              value: permission < 100 && permission >= 50 ? permission : 50,
              child: Text(
                l10n.moderatorLevel(
                  permission < 100 && permission >= 50 ? permission : 50,
                ),
              ),
            ),
            DropdownMenuItem(
              value: permission >= 100 ? permission : 100,
              child: Text(
                l10n.adminLevel(permission >= 100 ? permission : 100),
              ),
            ),
            DropdownMenuItem(value: null, child: Text(l10n.custom)),
          ],
        ),
      ),
    );
  }
}
