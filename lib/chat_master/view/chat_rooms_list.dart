import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../common/chat_model.dart';
import '../../common/rooms_filter.dart';
import 'active_space_info.dart';
import 'chat_room_master_tile.dart';
import 'chat_space_control_panel.dart';
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
    watchPropertyValue((ChatModel m) => m.filteredRoomsQuery);
    final roomsFilter = watchPropertyValue((ChatModel m) => m.roomsFilter);
    watchPropertyValue((ChatModel m) => m.archiveActive);
    final activeSpace = watchPropertyValue((ChatModel m) => m.activeSpace);

    return CustomScrollView(
      slivers: [
        if (activeSpace != null && roomsFilter == RoomsFilter.spaces) ...[
          const ActiveSpaceInfo(),
          const ChatSpaceControlPanel(),
          const ChatSpacesSearchList(),
        ],
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
