import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../chat_room/input/draft_model.dart';
import '../../common/chat_model.dart';
import '../../common/event_x.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/confirm.dart';
import '../../common/view/snackbars.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';

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

    return Material(
      borderRadius: const BorderRadius.all(kBigBubbleRadius)
          .outer(const EdgeInsets.all(1)),
      child: InkWell(
        hoverColor: getTileOutlineColor(
          di<ChatModel>().isUserEvent(widget.event),
          context.theme,
        ),
        borderRadius: const BorderRadius.all(kBigBubbleRadius)
            .outer(const EdgeInsets.all(1)),
        mouseCursor: SystemMouseCursors.basic,
        onTap: widget.event.redacted
            ? null
            : () =>
                _controller.isOpen ? _controller.close() : _controller.open(),
        child: MenuAnchor(
          controller: _controller,
          consumeOutsideTap: true,
          alignmentOffset: const Offset(0, -kSmallPadding),
          menuChildren: widget.event.redacted
              ? []
              : [
                  MenuItemButton(
                    trailingIcon: const Icon(YaruIcons.reply),
                    onPressed: () =>
                        di<DraftModel>().setReplyEvent(widget.event),
                    child: Text(
                      context.l10n.reply,
                      style: style,
                    ),
                  ),
                  if (widget.event.room.canSendDefaultMessages &&
                      di<ChatModel>().isUserEvent(widget.event))
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
                  if (widget.event.room
                      .canSendEvent(EventTypes.RoomPinnedEvents))
                    MenuItemButton(
                      trailingIcon: const Icon(YaruIcons.pin),
                      child: Text(
                        widget.event.pinned
                            ? context.l10n.unpin
                            : context.l10n.pinMessage,
                        style: style,
                      ),
                      onPressed: () => widget.event.togglePinned(),
                    ),
                  if (widget.event.canRedact)
                    MenuItemButton(
                      trailingIcon: const Icon(YaruIcons.trash),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => ConfirmationDialog(
                          title: Text(
                            '${context.l10n.deleteMessage}: ${widget.event.senderFromMemoryOrFallback.displayName ?? ''}',
                          ),
                          content: SizedBox(
                            width: 300,
                            child: Text(
                              widget.event.body,
                            ),
                          ),
                          onConfirm: () => widget.event.room
                              .redactEvent(widget.event.eventId),
                        ),
                      ),
                      child: Text(
                        context.l10n.deleteMessage,
                        style: style,
                      ),
                    ),
                  ChatMessageReactionPicker(event: widget.event),
                ],
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: widget.child,
          ),
        ),
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
      width: 250,
      height: 220,
      child: EmojiPicker(
        config: emojiPickerConfig(theme: context.theme, emojiSizeMax: 15),
        onEmojiSelected: (category, emoji) => event.room.sendReaction(
          event.eventId,
          emoji.emoji,
        ),
      ),
    );
  }
}
