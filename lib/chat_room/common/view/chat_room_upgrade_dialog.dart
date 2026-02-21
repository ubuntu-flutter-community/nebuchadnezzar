import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';

import '../../../common/chat_manager.dart';
import '../../../common/view/chat_avatar.dart';
import '../../../common/view/confirm.dart';
import '../../../common/view/ui_constants.dart';
import '../../../l10n/l10n.dart';
import '../../create_or_edit/edit_room_manager.dart';

class ChatRoomUpgradeDialog extends StatelessWidget {
  const ChatRoomUpgradeDialog({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      title: Text(context.l10n.roomHasBeenUpgraded),
      content: Column(
        mainAxisSize: .min,
        spacing: kMediumPadding,
        children: [
          ChatAvatar(avatarUri: room.avatar, dimension: 40),
          Flexible(child: Text(room.getLocalizedDisplayname())),
        ],
      ),
      confirmLabel: context.l10n.joinRoom,
      onConfirm: () {
        di<ChatManager>().setSelectedRoom(null);
        di<EditRoomManager>().globalLeaveRoomCommand.run(room);

        di<EditRoomManager>().knockOrJoinCommand.run((
          roomId: room
              .getState(EventTypes.RoomTombstone)!
              .parsedTombstoneContent
              .replacementRoom,
          knock: false,
        ));
      },
    );
  }
}
