import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../common/chat_manager.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';

class ChatRoomsSearchField extends StatelessWidget {
  const ChatRoomsSearchField({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(
      left: kMediumPlusPadding,
      right: kMediumPlusPadding,
      bottom: kMediumPadding,
    ),
    child: TextField(
      onChanged: di<ChatManager>().setFilteredRoomsQuery,
      decoration: InputDecoration(
        hintText: context.l10n.search,
        label: Text(context.l10n.search),
      ),
      autofocus: true,
    ),
  );
}
