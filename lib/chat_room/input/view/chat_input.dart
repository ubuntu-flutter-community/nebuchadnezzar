import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../../common/chat_manager.dart';
import '../../../common/logging.dart';
import '../../../common/view/common_widgets.dart';
import '../../../common/view/ui_constants.dart';
import '../../../l10n/l10n.dart';
import '../../common/view/chat_typing_indicator.dart';
import '../../create_or_edit/edit_room_service.dart';
import '../draft_manager.dart';
import 'chat_attachment_draft_panel.dart';
import 'chat_input_emoji_picker.dart';

class ChatInput extends StatefulWidget with WatchItStatefulWidgetMixin {
  const ChatInput({super.key, required this.room});

  final Room room;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  late final TextEditingController _sendController;
  late final FocusNode _sendNode;

  @override
  void initState() {
    super.initState();
    _sendController = TextEditingController(
      text: di<DraftManager>().getTextDraft(widget.room.id),
    );
    _sendNode = FocusNode(
      onKeyEvent: (node, event) {
        di<DraftManager>().setCursorPosition(
          roomId: widget.room.id,
          position: _sendController.selection.baseOffset,
        );
        // Check if the "@"-Key has been pressed
        if (_sendController.text.contains('@')) {
          printMessageInDebugMode('@ key pressed');

          return KeyEventResult.handled;
        }

        final enterPressedWithoutShift =
            event is KeyDownEvent &&
            event.physicalKey == PhysicalKeyboardKey.enter &&
            !HardwareKeyboard.instance.physicalKeysPressed.any(
              (key) => <PhysicalKeyboardKey>{
                PhysicalKeyboardKey.shiftLeft,
                PhysicalKeyboardKey.shiftRight,
              }.contains(key),
            );

        if (enterPressedWithoutShift) {
          send(context);
          return KeyEventResult.handled;
        } else if (event is KeyRepeatEvent) {
          // Disable holding enter
          return KeyEventResult.handled;
        } else {
          return KeyEventResult.ignored;
        }
      },
    );
  }

  @override
  void dispose() {
    _sendController.dispose();
    _sendNode.dispose();
    super.dispose();
  }

  Future<void> send(BuildContext context) async =>
      di<DraftManager>().filesDrafts.containsKey(widget.room.id) &&
          di<DraftManager>().filesDrafts[widget.room.id]!.isNotEmpty
      ? showFutureLoadingDialog(
          context: context,
          title: context.l10n.sendingAttachment,
          future: () => di<DraftManager>()
              .send(room: widget.room)
              .timeout(const Duration(seconds: 30)),
          barrierDismissible: true,
          backLabel: context.l10n.close,
          onError: (error) {
            if (error is TimeoutException) {
              return context.l10n.oopsSomethingWentWrong;
            }
            return error.toString();
          },
        ).then((res) {
          if (res.isValue) {
            _sendController.clear();
            _sendNode.requestFocus();
          }
        })
      : di<DraftManager>().send(room: widget.room).then((_) {
          _sendController.clear();
          _sendNode.requestFocus();
        });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final draftManager = di<DraftManager>();
    final draftFiles = watchPropertyValue(
      (DraftManager m) => m.getFilesDraft(widget.room.id),
    );
    final attaching = watchPropertyValue((DraftManager m) => m.attaching);
    final archiveActive = watchPropertyValue(
      (ChatManager m) => m.archiveActive,
    );

    final replyEvent = watchPropertyValue((DraftManager m) => m.replyEvent);
    final editEvent = watchPropertyValue(
      (DraftManager m) => m.getEditEvent(widget.room.id),
    );

    final draft = watchPropertyValue(
      (DraftManager m) => m.getTextDraft(widget.room.id),
    );

    _sendController.text = draft ?? '';

    final cursorPosition = watchPropertyValue(
      (DraftManager m) => m.getCursorPosition(widget.room.id),
    );
    if (cursorPosition != null &&
        cursorPosition <= _sendController.text.length) {
      _sendController.selection = TextSelection.fromPosition(
        TextPosition(offset: cursorPosition),
      );
    }

    _sendNode.requestFocus();

    var transform = Transform.rotate(
      angle: pi / 4,
      child: const Padding(
        padding: EdgeInsets.only(right: 2, top: 2),
        child: Icon(YaruIcons.send_filled),
      ),
    );
    final unAcceptedDirectChat =
        widget.room.isDirectChat &&
        widget.room.getParticipants().any(
          (e) => e.membership == Membership.invite,
        );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (draftFiles.isNotEmpty) const Divider(height: 1),
              if (draftFiles.isNotEmpty)
                ChatAttachmentDraftPanel(roomId: widget.room.id),
              if (replyEvent != null || editEvent != null)
                Padding(
                  padding: const EdgeInsets.only(
                    left: kMediumPadding,
                    right: kMediumPadding,
                    top: kMediumPadding,
                  ),
                  child: YaruInfoBox(
                    trailing: IconButton(
                      onPressed: () => di<DraftManager>()
                        ..setReplyEvent(null)
                        ..setEditEvent(roomId: widget.room.id, event: null)
                        ..setTextDraft(
                          roomId: widget.room.id,
                          draft: '',
                          notify: true,
                        ),
                      icon: const Icon(YaruIcons.trash),
                    ),
                    yaruInfoType: editEvent != null
                        ? YaruInfoType.warning
                        : YaruInfoType.information,
                    icon: Icon(
                      editEvent != null ? YaruIcons.pen : YaruIcons.reply,
                    ),
                    subtitle: Text(
                      (editEvent ?? replyEvent)!.plaintextBody,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    title: Text(
                      '${l10n.reply} (${(editEvent ?? replyEvent)!.senderFromMemoryOrFallback.displayName}):',
                    ),
                  ),
                ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(kMediumPadding),
                child: TextField(
                  minLines: 1,
                  maxLines: 10,
                  focusNode: _sendNode,
                  controller: _sendController,
                  enabled: !archiveActive && !unAcceptedDirectChat,
                  autofocus: true,
                  onChanged: (v) {
                    draftManager
                      ..setTextDraft(
                        roomId: widget.room.id,
                        draft: v,
                        notify: false,
                      )
                      ..setCursorPosition(
                        roomId: widget.room.id,
                        position: _sendController.selection.baseOffset,
                      );
                    unawaited(
                      di<EditRoomService>().setTyping(
                        widget.room,
                        v.isNotEmpty,
                      ),
                    );
                  },
                  decoration: InputDecoration(
                    hintText: unAcceptedDirectChat
                        ? l10n.waitingPartnerAcceptRequest
                        : l10n.sendAMessage,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(kSmallPadding),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            onPressed:
                                attaching ||
                                    archiveActive ||
                                    unAcceptedDirectChat
                                ? null
                                : () => draftManager.addAttachment(
                                    widget.room.id,
                                  ),
                            icon: attaching
                                ? const Center(
                                    child: SizedBox.square(
                                      dimension: 15,
                                      child: Progress(strokeWidth: 1),
                                    ),
                                  )
                                : const Icon(YaruIcons.plus),
                          ),
                          ChatInputEmojiPicker(
                            onEmojiSelected:
                                attaching ||
                                    archiveActive ||
                                    unAcceptedDirectChat
                                ? null
                                : (cat, emo) {
                                    _sendController.text =
                                        _sendController.text + emo.emoji;
                                    draftManager
                                      ..setTextDraft(
                                        roomId: widget.room.id,
                                        draft: _sendController.text,
                                        notify: true,
                                      )
                                      ..setCursorPosition(
                                        roomId: widget.room.id,
                                        position: _sendController
                                            .selection
                                            .baseOffset,
                                      );
                                    _sendNode.requestFocus();
                                  },
                          ),
                        ],
                      ),
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: l10n.send,
                          padding: EdgeInsets.zero,
                          icon: transform,
                          onPressed:
                              attaching || archiveActive || unAcceptedDirectChat
                              ? null
                              : () async => send(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: -kTypingAvatarSize - kSmallPadding,
          child: ChatTypingIndicator(room: widget.room),
        ),
      ],
    );
  }
}
