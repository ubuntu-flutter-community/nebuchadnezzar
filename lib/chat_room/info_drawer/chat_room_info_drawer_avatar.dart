import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/chat_avatar.dart';
import '../../common/view/ui_constants.dart';
import '../create_or_edit/create_or_edit_room_model.dart';

class ChatRoomInfoDrawerAvatar extends StatelessWidget with WatchItMixin {
  const ChatRoomInfoDrawerAvatar({
    super.key,
    required this.room,
    this.dimension,
    this.fallBackIconSize,
  });

  final Room room;
  final double? dimension;
  final double? fallBackIconSize;

  @override
  Widget build(BuildContext context) {
    final avatar = watchStream(
      (CreateOrEditRoomModel m) => m.getJoinedRoomAvatarStream(room),
      initialValue: room.avatar,
    ).data;
    return ChatAvatar(
      avatarUri: avatar,
      fallBackIcon: YaruIcons.users,
      dimension: dimension ?? kAvatarDefaultSize,
      fallBackIconSize: fallBackIconSize,
    );
  }
}
