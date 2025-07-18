import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/chat_model.dart';
import '../../l10n/l10n.dart';

class ChatRoomPinButton extends StatelessWidget with WatchItMixin {
  const ChatRoomPinButton({super.key, required this.room, this.small = false})
    : _type = _ChatRoomPinButtonType.iconButton;

  const ChatRoomPinButton.menuEntry({
    super.key,
    required this.room,
    this.small = false,
  }) : _type = _ChatRoomPinButtonType.menuEntry;

  final Room room;
  final bool small;
  final _ChatRoomPinButtonType _type;

  @override
  Widget build(BuildContext context) {
    final isFavourite =
        watchStream(
          (ChatModel m) =>
              m.getJoinedRoomUpdate(room.id).map((e) => room.isFavourite),
          initialValue: room.isFavourite,
        ).data ??
        false;

    void onPressed() => room.setFavourite(!room.isFavourite);

    var icon = Icon(
      YaruIcons.pin,
      color: isFavourite ? context.colorScheme.primary : null,
      size: small ? 15 : null,
    );

    if (_type == _ChatRoomPinButtonType.menuEntry) {
      return MenuItemButton(
        onPressed: onPressed,
        trailingIcon: icon,

        child: Text(
          context.l10n.toggleFavorite,
          style: context.textTheme.bodyMedium,
        ),
      );
    }

    return IconButton(
      constraints: small
          ? const BoxConstraints(maxHeight: 20, maxWidth: 20)
          : null,
      padding: small ? EdgeInsets.zero : null,
      tooltip: context.l10n.toggleFavorite,
      onPressed: onPressed,
      icon: icon,
    );
  }
}

enum _ChatRoomPinButtonType { iconButton, menuEntry }
