import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';
import '../../../../common/view/build_context_x.dart';
import '../../../../l10n/l10n.dart';
import '../../../chat_model.dart';

class ChatRoomEncryptionStatusButton extends StatelessWidget with WatchItMixin {
  const ChatRoomEncryptionStatusButton({
    super.key,
    required this.room,
  });

  final Room room;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    watchStream((ChatModel m) => m.getJoinedRoomUpdate(room.id)).data;
    return IconButton(
      onPressed: null,
      tooltip: room.encrypted ? l10n.encrypted : l10n.encryptionNotEnabled,
      icon: !room.encrypted
          ? Icon(YaruIcons.shield_warning, color: colorScheme.onSurface)
          : Icon(YaruIcons.shield_filled, color: colorScheme.onSurface),
    );
  }
}
