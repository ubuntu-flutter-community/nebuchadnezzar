import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/common_widgets.dart';
import '../../common/view/snackbars.dart';
import '../../common/view/ui_constants.dart';
import '../../common/chat_model.dart';
import '../../common/search_model.dart';
import '../../common/view/chat_avatar.dart';

class ChatSpacesSearchList extends StatelessWidget with WatchItMixin {
  const ChatSpacesSearchList({super.key});

  @override
  Widget build(BuildContext context) {
    final spaceSearch = watchPropertyValue((SearchModel m) => m.spaceSearch);
    final spaceSearchL = watchPropertyValue(
      (SearchModel m) => m.spaceSearch?.length ?? 0,
    );
    if (spaceSearch == null) {
      return const SliverToBoxAdapter(
        child: Padding(padding: EdgeInsets.all(kBigPadding), child: Progress()),
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
            leading: ChatAvatar(avatarUri: chunk.avatarUrl),
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
