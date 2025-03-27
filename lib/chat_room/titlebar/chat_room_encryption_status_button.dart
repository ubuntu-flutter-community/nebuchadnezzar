import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/chat_model.dart';
import '../../common/view/build_context_x.dart';
import '../../l10n/l10n.dart';

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

    final encrypted = watchStream(
          (ChatModel m) => m.getJoinedRoomEncryptedStream(room),
          initialValue: room.encrypted,
        ).data ??
        room.encrypted;

    return IconButton(
      onPressed: null,
      tooltip: encrypted ? l10n.encrypted : l10n.encryptionNotEnabled,
      icon: Icon(
        getRoomIcon(encrypted, room),
        color: colorScheme.onSurface,
      ),
    );
  }

  IconData getRoomIcon(bool encrypted, Room room) =>
      switch ((encrypted, room.isDirectChat, room.canonicalAlias)) {
        (true, _, _) => YaruIcons.shield_filled,
        (false, false, String alias) when alias.contains(':ubuntu.com') =>
          YaruIcons.ubuntu_logo_simple,
        (false, false, String alias) when alias.contains(':gnome.org') =>
          YaruIcons.gnome_logo,
        (false, false, _) => YaruIcons.globe,
        (false, true, _) => YaruIcons.shield_warning,
      };
}
