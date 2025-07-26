import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/search_model.dart';
import '../../common/view/search_auto_complete.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';

class ChatRoomsOrSpacesSearchDialog extends StatelessWidget with WatchItMixin {
  const ChatRoomsOrSpacesSearchDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final searchType = watchPropertyValue((SearchModel m) => m.searchType);

    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      title: const YaruDialogTitleBar(
        border: BorderSide.none,
        backgroundColor: Colors.transparent,
      ),
      content: Padding(
        padding: const EdgeInsets.only(
          left: kMediumPlusPadding,
          right: kMediumPlusPadding,
          bottom: kMediumPadding,
        ),
        child: ChatRoomsAndSpacesAutoComplete(
          suffix: IconButton(
            padding: EdgeInsets.zero,
            style: textFieldSuffixStyle,
            onPressed: () =>
                di<SearchModel>().setSearchType(switch (searchType) {
                  SearchType.rooms => SearchType.spaces,
                  _ => SearchType.rooms,
                }),
            icon: switch (searchType) {
              SearchType.rooms => const Icon(YaruIcons.users),
              _ => const Icon(YaruIcons.globe),
            },
          ),
        ),
      ),
    );
  }
}
