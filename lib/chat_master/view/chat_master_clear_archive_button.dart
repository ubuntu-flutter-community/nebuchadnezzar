import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../chat_room/create_or_edit/edit_room_manager.dart';
import '../../common/chat_manager.dart';
import '../../l10n/l10n.dart';

class ChatMasterClearArchiveButton extends StatelessWidget {
  const ChatMasterClearArchiveButton({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: context.l10n.clearArchive,
    onPressed: () {
      di<ChatManager>().setSelectedRoom(null);
      di<EditRoomManager>().forgetAllRoomsCommand.run();
    },
    icon: const Icon(YaruIcons.edit_clear_all),
  );
}
