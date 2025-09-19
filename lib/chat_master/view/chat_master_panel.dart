import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/chat_model.dart';
import '../../common/rooms_filter.dart';
import '../../common/search_model.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../../settings/view/chat_settings_dialog.dart';
import 'chat_master_list_filter_bar.dart';
import 'chat_master_settings_tile_avatar.dart';
import 'chat_master_title_bar.dart';
import 'chat_rooms_list.dart';
import 'chat_rooms_search_field.dart';
import 'chat_space_filter.dart';

class ChatMasterSidePanel extends StatelessWidget with WatchItMixin {
  const ChatMasterSidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final searchActive = watchPropertyValue((SearchModel m) => m.searchActive);

    return Material(
      color: getPanelBg(context.theme),
      child: Column(
        children: [
          const ChatMasterTitleBar(),
          if (searchActive) const ChatRoomsSearchField(),
          const ChatMasterListFilterBar(),
          Expanded(
            child: Row(
              children: [
                ChatSpaceFilter(
                  show: watchPropertyValue(
                    (ChatModel m) => m.roomsFilter == RoomsFilter.spaces,
                  ),
                ),
                const Expanded(child: ChatRoomsList()),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kMediumPadding),
            child: Stack(
              alignment: Alignment.center,
              children: [
                YaruMasterTile(
                  leading: const ChatMasterSettingsTileAvatar(),
                  title: Text(l10n.settings),
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => const ChatSettingsDialog(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
