import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';

import '../../chat_room/create_or_edit/edit_room_manager.dart';
import '../../common/view/common_widgets.dart';
import '../../common/view/ui_constants.dart';

class ChatRoomMasterTileMarkRoomCheckBox extends StatelessWidget
    with WatchItMixin {
  const ChatRoomMasterTileMarkRoomCheckBox({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    final isMarked = watchValue(
      (EditRoomManager m) => m.markedRooms.select((r) => r.contains(room)),
    );

    return SizedBox.square(
      dimension: kAvatarDefaultSize,
      child: Center(
        child: CommonCheckBox(
          value: isMarked,
          onChanged: (_) => di<EditRoomManager>().toggleMarkedRoom(room),
        ),
      ),
    );
  }
}
