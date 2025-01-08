import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../common/view/sliver_sticky_panel.dart';
import '../../../common/view/ui_constants.dart';
import '../../chat_model.dart';
import '../../search_model.dart';
import '../chat_avatar.dart';

class ChatSpaceFilter extends StatelessWidget with WatchItMixin {
  const ChatSpaceFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final chatModel = di<ChatModel>();
    final activeSpaceId = watchPropertyValue((ChatModel m) => m.activeSpace);

    final spaces = watchStream(
          (ChatModel m) => m.spacesStream,
          initialValue: chatModel.notArchivedSpaces,
        ).data ??
        [];

    return SliverStickyPanel(
      toolbarHeight: 56,
      child: SizedBox(
        height: 46,
        child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(
            width: kSmallPadding,
          ),
          scrollDirection: Axis.horizontal,
          itemCount: spaces.length,
          itemBuilder: (context, index) {
            final space = spaces.elementAt(index);
            return Tooltip(
              message: space.name,
              child: YaruSelectableContainer(
                onTap: () {
                  chatModel.setActiveSpace(space);
                  di<SearchModel>().resetSpaceSearch();
                },
                padding: EdgeInsets.zero,
                selected: activeSpaceId == space,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: ChatAvatar(
                    avatarUri: space.avatar,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
