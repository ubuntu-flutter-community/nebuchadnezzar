import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';

import '../../common/chat_manager.dart';
import 'chat_room_master_tile.dart';

class ChatRoomsList extends StatelessWidget with WatchItMixin {
  const ChatRoomsList({super.key});

  @override
  Widget build(BuildContext context) {
    final filteredRooms =
        watchStream(
          (ChatManager m) => m.filteredRoomsStream,
          initialValue: di<ChatManager>().filteredRooms,
          allowStreamChange: true,
          preserveState: false,
        ).data ??
        di<ChatManager>().filteredRooms;

    watchPropertyValue((ChatManager m) => m.filteredRoomsQuery);
    watchPropertyValue((ChatManager m) => m.roomsFilter);
    watchPropertyValue((ChatManager m) => m.archiveActive);
    watchPropertyValue((ChatManager m) => m.activeSpace);

    return CustomScrollView(
      slivers: [
        SliverList.builder(
          itemCount: filteredRooms.length,
          itemBuilder: (context, i) {
            final room = filteredRooms[i];
            return ChatRoomMasterTile(key: ValueKey(room.id), room: room);
          },
        ),
      ],
    );
  }
}
