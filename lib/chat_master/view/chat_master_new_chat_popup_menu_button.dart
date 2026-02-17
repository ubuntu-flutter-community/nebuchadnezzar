import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../../chat_room/create_or_edit/view/create_direct_chat_dialog.dart';
import '../../chat_room/create_or_edit/view/create_or_edit_room_dialog.dart';
import '../../l10n/l10n.dart';
import 'chat_rooms_or_spaces_search_dialog.dart';

class ChatMasterNewChatPopupMenuButton extends StatelessWidget {
  const ChatMasterNewChatPopupMenuButton({super.key});

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
              builder: (context) => const CreateDirectChatDialog(),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(l10n.directChat), const Icon(YaruIcons.user)],
            ),
          ),
          PopupMenuItem(
            onTap: () => showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const CreateOrEditRoomDialog(),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(l10n.newGroup), const Icon(YaruIcons.users)],
            ),
          ),
          PopupMenuItem(
            onTap: () => showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const CreateOrEditRoomDialog(space: true),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(l10n.newSpace), const Icon(YaruIcons.globe)],
            ),
          ),
          PopupMenuItem(
            onTap: () => showDialog(
              context: context,
              builder: (context) => const ChatRoomsOrSpacesSearchDialog(),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${l10n.search} ${l10n.publicRooms}'),
                const Icon(YaruIcons.search),
              ],
            ),
          ),
        ];
      },
    );
  }
}
