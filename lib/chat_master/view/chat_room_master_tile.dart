import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../chat_room/common/view/chat_invitation_dialog.dart';
import '../../chat_room/input/draft_model.dart';
import '../../chat_room/titlebar/chat_room_pin_button.dart';
import '../../common/chat_model.dart';
import '../../common/push_rule_state_x.dart';
import '../../common/view/chat_avatar.dart';
import '../../common/view/scaffold_state_x.dart';
import '../../common/view/snackbars.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import 'chat_master_detail_page.dart';
import 'chat_room_master_tile_subtitle.dart';

class ChatRoomMasterTile extends StatelessWidget with WatchItMixin {
  const ChatRoomMasterTile({
    super.key,
    required this.room,
  });

  final Room room;

  @override
  Widget build(BuildContext context) {
    final chatModel = di<ChatModel>();

    final selectedRoom = watchPropertyValue((ChatModel m) => m.selectedRoom);
    final processingJoinOrLeave =
        watchPropertyValue((ChatModel m) => m.processingJoinOrLeave);
    final loadingArchive =
        watchPropertyValue((ChatModel m) => m.loadingArchive);

    final pushRuleState = watchStream(
          (ChatModel m) => m.syncStream.map((_) => room.pushRuleState),
          initialValue: room.pushRuleState,
        ).data ??
        room.pushRuleState;

    return Opacity(
      opacity: processingJoinOrLeave || loadingArchive ? 0.3 : 1,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Stack(
          alignment: Alignment.center,
          children: [
            YaruMasterTile(
              selected: selectedRoom?.id != null && selectedRoom?.id == room.id,
              leading: ChatAvatar(
                key: ValueKey(room.avatar?.toString()),
                avatarUri: pushRuleState == PushRuleState.dontNotify
                    ? null
                    : room.avatar,
                fallBackIcon: room.membership != Membership.invite
                    ? pushRuleState == PushRuleState.dontNotify
                        ? pushRuleState.getIconData()
                        : room.isDirectChat
                            ? YaruIcons.user
                            : YaruIcons.users
                    : YaruIcons.mail_unread,
              ),
              title: Text(
                room.membership == Membership.invite
                    ? context.l10n.invite
                    : room.getLocalizedDisplayname(),
                maxLines: 2,
              ),
              subtitle: room.membership == Membership.invite
                  ? Text(room.getLocalizedDisplayname())
                  : ChatRoomMasterTileSubTitle(room: room),
              onTap: processingJoinOrLeave || loadingArchive
                  ? null
                  : () async {
                      if (room.isArchived) {
                        chatModel.setSelectedRoom(room);
                      } else {
                        if (room.membership == Membership.invite) {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                ChatInvitationDialog(room: room),
                          );
                        } else {
                          await chatModel.joinRoom(
                            room,
                            onFail: (e) => showSnackBar(
                              context,
                              content: Text(e),
                            ),
                          );
                        }
                      }
                      di<DraftModel>().setAttaching(false);

                      masterScaffoldKey.currentState?.hideDrawer();
                    },
            ),
            if (!room.isArchived) ...[
              if (room.notificationCount > 0)
                Positioned(
                  right: kBigPadding,
                  child: Badge(
                    largeSize: 11,
                    smallSize: 11,
                    label: Text(
                      room.notificationCount.toString(),
                    ),
                  ),
                )
              else if (room.isFavourite)
                Positioned(
                  right: kBigPadding,
                  child: ChatRoomPinButton(
                    room: room,
                    small: true,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
