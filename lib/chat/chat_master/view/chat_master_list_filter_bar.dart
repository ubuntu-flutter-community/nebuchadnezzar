import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../common/view/build_context_x.dart';
import '../../../common/view/ui_constants.dart';

import '../../common/chat_model.dart';
import '../../common/rooms_filter.dart';

class ChatMasterListFilterBar extends StatelessWidget with WatchItMixin {
  const ChatMasterListFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final roomsFilter = watchPropertyValue((ChatModel m) => m.roomsFilter);
    return Padding(
      padding: const EdgeInsets.only(
        left: kMediumPlusPadding,
        right: kMediumPlusPadding,
        bottom: kMediumPadding,
      ),
      child: YaruChoiceChipBar(
        showCheckMarks: false,
        shrinkWrap: false,
        style: YaruChoiceChipBarStyle.stack,
        labels: RoomsFilter.values
            .map((e) => Text(e.localize(context.l10n)))
            .toList(),
        isSelected: RoomsFilter.values.map((e) => e == roomsFilter).toList(),
        onSelected: (i) =>
            di<ChatModel>().setRoomsFilter(RoomsFilter.values[i]),
      ),
    );
  }
}
