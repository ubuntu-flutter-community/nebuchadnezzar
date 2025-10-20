import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/icons.dart';

import '../../common/chat_manager.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';

class ChatRoomsSearchField extends StatefulWidget {
  const ChatRoomsSearchField({super.key});

  @override
  State<ChatRoomsSearchField> createState() => _ChatRoomsSearchFieldState();
}

class _ChatRoomsSearchFieldState extends State<ChatRoomsSearchField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (di<ChatManager>().filteredRoomsQuery != null) {
      _controller.text = di<ChatManager>().filteredRoomsQuery!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(
      left: kMediumPlusPadding,
      right: kMediumPlusPadding,
      bottom: kMediumPadding,
    ),
    child: TextField(
      controller: _controller,
      onChanged: di<ChatManager>().setFilteredRoomsQuery,
      decoration: InputDecoration(
        hintText: context.l10n.search,
        label: Text(context.l10n.search),
        suffixIcon: IconButton(
          style: textFieldSuffixStyle,
          onPressed: () {
            _controller.clear();
            di<ChatManager>().setFilteredRoomsQuery(null);
          },
          icon: const Icon(YaruIcons.edit_clear),
        ),
      ),
      autofocus: true,
    ),
  );
}
