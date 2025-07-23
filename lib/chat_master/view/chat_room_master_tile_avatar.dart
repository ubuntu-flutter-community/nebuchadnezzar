import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/chat_model.dart';
import '../../common/push_rule_state_x.dart';
import '../../common/view/chat_avatar.dart';

class ChatRoomMasterTileAvatar extends StatelessWidget with WatchItMixin {
  const ChatRoomMasterTileAvatar({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    final pushRuleState =
        watchStream(
          (ChatModel m) => m.syncStream.map((_) => room.pushRuleState),
          initialValue: room.pushRuleState,
        ).data ??
        room.pushRuleState;
    return ChatAvatar(
      avatarUri: pushRuleState == PushRuleState.dontNotify ? null : room.avatar,
      fallBackIcon: room.membership != Membership.invite
          ? pushRuleState == PushRuleState.dontNotify
                ? pushRuleState.getIconData()
                : room.isDirectChat
                ? YaruIcons.user
                : YaruIcons.users
          : YaruIcons.mail_unread,
    );
  }
}
