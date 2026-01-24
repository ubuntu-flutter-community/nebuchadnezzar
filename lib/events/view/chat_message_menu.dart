import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';
import 'package:yaru/yaru.dart';

import '../../chat_room/input/draft_manager.dart';
import '../../chat_room/timeline/chat_seen_by_indicator.dart';
import '../../chat_room/timeline/chat_thread_dialog.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/confirm.dart';
import '../../common/view/snackbars.dart';
import '../../extensions/event_x.dart';
import '../../extensions/user_x.dart';
import '../../l10n/l10n.dart';
import 'chat_event_inspect_dialog.dart';
import 'chat_message_menu_reaction_picker.dart';
import 'chat_text_message.dart';

class ChatMessageMenu extends StatefulWidget {
  const ChatMessageMenu({
    super.key,
    required this.event,
    required this.child,
    required this.timeline,
    this.allowNormalReply = true,
  });

  final Event event;
  final Timeline timeline;
  final bool allowNormalReply;
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
                if (widget.allowNormalReply)
                  MenuItemButton(
                    trailingIcon: const Icon(YaruIcons.reply),
                    onPressed: () {
                      if (widget.event
                          .aggregatedEvents(
                            widget.timeline,
                            RelationshipTypes.thread,
                          )
                          .isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) => ChatThreadDialog(
                            event: widget.event,
                            timeline: widget.timeline,
                            onReplyOriginClick: (e) async {},
                          ),
                        );
                      } else {
                        di<DraftManager>().setReplyEvent(widget.event);
                      }
                    },
                    child: Text(context.l10n.reply, style: style),
                  ),
                if (widget.event.room.canSendDefaultMessages &&
                    widget.event.isUserEvent)
                  MenuItemButton(
                    trailingIcon: const Icon(YaruIcons.pen),
                    onPressed: () {
                      di<DraftManager>()
                        ..setEditEvent(
                          roomId: widget.event.room.id,
                          event: widget.event,
                        )
                        ..setTextDraft(
                          roomId: widget.event.room.id,
                          draft: widget.event.plaintextBody,
                          notify: true,
                        );
                    },
                    child: Text(context.l10n.edit, style: style),
                  ),
                MenuItemButton(
                  trailingIcon: const Icon(YaruIcons.copy),
                  child: Text(context.l10n.copyToClipboard, style: style),
                  onPressed: () => showSnackBar(
                    context,
                    content: CopyClipboardContent(
                      text: widget.event.body,
                      child: ChatTextMessage(displayEvent: widget.event),
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
                          child: Text(widget.event.body),
                        ),
                        onConfirm: () =>
                            widget.event.room.redactEvent(widget.event.eventId),
                      ),
                    ),
                    child: Text(context.l10n.deleteMessage, style: style),
                  ),
                if (widget.event.status == EventStatus.error)
                  MenuItemButton(
                    trailingIcon: const Icon(YaruIcons.send),
                    onPressed: () => widget.event.sendAgain(),
                    child: Text(context.l10n.send, style: style),
                  ),

                MenuItemButton(
                  trailingIcon: const Icon(YaruIcons.code),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => ChatEventInspectDialog(
                      event: widget.event,
                      child: widget.child,
                    ),
                  ),
                  child: Text('Inspect', style: style),
                ),
                if (widget.event.receipts.isNotEmpty)
                  MenuItemButton(
                    child: SimpleChatSeenByIndicator(
                      alignment: Alignment.centerLeft,
                      seenByUsers: widget.event.receipts
                          .map((e) => e.user)
                          .where((e) => !e.isLoggedInUser)
                          .toList(),
                    ),
                  ),
              ],
        child: widget.child,
      ),
    );
  }
}
