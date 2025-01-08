import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';
import '../../../../common/view/build_context_x.dart';
import '../../../chat_model.dart';

class ChatRoomPinButton extends StatelessWidget with WatchItMixin {
  const ChatRoomPinButton({
    super.key,
    required this.room,
  });

  final Room room;

  @override
  Widget build(BuildContext context) {
    watchStream((ChatModel m) => m.getJoinedRoomUpdate(room.id)).data;

    return IconButton(
      onPressed: () => room.setFavourite(!room.isFavourite),
      icon: Icon(
        YaruIcons.pin,
        color: room.isFavourite ? context.colorScheme.primary : null,
      ),
    );
  }
}
