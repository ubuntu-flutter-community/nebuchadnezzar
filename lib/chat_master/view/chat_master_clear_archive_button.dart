import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../chat_room/create_or_edit/edit_room_service.dart';
import '../../l10n/l10n.dart';

class ChatMasterClearArchiveButton extends StatelessWidget {
  const ChatMasterClearArchiveButton({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: context.l10n.clearArchive,
    onPressed: () => showFutureLoadingDialog(
      title: context.l10n.clearArchive,
      context: context,
      future: () => di<EditRoomService>().forgetAllArchivedRooms(),
    ),
    icon: const Icon(YaruIcons.edit_clear_all),
  );
}
