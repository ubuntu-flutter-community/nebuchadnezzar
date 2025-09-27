import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../common/constants.dart';
import '../../../common/view/build_context_x.dart';
import '../../../common/view/confirm.dart';
import '../../../l10n/l10n.dart';
import '../../create_or_edit/edit_room_service.dart';

class ChatRoomUserListTilePowerLevelButton extends StatelessWidget
    with WatchItMixin {
  const ChatRoomUserListTilePowerLevelButton({required this.user, super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final room = user.room;

    final myUser = room.getParticipants().firstWhereOrNull(
      (u) => u.id == room.client.userID,
    );

    final ownPowerLevel = myUser == null
        ? 0
        : watchStream(
                (EditRoomService m) => m
                    .getJoinedRoomUpdate(room.id)
                    .map((r) => myUser.powerLevel),
                initialValue: myUser.powerLevel,
              ).data ??
              myUser.powerLevel;

    final userPowerLevel =
        watchStream(
          (EditRoomService m) =>
              m.getJoinedRoomUpdate(room.id).map((r) => user.powerLevel),
          initialValue: user.powerLevel,
        ).data ??
        0;

    final canChangePowerLevel = room.canChangeStateEvent(
      EventTypes.RoomPowerLevels,
    );

    if (canChangePowerLevel && user.id != room.client.userID) {
      return PopupMenuButton<int>(
        initialValue: userPowerLevel,
        tooltip: ownPowerLevel > userPowerLevel
            ? l10n.changePowerLevel
            : l10n.canNotChangePowerLevel,
        enabled: ownPowerLevel > userPowerLevel,
        itemBuilder: (context) => [
          PopupMenuItem(
            enabled: ownPowerLevel > memberPowerLevel,
            value: memberPowerLevel,
            child: Text(l10n.member),
          ),
          PopupMenuItem(
            enabled: ownPowerLevel > moderatorPowerLevel,
            value: moderatorPowerLevel,
            child: Text(l10n.moderator),
          ),
          PopupMenuItem(
            enabled: ownPowerLevel >= adminPowerLevel,
            value: adminPowerLevel,
            child: Text(l10n.admin),
          ),
        ],
        onSelected: (v) => ConfirmationDialog.show(
          context: context,
          title: Text(l10n.changePowerLevel),
          content: Text(
            l10n.changePowerLevelForUserToValue(
              user.displayName ?? user.id,
              switch (v) {
                memberPowerLevel => l10n.member,
                moderatorPowerLevel => l10n.moderator,
                adminPowerLevel => l10n.admin,
                _ => 'unknown',
              },
            ),
          ),
          onConfirm: () =>
              di<EditRoomService>().changePowerLevel(user: user, powerLevel: v),
        ),
        icon: Icon(
          YaruIcons.settings,
          color: ownPowerLevel > userPowerLevel
              ? null
              : context.theme.disabledColor,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
