import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../chat_room/create_or_edit/create_or_edit_room_model.dart';
import '../../l10n/l10n.dart';

class ChatMasterClearArchiveButton extends StatelessWidget {
  const ChatMasterClearArchiveButton({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: context.l10n.clearArchive,
    onPressed: () => showFutureLoadingDialog(
      title: context.l10n.clearArchive,
      context: context,
      future: () => di<CreateOrEditRoomModel>().forgetAllArchivedRooms(),
    ),
    icon: const Icon(YaruIcons.edit_clear_all),
  );
}
