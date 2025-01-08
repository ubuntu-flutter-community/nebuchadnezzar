import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../common/view/build_context_x.dart';
import '../../../common/view/snackbars.dart';
import '../../../common/view/ui_constants.dart';
import '../../../l10n/l10n.dart';
import '../../data/emojis.dart';
import '../../draft_model.dart';
import '../../room_x.dart';

class ChatMessageMenu extends StatelessWidget {
  const ChatMessageMenu({
    super.key,
    required this.event,
    required this.child,
  });

  final Event event;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.bodyMedium;
    return MenuAnchor(
      consumeOutsideTap: true,
      alignmentOffset: const Offset(kMediumPadding, -kMediumPadding),
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return GestureDetector(
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: child,
        );
      },
      menuChildren: [
        if (event.canRedact)
          MenuItemButton(
            trailingIcon: const Icon(YaruIcons.trash),
            onPressed: () => event.room.redactEvent(event.eventId),
            child: Text(
              context.l10n.deleteMessage,
              style: style,
            ),
          ),
        MenuItemButton(
          trailingIcon: const Icon(YaruIcons.reply),
          onPressed: () => di<DraftModel>().setReplyEvent(event),
          child: Text(
            context.l10n.reply,
            style: style,
          ),
        ),
        if (event.room.canEdit == true)
          MenuItemButton(
            trailingIcon: const Icon(YaruIcons.pen),
            onPressed: () {
              di<DraftModel>()
                ..setEditEvent(roomId: event.room.id, event: event)
                ..setDraft(
                  roomId: event.room.id,
                  draft: event.plaintextBody,
                  notify: true,
                );
            },
            child: Text(
              context.l10n.edit,
              style: style,
            ),
          ),
        MenuItemButton(
          trailingIcon: const Icon(YaruIcons.copy),
          child: Text(
            context.l10n.copyToClipboard,
            style: style,
          ),
          onPressed: () => showSnackBar(
            context,
            content: CopyClipboardContent(
              text: event.body,
            ),
          ),
        ),
        ChatMessageReactionPicker(event: event),
      ],
      child: child,
    );
  }
}

class ChatMessageReactionPicker extends StatelessWidget {
  const ChatMessageReactionPicker({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 40,
          crossAxisCount: 5,
        ),
        itemCount: emojis.length,
        itemBuilder: (context, i) => IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            event.room.sendReaction(
              event.eventId,
              emojis[i],
            );
          },
          icon: Text(
            emojis[i],
            style: context.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
