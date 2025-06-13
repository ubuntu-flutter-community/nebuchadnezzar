import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../../l10n/l10n.dart';
import '../../chat_room/create_or_edit/chat_create_or_edit_room_dialog.dart';
import '../../chat_room/create_or_edit/chat_new_direct_chat_dialog.dart';

class ChatNewChatPopupMenuButton extends StatelessWidget {
  const ChatNewChatPopupMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopupMenuButton(
      tooltip: l10n.newChat,
      padding: EdgeInsets.zero,
      icon: const Icon(YaruIcons.plus),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            onTap: () => showDialog(
              context: context,
              builder: (context) => const ChatNewDirectChatDialog(),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(l10n.directChat), const Icon(YaruIcons.user)],
            ),
          ),
          PopupMenuItem(
            onTap: () => showDialog(
              context: context,
              builder: (context) => const ChatCreateOrEditRoomDialog(),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(l10n.newGroup), const Icon(YaruIcons.users)],
            ),
          ),
          PopupMenuItem(
            onTap: () => showDialog(
              context: context,
              builder: (context) =>
                  const ChatCreateOrEditRoomDialog(space: true),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(l10n.newSpace), const Icon(YaruIcons.globe)],
            ),
          ),
        ];
      },
    );
  }
}
