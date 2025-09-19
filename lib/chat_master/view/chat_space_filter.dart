import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/chat_model.dart';
import '../../common/search_model.dart';
import '../../common/view/chat_avatar.dart';
import '../../common/view/ui_constants.dart';

class ChatSpaceFilter extends StatelessWidget with WatchItMixin {
  const ChatSpaceFilter({super.key, required this.show});

  final bool show;

  @override
  Widget build(BuildContext context) {
    const dimension = 40.0;
    final chatModel = di<ChatModel>();
    final activeSpace = watchPropertyValue((ChatModel m) => m.activeSpace);

    final spaces =
        watchStream(
          (ChatModel m) => m.spacesStream,
          initialValue: chatModel.spaces,
          preserveState: false,
        ).data ??
        chatModel.spaces;

    watchPropertyValue((ChatModel m) => m.selectedRoom);

    return AnimatedContainer(
      alignment: Alignment.center,
      width: show ? dimension + kMediumPlusPadding : 0,
      duration: const Duration(milliseconds: 200),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2, left: kMediumPlusPadding),
              child: SizedBox(
                width: dimension,
                child: ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: kSmallPadding),
                  itemCount: spaces.length,
                  itemBuilder: (context, index) {
                    final space = spaces.elementAt(index);
                    return Tooltip(
                      message: space.name,
                      child: SizedBox.square(
                        dimension: dimension,
                        child: YaruSelectableContainer(
                          key: ValueKey('${space.id}_space'),
                          onTap: () {
                            chatModel.setActiveSpace(space);
                            di<SearchModel>().resetSpaceSearch();
                          },
                          padding: EdgeInsets.zero,
                          selected: activeSpace == space,
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: ChatAvatar(
                              avatarUri: space.avatar,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
