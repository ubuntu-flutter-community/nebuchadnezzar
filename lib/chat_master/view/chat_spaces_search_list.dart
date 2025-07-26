import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../chat_room/create_or_edit/create_or_edit_room_model.dart';
import '../../common/chat_model.dart';
import '../../common/rooms_filter.dart';
import '../../common/search_model.dart';
import '../../common/view/chat_avatar.dart';
import '../../common/view/common_widgets.dart';
import '../../common/view/confirm.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';

class ChatSpacesSearchList extends StatelessWidget with WatchItMixin {
  const ChatSpacesSearchList({super.key});

  @override
  Widget build(BuildContext context) {
    final archiveActive = watchPropertyValue((ChatModel m) => m.archiveActive);
    final roomsFilter = watchPropertyValue((ChatModel m) => m.roomsFilter);
    final spaceSearchVisible = watchPropertyValue(
      (SearchModel m) => m.spaceSearchVisible,
    );
    final spaceSearch = watchPropertyValue((SearchModel m) => m.spaceSearch);
    final spaceSearchL = watchPropertyValue(
      (SearchModel m) => m.spaceSearch?.length ?? 0,
    );
    if (spaceSearch == null) {
      return const SliverToBoxAdapter(
        child: Padding(padding: EdgeInsets.all(kBigPadding), child: Progress()),
      );
    }

    if (!spaceSearchVisible ||
        archiveActive ||
        roomsFilter != RoomsFilter.spaces ||
        spaceSearchL == 0) {
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
            leading: ChatAvatar(avatarUri: chunk.avatarUrl),
            title: Text(chunk.name ?? chunk.roomId),
            subtitle: Tooltip(
              margin: const EdgeInsets.all(kBigPadding),
              message: chunk.topic ?? ' ',
              child: Text(chunk.canonicalAlias ?? chunk.topic.toString()),
            ),
            onTap: () => ConfirmationDialog.show(
              title: Text(context.l10n.joinRoom),
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
              onConfirm: () {
                Navigator.of(context).pop();
                showFutureLoadingDialog(
                  context: context,
                  future: () =>
                      di<CreateOrEditRoomModel>().knockOrJoinRoomChunk(chunk),
                ).then((result) {
                  if (result.asValue?.value != null) {
                    di<ChatModel>().setSelectedRoom(result.asValue!.value!);
                  }
                });
              },
            ),
          ),
        );
      },
    );
  }
}
