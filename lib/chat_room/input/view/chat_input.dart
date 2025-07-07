import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../common/chat_model.dart';
import '../../../common/view/common_widgets.dart';
import '../../../common/view/snackbars.dart';
import '../../../common/view/ui_constants.dart';
import '../../../l10n/l10n.dart';
import '../../common/view/chat_typing_indicator.dart';
import '../draft_model.dart';
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
      text: di<DraftModel>().getTextDraft(widget.room.id),
    );
    _sendNode = FocusNode(
      onKeyEvent: (node, event) {
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
          send();
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

  Future<void> send() async {
    final model = di<DraftModel>();
    if (model.sending) {
      return;
    }

    await model.send(
      room: widget.room,
      onFail: (error) => showSnackBar(context, content: Text(error)),
      onSuccess: () {
        _sendController.clear();
        _sendNode.requestFocus();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final draftModel = di<DraftModel>();
    final draftFiles = watchPropertyValue(
      (DraftModel m) => m.getFilesDraft(widget.room.id),
    );
    final attaching = watchPropertyValue((DraftModel m) => m.attaching);
    final archiveActive = watchPropertyValue((ChatModel m) => m.archiveActive);
    final sending = watchPropertyValue((DraftModel m) => m.sending);

    final replyEvent = watchPropertyValue((DraftModel m) => m.replyEvent);
    final editEvent = watchPropertyValue(
      (DraftModel m) => m.getEditEvent(widget.room.id),
    );

    final draft = watchPropertyValue(
      (DraftModel m) => m.getTextDraft(widget.room.id),
    );
    _sendController.text = draft ?? '';
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
                      onPressed: () => di<DraftModel>()
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
                    draftModel.setTextDraft(
                      roomId: widget.room.id,
                      draft: v,
                      notify: false,
                    );
                    widget.room.setTyping(v.isNotEmpty, timeout: 500);
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
                            onPressed: attaching || sending || archiveActive
                                ? null
                                : () => draftModel.addAttachment(
                                    widget.room.id,
                                    onFail: (error) =>
                                        showErrorSnackBar(context, error),
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
                                attaching || sending || archiveActive
                                ? null
                                : (cat, emo) {
                                    _sendController.text =
                                        _sendController.text + emo.emoji;
                                    draftModel.setTextDraft(
                                      roomId: widget.room.id,
                                      draft: _sendController.text,
                                      notify: true,
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
                          onPressed: attaching || sending || archiveActive
                              ? null
                              : send,
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
