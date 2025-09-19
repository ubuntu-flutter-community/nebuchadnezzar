import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/chat_model.dart';
import '../../common/search_model.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';

class ChatSpaceDiscoverButton extends StatelessWidget with WatchItMixin {
  const ChatSpaceDiscoverButton({super.key});

  @override
  Widget build(BuildContext context) {
    final activeSpace = watchPropertyValue((ChatModel m) => m.activeSpace);
    final spaceSearch = watchPropertyValue((SearchModel m) => m.spaceSearch);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kBigPadding + kSmallPadding,
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              label: Text(context.l10n.discover),
              onPressed: spaceSearch == null || activeSpace == null
                  ? null
                  : () => di<SearchModel>().searchSpaces(
                      activeSpace,
                      onFail: (error) {},
                    ),
              icon: const Icon(YaruIcons.compass),
            ),
          ),
        ],
      ),
    );
  }
}
