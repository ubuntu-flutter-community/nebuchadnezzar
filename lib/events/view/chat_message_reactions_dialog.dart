import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';
import '../../common/view/chat_avatar.dart';
import '../../common/view/space.dart';
import '../../common/view/ui_constants.dart';
import '../chat_message_reaction_entry.dart';

class ChatMessageReactionsDialog extends StatelessWidget {
  const ChatMessageReactionsDialog({super.key, this.reactionEntry});

  final ChatMessageReactionEntry? reactionEntry;

  @override
  Widget build(BuildContext context) => SimpleDialog(
    title: YaruDialogTitleBar(
      title: Text(reactionEntry!.key),
      border: BorderSide.none,
      backgroundColor: Colors.transparent,
    ),
    titlePadding: EdgeInsets.zero,
    children: space(
      heightGap: kSmallPadding,
      children: [
        for (final reactor in reactionEntry!.reactors!)
          Chip(
            avatar: ChatAvatar(avatarUri: reactor.avatarUrl),
            label: Text(reactor.displayName ?? ''),
          ),
      ],
    ),
  );
}
