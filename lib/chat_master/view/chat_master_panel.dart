import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/chat_model.dart';
import '../../common/rooms_filter.dart';
import '../../common/search_model.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/common_widgets.dart';
import '../../common/view/search_auto_complete.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../../settings/view/chat_my_user_avatar.dart';
import '../../settings/view/settings_dialog.dart';
import 'chat_master_list_filter_bar.dart';
import 'chat_master_title_bar.dart';
import 'chat_rooms_list.dart';
import 'chat_space_control_panel.dart';
import 'chat_space_filter.dart';

class ChatMasterSidePanel extends StatelessWidget with WatchItMixin {
  const ChatMasterSidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final searchModel = di<SearchModel>();
    final searchActive = watchPropertyValue((SearchModel m) => m.searchActive);
    final searchType = watchPropertyValue((SearchModel m) => m.searchType);
    final archiveActive = watchPropertyValue((ChatModel m) => m.archiveActive);
    final loadingArchive =
        watchPropertyValue((ChatModel m) => m.loadingArchive);
    final roomsFilter = watchPropertyValue((ChatModel m) => m.roomsFilter);

    final suffix = IconButton(
      padding: EdgeInsets.zero,
      style: textFieldSuffixStyle,
      onPressed: () => searchModel.setSearchType(
        switch (searchType) {
          SearchType.profiles => SearchType.rooms,
          SearchType.rooms => SearchType.spaces,
          SearchType.spaces => SearchType.profiles,
        },
      ),
      icon: switch (searchType) {
        SearchType.profiles => const Icon(YaruIcons.user),
        SearchType.rooms => const Icon(YaruIcons.users),
        SearchType.spaces => const Icon(YaruIcons.globe)
      },
    );

    return Material(
      color: getPanelBg(context.theme),
      child: Column(
        children: [
          const ChatMasterTitleBar(),
          if (searchActive && !archiveActive)
            Padding(
              padding: const EdgeInsets.only(
                left: kMediumPlusPadding,
                right: kMediumPlusPadding,
                bottom: kMediumPadding,
              ),
              child: switch (searchType) {
                SearchType.profiles => ChatUserSearchAutoComplete(
                    suffix: suffix,
                  ),
                _ => RoomsAutoComplete(
                    suffix: suffix,
                  )
              },
            ),
          const ChatMasterListFilterBar(),
          if (roomsFilter == RoomsFilter.spaces && !archiveActive)
            const ChatSpaceFilter(),
          if (roomsFilter == RoomsFilter.spaces && !archiveActive)
            const ChatSpaceControlPanel(),
          if (loadingArchive)
            const Expanded(
              child: Center(child: Progress()),
            )
          else
            const Expanded(
              child: ChatRoomsList(),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kMediumPadding),
            child: YaruMasterTile(
              leading: const ChatMyUserAvatar(
                dimension: 25,
                showEditButton: false,
              ),
              title: Text(l10n.settings),
              onTap: () => showDialog(
                context: context,
                builder: (context) => const SettingsDialog(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
