import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';
import 'package:yaru/yaru.dart';

import '../../common/chat_manager.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../create_or_edit/edit_room_manager.dart';

class ChatRoomInfoDrawerForgetButton extends StatelessWidget {
  const ChatRoomInfoDrawerForgetButton({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    return Container(
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
        onPressed: () {
          di<ChatManager>().setSelectedRoom(null);
          di<EditRoomManager>().globalForgetRoomCommand.run(room);
        },
        icon: Icon(
          YaruIcons.trash,
          color: room.isArchived ? theme.colorScheme.error : null,
        ),
      ),
    );
  }
}
