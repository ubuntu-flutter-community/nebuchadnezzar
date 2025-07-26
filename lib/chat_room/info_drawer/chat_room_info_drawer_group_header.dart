import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:yaru/yaru.dart';

import '../../common/room_x.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/snackbars.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../common/view/chat_room_display_name.dart';
import '../create_or_edit/view/create_or_edit_room_dialog.dart';
import 'chat_room_info_drawer_avatar.dart';

class ChatRoomInfoDrawerGroupHeader extends StatelessWidget {
  const ChatRoomInfoDrawerGroupHeader({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final textTheme = theme.textTheme;
    return AppBar(
      leadingWidth: 80,
      leading: Center(
        child: ChatRoomInfoDrawerAvatar(
          key: ValueKey('${room.id}${room.avatar} '),
          room: room,
        ),
      ),
      title: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            room.isArchived
                ? Text(room.getLocalizedDisplayname())
                : ChatRoomDisplayName(
                    key: ValueKey('${room.id}_name_,'),
                    room: room,
                  ),
            if (room.canonicalAlias.isNotEmpty)
              InkWell(
                borderRadius: BorderRadius.circular(kSmallPadding),
                onTap: () => showSnackBar(
                  context,
                  content: CopyClipboardContent(text: room.canonicalAlias),
                ),
                child: Text(
                  room.canonicalAlias,
                  style: textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.link,
                  ),
                  textAlign: TextAlign.center,
                ),
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
      titleTextStyle: textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w500,
      ),
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
              onPressed: !room.isArchived && room.canEditAtleastSomething
                  ? () => showDialog(
                      context: context,
                      builder: (context) => CreateOrEditRoomDialog(room: room),
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
    );
  }
}
