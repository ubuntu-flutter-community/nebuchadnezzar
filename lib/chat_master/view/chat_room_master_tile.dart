import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../chat_room/common/view/chat_invitation_dialog.dart';
import '../../chat_room/input/draft_model.dart';
import '../../chat_room/titlebar/chat_room_pin_button.dart';
import '../../common/chat_model.dart';
import '../../common/view/scaffold_state_x.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import 'chat_master_detail_page.dart';
import 'chat_master_tile_menu.dart';
import 'chat_room_master_tile_avatar.dart';
import 'chat_room_master_tile_subtitle.dart';

class ChatRoomMasterTile extends StatelessWidget with WatchItMixin {
  const ChatRoomMasterTile({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    final chatModel = di<ChatModel>();

    final selectedRoom = watchPropertyValue((ChatModel m) => m.selectedRoom);

    return ChatMasterTileMenu(
      room: room,
      child: Padding(
        padding: const EdgeInsets.only(bottom: kSmallPadding),
        child: Stack(
          alignment: Alignment.center,
          children: [
            YaruMasterTile(
              key: ValueKey('${room.id}_master_tile'),
              selected: selectedRoom?.id != null && selectedRoom?.id == room.id,
              leading: ChatRoomMasterTileAvatar(room: room),
              title: Text(
                room.membership == Membership.invite
                    ? context.l10n.invite
                    : room.getLocalizedDisplayname(),
                maxLines: 2,
              ),
              subtitle: room.membership == Membership.invite
                  ? Text(room.getLocalizedDisplayname())
                  : ChatRoomMasterTileSubTitle(room: room),
              onTap: () async {
                di<DraftModel>().setAttaching(false);
                masterScaffoldKey.currentState?.hideDrawer();
                return switch (room.membership) {
                  Membership.join ||
                  Membership.leave => chatModel.setSelectedRoom(room),
                  Membership.invite => showDialog(
                    context: context,
                    builder: (context) => ChatInvitationDialog(room: room),
                  ),
                  _ => Future.value(),
                };
              },
            ),
            if (!room.isArchived) ...[
              if (room.notificationCount > 0)
                Positioned(
                  right: kBigPadding,
                  child: Badge(
                    largeSize: 11,
                    smallSize: 11,
                    label: Text(room.notificationCount.toString()),
                  ),
                )
              else if (room.isFavourite)
                Positioned(
                  right: kBigPadding - 3,
                  child: ChatRoomPinButton(room: room, small: true),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
