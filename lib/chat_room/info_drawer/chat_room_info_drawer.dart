import 'package:animated_emoji/animated_emoji.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/confirm.dart';
import '../../common/view/snackbars.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../../common/chat_model.dart';
import '../../common/room_x.dart';
import '../../common/view/chat_avatar.dart';
import '../create_or_edit/chat_create_or_edit_room_dialog.dart';
import '../common/view/chat_room_display_name.dart';
import 'chat_room_info_drawer_topic.dart';
import '../common/view/chat_room_users_list.dart';
import 'chat_room_join_or_leave_button.dart';

class ChatRoomInfoDrawer extends StatelessWidget {
  const ChatRoomInfoDrawer({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final textTheme = theme.textTheme;

    return Drawer(
      child: SizedBox(
        width: kSideBarWith,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!room.isDirectChat)
              AppBar(
                leadingWidth: 80,
                leading: Center(
                  child: ChatRoomInfoDrawerAvatar(
                    key: ValueKey(
                      '${room.id}${room.avatar}${room.isDirectChat},',
                    ),
                    room: room,
                  ),
                ),
                title: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      room.isArchived
                          ? Text(room.getLocalizedDisplayname())
                          : ChatRoomDisplayName(room: room),
                      if (room.canonicalAlias.isNotEmpty)
                        Text(
                          room.canonicalAlias,
                          style: textTheme.labelSmall,
                          textAlign: TextAlign.center,
                        ),
                      Text(
                        room.isArchived
                            ? l10n.archive
                            : '(${room.summary.mJoinedMemberCount ?? 0} ${l10n.users})',
                        style: textTheme.labelSmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                titleTextStyle:
                    textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                automaticallyImplyLeading: false,
                actions: [
                  Flexible(
                    key: ValueKey(room.canEditAtleastSomething),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: kBigPadding,
                        left: kMediumPadding,
                      ),
                      child: IconButton(
                        onPressed: !room.isArchived &&
                                room.canEditAtleastSomething
                            ? () => showDialog(
                                  context: context,
                                  builder: (context) =>
                                      ChatCreateOrEditRoomDialog(room: room),
                                )
                            : null,
                        icon: const Icon(YaruIcons.pen),
                      ),
                    ),
                  ),
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
                    ChatRoomInfoDrawerAvatar(
                      key: ValueKey('${room.id}${room.avatar}'),
                      dimension: 150.0,
                      fallBackIconSize: 80,
                      room: room,
                    ),
                    SizedBox(
                      width: 300,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            room.getLocalizedDisplayname(),
                            textAlign: TextAlign.center,
                            style: textTheme.bodyLarge,
                          ),
                          Row(
                            spacing: kSmallPadding,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  room.directChatMatrixID ?? '',
                                  textAlign: TextAlign.center,
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                              IconButton(
                                onPressed: () => showSnackBar(
                                  context,
                                  content: CopyClipboardContent(
                                    text: room.directChatMatrixID ?? '',
                                  ),
                                ),
                                icon: const Icon(
                                  YaruIcons.copy,
                                ),
                              ),
                            ],
                          ),
                        ],
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
                          if (room.topic.isNotEmpty)
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

class ChatRoomInfoDrawerAvatar extends StatelessWidget with WatchItMixin {
  const ChatRoomInfoDrawerAvatar({
    super.key,
    required this.room,
    this.dimension,
    this.fallBackIconSize,
  });

  final Room room;
  final double? dimension;
  final double? fallBackIconSize;

  @override
  Widget build(BuildContext context) {
    final avatar = watchStream(
      (ChatModel m) => m.getJoinedRoomAvatarStream(room),
      initialValue: room.avatar,
    ).data;
    return ChatAvatar(
      avatarUri: avatar,
      fallBackIcon: YaruIcons.users,
      dimension: dimension ?? kAvatarDefaultSize,
      fallBackIconSize: fallBackIconSize,
    );
  }
}
