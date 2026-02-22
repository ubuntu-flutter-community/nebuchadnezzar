import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix_api_lite/generated/model.dart';
import 'package:yaru/yaru.dart';

import '../../chat_room/create_or_edit/edit_room_manager.dart';
import '../../common/chat_manager.dart';
import '../../common/rooms_filter.dart';
import '../../common/search_manager.dart';
import '../../common/view/chat_avatar.dart';
import '../../common/view/common_widgets.dart';
import '../../common/view/confirm.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';

enum ChatSpacesSearchType { regular, sliver }

class ChatSpacesSearchList extends StatelessWidget with WatchItMixin {
  const ChatSpacesSearchList({super.key})
    : _type = ChatSpacesSearchType.regular;

  const ChatSpacesSearchList.sliver({super.key})
    : _type = ChatSpacesSearchType.sliver;

  final ChatSpacesSearchType _type;

  @override
  Widget build(BuildContext context) {
    final archiveActive = watchPropertyValue(
      (ChatManager m) => m.archiveActive,
    );
    final roomsFilter = watchPropertyValue((ChatManager m) => m.roomsFilter);

    final spaceSearch = watchPropertyValue((SearchManager m) => m.spaceSearch);
    final spaceSearchL = watchPropertyValue(
      (SearchManager m) => m.spaceSearch?.length ?? 0,
    );
    if (spaceSearch == null) {
      return _type == ChatSpacesSearchType.sliver
          ? const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(kBigPadding),
                  child: Progress(),
                ),
              ),
            )
          : const Center(
              child: Padding(
                padding: EdgeInsets.all(kBigPadding),
                child: Progress(),
              ),
            );
    }

    if (archiveActive ||
        roomsFilter != RoomsFilter.spaces ||
        spaceSearchL == 0) {
      return _type == ChatSpacesSearchType.sliver
          ? const SliverToBoxAdapter(child: SizedBox.shrink())
          : const SizedBox.shrink();
    }

    if (_type == ChatSpacesSearchType.sliver) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _itemBuilder(context, index, spaceSearch),
          childCount: spaceSearchL,
        ),
      );
    }

    return ListView.builder(
      itemCount: spaceSearchL,
      itemBuilder: (context, index) =>
          _itemBuilder(context, index, spaceSearch),
    );
  }

  Widget? _itemBuilder(
    BuildContext context,
    int index,
    List<PublishedRoomsChunk>? spaceSearch,
  ) {
    final chunk = spaceSearch?.elementAtOrNull(index);
    if (chunk == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: ChatSpacesDiscoverTile(chunk: chunk),
    );
  }
}

class ChatSpacesDiscoverTile extends StatelessWidget {
  const ChatSpacesDiscoverTile({super.key, required this.chunk});

  final PublishedRoomsChunk chunk;

  @override
  Widget build(BuildContext context) {
    return YaruMasterTile(
      key: ValueKey(chunk.roomId),
      leading: ChatAvatar(avatarUri: chunk.avatarUrl),
      title: Text(
        '${chunk.roomType == 'm.space' ? '(${context.l10n.space}) ' : ''}'
        '${chunk.name ?? chunk.canonicalAlias ?? ''}',
      ),
      subtitle: Tooltip(
        margin: const EdgeInsets.all(kBigPadding),
        message: chunk.topic ?? ' ',
        child: Text(chunk.canonicalAlias ?? chunk.topic ?? ''),
      ),
      onTap: () => ConfirmationDialog.show(
        title: Text(
          chunk.joinRule == 'knock'
              ? context.l10n.knock
              : context.l10n.joinRoom,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: kMediumPadding,
          children: [
            ChatAvatar(avatarUri: chunk.avatarUrl),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(chunk.canonicalAlias ?? chunk.name ?? chunk.roomId),
            ),
          ],
        ),
        context: context,
        onConfirm: () async {
          Navigator.of(context).pop();
          di<EditRoomManager>().knockOrJoinCommand.run((
            roomId: chunk.roomId,
            knock: chunk.joinRule == 'knock',
          ));
        },
      ),
    );
  }
}
