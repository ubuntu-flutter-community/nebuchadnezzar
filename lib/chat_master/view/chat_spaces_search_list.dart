import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../chat_room/create_or_edit/edit_room_service.dart';
import '../../common/chat_manager.dart';
import '../../common/rooms_filter.dart';
import '../../common/search_manager.dart';
import '../../common/view/chat_avatar.dart';
import '../../common/view/common_widgets.dart';
import '../../common/view/confirm.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';

class ChatSpacesSearchList extends StatelessWidget with WatchItMixin {
  const ChatSpacesSearchList({super.key});

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
      return const Center(
        child: Padding(padding: EdgeInsets.all(kBigPadding), child: Progress()),
      );
    }

    if (archiveActive ||
        roomsFilter != RoomsFilter.spaces ||
        spaceSearchL == 0) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      itemCount: spaceSearchL,
      itemBuilder: (context, index) {
        final chunk = spaceSearch.elementAt(index);
        return Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: YaruMasterTile(
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
                    child: Text(
                      chunk.canonicalAlias ?? chunk.name ?? chunk.roomId,
                    ),
                  ),
                ],
              ),
              context: context,
              onConfirm: () async {
                final maybe = await di<EditRoomService>().knockOrJoinRoomChunk(
                  chunk,
                );
                if (maybe != null) {
                  di<ChatManager>().setSelectedRoom(maybe);
                  if (maybe.isSpace) {
                    di<ChatManager>().setActiveSpace(maybe);
                  }
                }
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
        );
      },
    );
  }
}
