import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/chat_manager.dart';
import '../../common/search_manager.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/space.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import 'chat_master_clear_archive_button.dart';
import 'chat_master_new_chat_popup_menu_button.dart';

class ChatMasterTitleBar extends StatelessWidget with WatchItMixin {
  const ChatMasterTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final searchManager = di<SearchManager>();
    final searchActive = watchPropertyValue(
      (SearchManager m) => m.searchActive,
    );
    final archiveActive = watchPropertyValue(
      (ChatManager m) => m.archiveActive,
    );

    final loadingArchive = watchValue(
      (ChatManager m) => m.toggleArchiveCommand.isRunning,
    );

    return YaruWindowTitleBar(
      heroTag: '<Left hero tag>',
      title: Text(archiveActive ? l10n.archive : l10n.chats),
      border: BorderSide.none,
      style: YaruTitleBarStyle.undecorated,
      backgroundColor: getMonochromeBg(theme: context.theme, darkFactor: 3),
      actions: space(
        flex: true,
        spaceEnd: true,
        widthGap: kSmallPadding,
        skip: 0,
        children: [
          if (!archiveActive)
            const ChatMasterNewChatPopupMenuButton()
          else
            const ChatMasterClearArchiveButton(),
          IconButton(
            tooltip: context.l10n.search,
            isSelected: searchActive,
            onPressed: searchManager.toggleSearch,
            icon: const Icon(YaruIcons.search),
          ),
          IconButton(
            tooltip: context.l10n.archive,
            selectedIcon: const Icon(YaruIcons.trash_filled),
            isSelected: watchPropertyValue((ChatManager m) => m.archiveActive),
            onPressed: loadingArchive
                ? null
                : () => di<ChatManager>().toggleArchiveCommand.run(),
            icon: const Icon(YaruIcons.trash),
          ),
        ],
      ),
    );
  }
}
