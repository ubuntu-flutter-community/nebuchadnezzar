import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:yaru/yaru.dart';

import '../../../common/view/build_context_x.dart';

class ChatRoomPinButton extends StatelessWidget {
  const ChatRoomPinButton({
    super.key,
    required this.room,
  });

  final Room room;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: ValueKey('${room.id}fav'),
      onPressed: () => room.setFavourite(!room.isFavourite),
      icon: Icon(
        YaruIcons.pin,
        color: room.isFavourite ? context.colorScheme.primary : null,
      ),
    );
  }
}
