import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/snackbars.dart';
import '../../common/view/ui_constants.dart';
import 'chat_room_info_drawer_avatar.dart';

class ChatRoomInfoDrawerDirectChatHeader extends StatelessWidget {
  const ChatRoomInfoDrawerDirectChatHeader({
    super.key,
    required this.room,
  });

  final Room room;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return Padding(
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
    );
  }
}
