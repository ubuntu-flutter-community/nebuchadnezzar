import 'package:animated_emoji/animated_emoji.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../common/view/build_context_x.dart';
import '../../../common/view/confirm.dart';
import '../../../common/view/snackbars.dart';
import '../../../common/view/ui_constants.dart';
import '../../../l10n/l10n.dart';
import '../../chat_model.dart';
import '../../room_x.dart';
import '../chat_avatar.dart';
import 'chat_create_or_edit_room_dialog.dart';
import 'chat_room_info_drawer_topic.dart';
import 'chat_room_users_list.dart';
import 'titlebar/chat_room_join_or_leave_button.dart';

class ChatRoomInfoDrawer extends StatelessWidget with WatchItMixin {
  const ChatRoomInfoDrawer({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final textTheme = theme.textTheme;

    final avatar = watchStream(
      (ChatModel m) => m.getJoinedRoomAvatarStream(room),
      initialValue: room.avatar,
      preserveState: false,
    ).data;

    return Drawer(
      child: SizedBox(
        width: kSideBarWith,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!room.isDirectChat)
              AppBar(
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: kMediumPadding,
                  children: [
                    ChatAvatar(
                      avatarUri: room.avatar,
                      fallBackIcon: YaruIcons.users,
                    ),
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(room.getLocalizedDisplayname()),
                          if (room.canonicalAlias.isNotEmpty)
                            Text(
                              room.canonicalAlias,
                              style: textTheme.labelSmall,
                            ),
                          Text(
                            room.isArchived
                                ? l10n.archive
                                : '(${room.summary.mJoinedMemberCount ?? 0} ${l10n.users})',
                            style: textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                titleTextStyle:
                    textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                automaticallyImplyLeading: false,
                actions: [
                  if (!room.isArchived && room.canEditAtleastSomething)
                    Flexible(
                      key: ValueKey(room.canEditAtleastSomething),
                      child: Padding(
                        padding: const EdgeInsets.only(right: kSmallPadding),
                        child: IconButton(
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) =>
                                ChatCreateOrEditRoomDialog(room: room),
                          ),
                          icon: const Icon(YaruIcons.pen),
                        ),
                      ),
                    )
                  else
                    Container(),
                ],
                toolbarHeight: 90,
                elevation: 0,
                shape: const RoundedRectangleBorder(side: BorderSide.none),
              ),
            if (room.isDirectChat)
              Padding(
                padding: const EdgeInsets.only(top: 2 * kBigPadding),
                child: Column(
                  spacing: kBigPadding,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ChatAvatar(
                      avatarUri: avatar,
                      dimension: 150,
                      fallBackIconSize: 80,
                    ),
                    SizedBox(
                      width: 200,
                      child: Text(
                        room.getLocalizedDisplayname(),
                        textAlign: TextAlign.center,
                        style: textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: CustomScrollView(
                  slivers: room.isArchived
                      ? [
                          const SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: AnimatedEmoji(
                                AnimatedEmojis.fallenLeaf,
                                size: 100,
                              ),
                            ),
                          ),
                        ]
                      : [
                          ChatRoomInfoDrawerTopic(room: room),
                          ChatRoomUsersList(room: room),
                        ],
                ),
              ),
            if (room.isArchived)
              Container(
                padding: const EdgeInsets.only(
                  left: kBigPadding,
                  right: kBigPadding,
                  top: kBigPadding,
                ),
                width: double.infinity,
                child: OutlinedButton.icon(
                  label: Text('${l10n.delete} '),
                  style: room.isArchived
                      ? OutlinedButton.styleFrom(
                          foregroundColor: theme.colorScheme.error,
                          backgroundColor: room.isArchived
                              ? theme.colorScheme.error.withValues(alpha: 0.03)
                              : null,
                        )
                      : null,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => ConfirmationDialog(
                      onConfirm: () async => di<ChatModel>().leaveSelectedRoom(
                        onFail: (error) =>
                            showSnackBar(context, content: Text(error)),
                        forget: true,
                      ),
                      title: Text(l10n.delete),
                      content: Text(
                        room.getLocalizedDisplayname(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  icon: Icon(
                    YaruIcons.trash,
                    color: room.isArchived ? theme.colorScheme.error : null,
                  ),
                ),
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ChatRoomJoinOrLeaveButton(room: room),
            ),
          ],
        ),
      ),
    );
  }
}
