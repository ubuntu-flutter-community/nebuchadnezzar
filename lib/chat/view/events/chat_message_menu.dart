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
import '../../event_x.dart';

class ChatMessageMenu extends StatefulWidget {
  const ChatMessageMenu({
    super.key,
    required this.event,
    required this.child,
  });

  final Event event;
  final Widget child;

  @override
  State<ChatMessageMenu> createState() => _ChatMessageMenuState();
}

class _ChatMessageMenuState extends State<ChatMessageMenu> {
  final _controller = MenuController();

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.bodyMedium;
    return GestureDetector(
      onSecondaryTap: () => _controller.open(),
      behavior: HitTestBehavior.opaque,
      child: MenuAnchor(
        controller: _controller,
        consumeOutsideTap: true,
        alignmentOffset:
            Offset(widget.event.isImage ? 0 : kMediumPadding, -kSmallPadding),
        menuChildren: [
          if (widget.event.canRedact)
            MenuItemButton(
              trailingIcon: const Icon(YaruIcons.trash),
              onPressed: () =>
                  widget.event.room.redactEvent(widget.event.eventId),
              child: Text(
                context.l10n.deleteMessage,
                style: style,
              ),
            ),
          MenuItemButton(
            trailingIcon: const Icon(YaruIcons.reply),
            onPressed: () => di<DraftModel>().setReplyEvent(widget.event),
            child: Text(
              context.l10n.reply,
              style: style,
            ),
          ),
          if (widget.event.room.canSendDefaultMessages)
            MenuItemButton(
              trailingIcon: const Icon(YaruIcons.pen),
              onPressed: () {
                di<DraftModel>()
                  ..setEditEvent(
                    roomId: widget.event.room.id,
                    event: widget.event,
                  )
                  ..setDraft(
                    roomId: widget.event.room.id,
                    draft: widget.event.plaintextBody,
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
                text: widget.event.body,
              ),
            ),
          ),
          ChatMessageReactionPicker(event: widget.event),
        ],
        child: widget.child,
      ),
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
