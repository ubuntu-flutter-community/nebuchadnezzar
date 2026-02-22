import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';

import '../../common/chat_manager.dart';
import '../../common/rooms_filter.dart';
import '../../common/view/sliver_sticky_panel.dart';
import '../../common/view/ui_constants.dart';
import 'chat_room_master_tile.dart';
import 'chat_space_discover_button.dart';
import 'chat_spaces_search_list.dart';

class ChatRoomsList extends StatelessWidget with WatchItMixin {
  const ChatRoomsList({super.key});

  @override
  Widget build(BuildContext context) {
    final loadingArchive = watchValue(
      (ChatManager m) => m.toggleArchiveCommand.isRunning,
    );

    if (loadingArchive) {
      return const SizedBox.shrink();
    }

    final filteredRooms =
        watchStream(
          (ChatManager m) => m.filteredRoomsStream,
          initialValue: di<ChatManager>().filteredRooms,
          allowStreamChange: true,
          preserveState: false,
        ).data ??
        di<ChatManager>().filteredRooms;

    watchPropertyValue((ChatManager m) => m.filteredRoomsQuery);
    final roomsFilter = watchPropertyValue((ChatManager m) => m.roomsFilter);
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
        if (roomsFilter == RoomsFilter.spaces && filteredRooms.isNotEmpty)
          const SliverPadding(
            padding: EdgeInsets.symmetric(vertical: kMediumPadding),
            sliver: SliverToBoxAdapter(
              child: Divider(
                endIndent: kMediumPlusPadding,
                indent: kMediumPlusPadding,
              ),
            ),
          ),
        if (roomsFilter == RoomsFilter.spaces)
          const SliverStickyPanel(
            padding: EdgeInsets.only(bottom: kBigPadding, top: kMediumPadding),
            child: ChatSpaceDiscoverButton(),
          ),
        const SliverPadding(
          padding: EdgeInsets.only(top: kSmallPadding),
          sliver: ChatSpacesSearchList.sliver(),
        ),
      ],
    );
  }
}
