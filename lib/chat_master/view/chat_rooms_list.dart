import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../common/chat_model.dart';
import '../../common/rooms_filter.dart';
import '../../common/search_model.dart';
import 'chat_room_master_tile.dart';
import 'chat_spaces_search_list.dart';

class ChatRoomsList extends StatelessWidget with WatchItMixin {
  const ChatRoomsList({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedRoom = watchPropertyValue((ChatModel m) => m.selectedRoom);
    final archiveActive = watchPropertyValue((ChatModel m) => m.archiveActive);
    final roomsFilter = watchPropertyValue((ChatModel m) => m.roomsFilter);
    watchPropertyValue((ChatModel m) => m.filteredRooms.length);
    final spaceSearchVisible =
        watchPropertyValue((SearchModel m) => m.spaceSearchVisible);

    return StreamBuilder(
      stream: di<ChatModel>().syncStream,
      builder: (context, snapshot) {
        final filteredRooms = di<ChatModel>().filteredRooms;

        return CustomScrollView(
          slivers: [
            if (spaceSearchVisible &&
                !archiveActive &&
                roomsFilter == RoomsFilter.spaces)
              const ChatSpacesSearchList(),
            SliverList.builder(
              itemCount: filteredRooms.length,
              itemBuilder: (context, i) {
                final room = filteredRooms[i];

                return ChatRoomMasterTile(
                  key: ValueKey(room.id),
                  selected: selectedRoom?.id == room.id,
                  room: room,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
