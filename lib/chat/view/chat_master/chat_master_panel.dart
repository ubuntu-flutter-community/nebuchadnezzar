import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../common/view/build_context_x.dart';
import '../../../common/view/common_widgets.dart';
import '../../../common/view/sliver_sticky_panel.dart';
import '../../../common/view/snackbars.dart';
import '../../../common/view/theme.dart';
import '../../../common/view/ui_constants.dart';
import '../../../l10n/l10n.dart';
import '../../chat_model.dart';
import '../../rooms_filter.dart';
import '../../search_model.dart';
import '../../settings/settings_dialog.dart';
import '../chat_avatar.dart';
import '../chat_room/chat_create_or_edit_room_dialog.dart';
import '../search_auto_complete.dart';
import 'chat_master_list_filter_bar.dart';
import 'chat_room_master_tile.dart';
import 'chat_space_filter.dart';

class ChatMasterSidePanel extends StatelessWidget with WatchItMixin {
  const ChatMasterSidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final chatModel = di<ChatModel>();

    final searchModel = di<SearchModel>();

    final searchActive = watchPropertyValue((SearchModel m) => m.searchActive);
    final searchType = watchPropertyValue((SearchModel m) => m.searchType);
    final archiveActive = watchPropertyValue((ChatModel m) => m.archiveActive);
    final loadingArchive =
        watchPropertyValue((ChatModel m) => m.loadingArchive);

    final suffix = IconButton(
      padding: EdgeInsets.zero,
      style: IconButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(6),
            bottomRight: Radius.circular(6),
          ),
        ),
      ),
      onPressed: () => searchModel.setSearchType(
        switch (searchType) {
          SearchType.profiles => SearchType.rooms,
          SearchType.rooms => SearchType.spaces,
          SearchType.spaces => SearchType.profiles,
        },
      ),
      icon: switch (searchType) {
        SearchType.profiles => const Icon(YaruIcons.user),
        SearchType.rooms => const Icon(YaruIcons.users),
        SearchType.spaces => const Icon(YaruIcons.globe)
      },
    );

    final panelBg = getPanelBg(context.theme);
    return Material(
      color: panelBg,
      child: Column(
        children: [
          YaruWindowTitleBar(
            heroTag: '<Left hero tag>',
            title: Text(archiveActive ? l10n.archive : l10n.chats),
            border: BorderSide.none,
            style: YaruTitleBarStyle.undecorated,
            backgroundColor:
                getMonochromeBg(theme: context.theme, darkFactor: 3),
            actions: [
              Flexible(
                child: IconButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => const ChatCreateOrEditRoomDialog(),
                  ),
                  icon: const Icon(
                    YaruIcons.plus,
                  ),
                ),
              ),
              if (!archiveActive)
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: IconButton(
                      isSelected: searchActive,
                      onPressed: searchModel.toggleSearch,
                      icon: const Icon(YaruIcons.search),
                    ),
                  ),
                ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: IconButton(
                    selectedIcon: const Icon(YaruIcons.bookmark_filled),
                    isSelected: archiveActive,
                    onPressed: chatModel.toggleArchive,
                    icon: const Icon(YaruIcons.bookmark),
                  ),
                ),
              ),
            ],
          ),
          if (searchActive && !archiveActive)
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                bottom: kMediumPadding,
              ),
              child: switch (searchType) {
                SearchType.profiles => SearchAutoComplete(
                    suffix: suffix,
                  ),
                _ => RoomsAutoComplete(
                    suffix: suffix,
                  )
              },
            ),
          if (loadingArchive)
            const Expanded(
              child: Center(child: Progress()),
            )
          else
            const Expanded(
              child: _RoomList(),
            ),
          Padding(
            padding: const EdgeInsets.only(top: kMediumPadding),
            child: YaruMasterTile(
              leading: const Icon(YaruIcons.settings),
              title: Text(l10n.settings),
              onTap: () => showDialog(
                context: context,
                builder: (context) => const SettingsDialog(),
              ),
            ),
          ),
          const SizedBox(
            height: kMediumPadding,
          ),
        ],
      ),
    );
  }
}

class _RoomList extends StatelessWidget with WatchItMixin {
  const _RoomList();

  @override
  Widget build(BuildContext context) {
    final selectedRoom = watchPropertyValue((ChatModel m) => m.selectedRoom);
    final archiveActive = watchPropertyValue((ChatModel m) => m.archiveActive);
    final roomsFilter = watchPropertyValue((ChatModel m) => m.roomsFilter);
    watchPropertyValue((ChatModel m) => m.filteredRooms.length);
    final activeSpace = watchPropertyValue((ChatModel m) => m.activeSpace);
    final spaceSearch = watchPropertyValue((SearchModel m) => m.spaceSearch);
    final spaceSearchVisible =
        watchPropertyValue((SearchModel m) => m.spaceSearchVisible);

    return StreamBuilder(
      stream: di<ChatModel>().syncStream,
      builder: (context, snapshot) {
        final filteredRooms = di<ChatModel>().filteredRooms;

        return CustomScrollView(
          slivers: [
            const ChatMasterListFilterBar(),
            if (roomsFilter == RoomsFilter.spaces && !archiveActive)
              const ChatSpaceFilter(),
            if (roomsFilter == RoomsFilter.spaces &&
                activeSpace != null &&
                !archiveActive)
              SliverStickyPanel(
                toolbarHeight: 50,
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: kMediumPadding,
                    top: kMediumPadding,
                  ),
                  child: Row(
                    spacing: kMediumPadding,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: spaceSearch == null
                              ? null
                              : () => di<SearchModel>().searchSpaces(
                                    activeSpace,
                                    onFail: (e) =>
                                        showSnackBar(context, content: Text(e)),
                                  ),
                          child: Text(context.l10n.discover),
                        ),
                      ),
                      SizedBox.square(
                        dimension: 38,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () => di<ChatModel>().leaveSelectedRoom(
                            room: activeSpace,
                            onFail: (e) =>
                                showSnackBar(context, content: Text(e)),
                          ),
                          child: const Icon(
                            YaruIcons.log_out,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (spaceSearchVisible &&
                !archiveActive &&
                roomsFilter == RoomsFilter.spaces)
              const _SpaceSearchList(),
            if (roomsFilter == RoomsFilter.spaces && !archiveActive)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: kSmallPadding,
                    bottom: kMediumPadding,
                  ),
                  child: Divider(),
                ),
              ),
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

class _SpaceSearchList extends StatelessWidget with WatchItMixin {
  const _SpaceSearchList();

  @override
  Widget build(BuildContext context) {
    final spaceSearch = watchPropertyValue((SearchModel m) => m.spaceSearch);
    final spaceSearchL =
        watchPropertyValue((SearchModel m) => m.spaceSearch?.length ?? 0);
    if (spaceSearch == null) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(kBigPadding),
          child: Progress(),
        ),
      );
    }

    if (spaceSearch.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverList.builder(
      itemCount: spaceSearchL,
      itemBuilder: (context, index) {
        final chunk = spaceSearch.elementAt(index);
        return Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: YaruMasterTile(
            key: ValueKey(chunk.roomId),
            leading: ChatAvatar(
              avatarUri: chunk.avatarUrl,
            ),
            title: Text(chunk.name ?? chunk.roomId),
            subtitle: Tooltip(
              margin: const EdgeInsets.all(kBigPadding),
              message: chunk.topic ?? ' ',
              child: Text(chunk.canonicalAlias ?? chunk.topic.toString()),
            ),
            onTap: () {
              di<SearchModel>().setSpaceSearchVisible(value: false);
              di<ChatModel>().joinAndSelectRoomByChunk(
                chunk,
                onFail: (error) => showSnackBar(context, content: Text(error)),
              );
            },
          ),
        );
      },
    );
  }
}
