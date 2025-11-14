import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/chat_manager.dart';
import '../../common/search_manager.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';

class ChatSpaceDiscoverButton extends StatelessWidget with WatchItMixin {
  const ChatSpaceDiscoverButton({super.key});

  @override
  Widget build(BuildContext context) {
    final activeSpace = watchPropertyValue((ChatManager m) => m.activeSpace);
    final spaceSearch = watchPropertyValue((SearchManager m) => m.spaceSearch);
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
                  : () => di<SearchManager>().searchSpaces(
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
