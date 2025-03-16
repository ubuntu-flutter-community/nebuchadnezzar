import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/chat_model.dart';
import '../../l10n/l10n.dart';

class ChatRoomPinButton extends StatelessWidget with WatchItMixin {
  const ChatRoomPinButton({
    super.key,
    required this.room,
  });

  final Room room;

  @override
  Widget build(BuildContext context) {
    final isFavourite = watchStream(
          (ChatModel m) =>
              m.getJoinedRoomUpdate(room.id).map((e) => room.isFavourite),
          initialValue: room.isFavourite,
        ).data ??
        false;

    return IconButton(
      tooltip: context.l10n.toggleFavorite,
      onPressed: () => room.setFavourite(!room.isFavourite),
      icon: Icon(
        YaruIcons.pin,
        color: isFavourite ? context.colorScheme.primary : null,
      ),
    );
  }
}
