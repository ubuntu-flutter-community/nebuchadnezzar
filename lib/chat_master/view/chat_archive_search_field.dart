import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/chat_model.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';

class ChatArchiveSearchField extends StatelessWidget {
  const ChatArchiveSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: kMediumPlusPadding,
        right: kMediumPlusPadding,
        bottom: kMediumPadding,
      ),
      child: TextField(
        onChanged: (value) => di<ChatModel>().setFilteredRoomsQuery(value),
        decoration: InputDecoration(
          hintText: context.l10n.search,
          label: Text(context.l10n.search),
          suffixIcon: IconButton(
            padding: EdgeInsets.zero,
            style: textFieldSuffixStyle,
            onPressed: () {},
            icon: const Icon(YaruIcons.search),
          ),
        ),
        autofocus: true,
      ),
    );
  }
}
