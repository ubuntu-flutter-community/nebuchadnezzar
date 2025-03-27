import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../chat_room/input/draft_model.dart';
import '../../common/event_x.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/confirm.dart';
import '../../common/view/snackbars.dart';
import '../../l10n/l10n.dart';
import 'chat_event_inspect_dialog.dart';
import 'chat_message_menu_reaction_picker.dart';
import 'chat_text_message.dart';

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
      onSecondaryTap: widget.event.redacted
          ? null
          : () => _controller.isOpen ? _controller.close() : _controller.open(),
      child: MenuAnchor(
        controller: _controller,
        consumeOutsideTap: true,
        menuChildren: widget.event.redacted
            ? []
            : [
                ChatMessageMenuReactionPicker(event: widget.event),
                const Divider(),
                MenuItemButton(
                  trailingIcon: const Icon(YaruIcons.reply),
                  onPressed: () => di<DraftModel>().setReplyEvent(widget.event),
                  child: Text(
                    context.l10n.reply,
                    style: style,
                  ),
                ),
                if (widget.event.room.canSendDefaultMessages &&
                    widget.event.isUserEvent)
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
                      child: ChatTextMessage(
                        event: widget.event,
                        displayEvent: widget.event,
                      ),
                    ),
                  ),
                ),
                if (widget.event.room.canSendEvent(EventTypes.RoomPinnedEvents))
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
                        onConfirm: () =>
                            widget.event.room.redactEvent(widget.event.eventId),
                      ),
                    ),
                    child: Text(
                      context.l10n.deleteMessage,
                      style: style,
                    ),
                  ),
                if (kDebugMode)
                  MenuItemButton(
                    trailingIcon: const Icon(YaruIcons.code),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => ChatEventInspectDialog(
                        event: widget.event,
                        child: widget.child,
                      ),
                    ),
                    child: Text(
                      'Inspect',
                      style: style,
                    ),
                  ),
              ],
        child: widget.child,
      ),
    );
  }
}
