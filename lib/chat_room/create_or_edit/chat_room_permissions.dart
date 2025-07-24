import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/snackbars.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import 'create_or_edit_room_model.dart';

// Credit: this code has been inspired by https://github.com/krille-chan/fluffychat permissions
// Thank you @krille-chan
class ChatRoomPermissions extends StatelessWidget with WatchItMixin {
  final Room room;

  const ChatRoomPermissions({required this.room, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final model = di<CreateOrEditRoomModel>();

    final canChangePowerLevel =
        watchStream(
          (CreateOrEditRoomModel m) => m
              .getJoinedRoomUpdate(room.id)
              .map((_) => room.canChangePowerLevel),
          initialValue: room.canChangePowerLevel,
          preserveState: false,
        ).data ??
        room.canChangePowerLevel;

    final powerLevelsContent =
        watchStream(
          (CreateOrEditRoomModel m) => m.getPermissionsStream(room),
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
                  canEdit: canChangePowerLevel,
                  permissionKey: entry.key,
                  permission: entry.value,
                  onChanged: (level) => showFutureLoadingDialog(
                    context: context,
                    onError: (e) {
                      showSnackBar(context, content: Text(e.toString()));
                      return e;
                    },
                    future: () => model.editPowerLevel(
                      room: room,
                      key: entry.key,
                      newLevel: level,
                    ),
                  ),
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
                canEdit: canChangePowerLevel,
                permissionKey: key,
                permission: value,
                category: 'notifications',
                onChanged: (level) => showFutureLoadingDialog(
                  context: context,
                  onError: (e) {
                    showSnackBar(context, content: Text(e.toString()));
                    return e;
                  },
                  future: () => model.editPowerLevel(
                    room: room,
                    key: key,
                    newLevel: level,
                    category: 'notifications',
                  ),
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
                  canEdit: canChangePowerLevel,
                  permissionKey: entry.key,
                  category: 'events',
                  permission: entry.value ?? 0,

                  onChanged: (level) => showFutureLoadingDialog(
                    context: context,
                    onError: (e) {
                      showSnackBar(context, content: Text(e.toString()));
                      return e;
                    },
                    future: () => model.editPowerLevel(
                      room: room,
                      key: entry.key,
                      newLevel: level,
                      category: 'events',
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChatRoomPermissionTile extends StatelessWidget with WatchItMixin {
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
    final style = canEdit
        ? theme.textTheme.bodyMedium
        : theme.textTheme.bodyMedium?.copyWith(color: theme.disabledColor);

    final color = !canEdit
        ? theme.disabledColor
        : permission >= 100
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
      trailing: YaruPopupMenuButton<int>(
        onSelected: onChanged,
        initialValue: permission,
        child: Text(
          permission.toString(),
          style: style?.copyWith(color: color),
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            enabled: canEdit,
            value: permission < 50 ? permission : 0,
            child: Text(
              l10n.userLevel(permission < 50 ? permission : 0),
              style: style,
            ),
          ),
          PopupMenuItem(
            enabled: canEdit,
            value: permission < 100 && permission >= 50 ? permission : 50,
            child: Text(
              l10n.moderatorLevel(
                permission < 100 && permission >= 50 ? permission : 50,
              ),
              style: style,
            ),
          ),
          PopupMenuItem(
            enabled: canEdit,
            value: permission >= 100 ? permission : 100,
            child: Text(
              l10n.adminLevel(permission >= 100 ? permission : 100),
              style: style,
            ),
          ),
        ],
      ),
    );
  }
}
