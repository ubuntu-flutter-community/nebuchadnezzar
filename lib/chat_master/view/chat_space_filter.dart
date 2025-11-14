import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/chat_manager.dart';
import '../../common/search_manager.dart';
import '../../common/view/chat_avatar.dart';
import '../../common/view/ui_constants.dart';

class ChatSpaceFilter extends StatelessWidget with WatchItMixin {
  const ChatSpaceFilter({super.key, required this.show});

  final bool show;

  @override
  Widget build(BuildContext context) {
    const dimension = 40.0;
    final chatManager = di<ChatManager>();
    final activeSpace = watchPropertyValue((ChatManager m) => m.activeSpace);

    final spaces =
        watchStream(
          (ChatManager m) => m.spacesStream,
          initialValue: chatManager.spaces,
          preserveState: false,
        ).data ??
        chatManager.spaces;

    watchPropertyValue((ChatManager m) => m.selectedRoom);

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
                            chatManager.setActiveSpace(space);
                            di<SearchManager>().resetSpaceSearch();
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
