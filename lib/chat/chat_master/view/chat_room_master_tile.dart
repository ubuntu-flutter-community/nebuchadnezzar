import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../common/view/build_context_x.dart';
import '../../../common/view/scaffold_state_x.dart';
import '../../../common/view/snackbars.dart';
import '../../../common/view/ui_constants.dart';
import '../../../l10n/l10n.dart';
import '../../common/chat_model.dart';
import '../../chat_room/input/draft_model.dart';
import '../../common/view/chat_avatar.dart';
import '../../chat_room/common/view/chat_invitation_dialog.dart';
import '../../chat_room/common/view/chat_room_master_tile_subtitle.dart';
import 'chat_master_detail_page.dart';

class ChatRoomMasterTile extends StatelessWidget with WatchItMixin {
  const ChatRoomMasterTile({
    super.key,
    required this.room,
    required this.selected,
  });

  final Room room;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final chatModel = di<ChatModel>();

    final selectedRoom = watchPropertyValue((ChatModel m) => m.selectedRoom);
    final processingJoinOrLeave =
        watchPropertyValue((ChatModel m) => m.processingJoinOrLeave);
    final loadingArchive =
        watchPropertyValue((ChatModel m) => m.loadingArchive);

    return Opacity(
      opacity: processingJoinOrLeave || loadingArchive ? 0.5 : 1,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: YaruMasterTile(
          selected: selectedRoom?.id != null && selectedRoom?.id == room.id,
          leading: ChatAvatar(
            avatarUri: room.avatar,
            fallBackIcon: room.membership != Membership.invite
                ? room.isDirectChat
                    ? YaruIcons.user
                    : YaruIcons.users
                : YaruIcons.mail_unread,
          ),
          title: Text(
            room.membership == Membership.invite
                ? context.l10n.invite
                : room.getLocalizedDisplayname(),
          ),
          trailing: room.isArchived
              ? null
              : Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: kSmallPadding,
                  children: [
                    if (room.isFavourite)
                      Flexible(child: ChatRoomPinIcon(room: room)),
                    if (room.notificationCount > 0)
                      Flexible(
                        child: Badge(
                          largeSize: 11,
                          smallSize: 11,
                          label: Text(
                            room.notificationCount.toString(),
                          ),
                        ),
                      ),
                  ],
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
                        builder: (context) => ChatInvitationDialog(room: room),
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
      ),
    );
  }
}

class ChatRoomPinIcon extends StatelessWidget with WatchItMixin {
  const ChatRoomPinIcon({
    super.key,
    required this.room,
  });

  final Room room;

  @override
  Widget build(BuildContext context) {
    watchStream((ChatModel m) => m.getJoinedRoomUpdate(room.id)).data;

    return Icon(
      YaruIcons.pin,
      color: room.isFavourite ? context.colorScheme.primary : null,
      size: 20,
    );
  }
}
