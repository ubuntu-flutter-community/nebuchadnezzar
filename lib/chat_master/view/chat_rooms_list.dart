import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../common/chat_model.dart';
import 'chat_room_master_tile.dart';
import 'chat_spaces_search_list.dart';

class ChatRoomsList extends StatelessWidget with WatchItMixin {
  const ChatRoomsList({super.key});

  @override
  Widget build(BuildContext context) {
    final filteredRooms =
        watchStream(
          (ChatModel m) => m.syncStream.map((_) => m.filteredRooms),
          initialValue: di<ChatModel>().filteredRooms,
          preserveState: false,
        ).data ??
        di<ChatModel>().filteredRooms;
    watchPropertyValue((ChatModel m) => m.roomsFilter);

    return CustomScrollView(
      slivers: [
        const ChatSpacesSearchList(),
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
