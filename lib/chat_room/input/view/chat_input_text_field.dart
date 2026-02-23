import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';
import 'package:yaru/yaru.dart';

import '../../../common/chat_manager.dart';
import '../../../common/view/common_widgets.dart';
import '../../../common/view/snackbars.dart';
import '../../../common/view/ui_constants.dart';
import '../../../extensions/room_x.dart';
import '../../../l10n/l10n.dart';
import '../../create_or_edit/edit_room_service.dart';
import '../draft_manager.dart';
import 'chat_input_emoji_picker.dart';

class ChatInputTextField extends StatelessWidget with WatchItMixin {
  const ChatInputTextField({
    super.key,
    required this.room,
    required this.sendController,
    required this.sendNode,
    required this.send,
  });

  final Room room;
  final TextEditingController sendController;
  final FocusNode sendNode;
  final VoidCallback send;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final draftManager = di<DraftManager>();
    final draftFiles = watchPropertyValue(
      (DraftManager m) => m.getFilesDraft(room.id),
    );
    final attaching = watchPropertyValue((DraftManager m) => m.attaching);

    final isPastingFromClipboard = watchValue(
      (DraftManager m) => m.addAttachmentFromClipboardCommand.isRunning,
    );

    final isSending = watchValue((DraftManager m) => m.sendCommand.isRunning);

    final sendingFile = draftFiles.isNotEmpty && isSending;

    registerHandler(
      select: (DraftManager m) => m.stopRecordCommand.results,
      handler: (context, newValue, cancel) {
        if (newValue.hasError) {
          showErrorSnackBar(context, newValue.error.toString());
        }
      },
    );

    registerHandler(
      select: (DraftManager m) => m.startRecordCommand.results,
      handler: (context, newValue, cancel) {
        if (newValue.hasError) {
          showErrorSnackBar(context, newValue.error.toString());
        }
      },
    );

    final unAcceptedDirectChat =
        watchStream(
          (ChatManager m) => m.getPendingDirectChatStream(room),
          initialValue: room.isUnacceptedDirectChat,
          preserveState: false,
          allowStreamChange: true,
        ).data ??
        room.isUnacceptedDirectChat;

    final disabled =
        isPastingFromClipboard ||
        sendingFile ||
        attaching ||
        unAcceptedDirectChat;

    final textDraft = watchPropertyValue(
      (DraftManager m) => m.getTextDraft(room.id),
    );

    sendController.text = textDraft ?? '';

    return Padding(
      padding: const EdgeInsets.all(kMediumPadding),
      child: TextField(
        minLines: 1,
        maxLines: 10,
        focusNode: sendNode,
        controller: sendController,
        enabled: !disabled,
        autofocus: true,
        onChanged: (v) {
          draftManager
            ..setTextDraft(roomId: room.id, draft: v, notify: false)
            ..setCursorPosition(
              roomId: room.id,
              position: sendController.selection.baseOffset,
            );
          unawaited(di<EditRoomService>().setTyping(room, v.isNotEmpty));
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
                  onPressed: disabled
                      ? null
                      : () => draftManager.addAttachment(room.id),
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
                  onEmojiSelected: disabled
                      ? null
                      : (cat, emo) {
                          sendController.text = sendController.text + emo.emoji;
                          draftManager
                            ..setTextDraft(
                              roomId: room.id,
                              draft: sendController.text,
                              notify: true,
                            )
                            ..setCursorPosition(
                              roomId: room.id,
                              position: sendController.selection.baseOffset,
                            );
                          sendNode.requestFocus();
                        },
                ),
              ],
            ),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ChatInputRecordVoiceMessageButton(disabled: disabled, room: room),
              IconButton(
                tooltip: l10n.send,
                padding: EdgeInsets.zero,
                icon: Transform.rotate(
                  angle: pi / 4,
                  child: const Padding(
                    padding: EdgeInsets.only(right: 2, top: 2),
                    child: Icon(YaruIcons.send_filled),
                  ),
                ),
                onPressed: disabled ? null : () => send(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatInputRecordVoiceMessageButton extends StatelessWidget
    with WatchItMixin {
  const ChatInputRecordVoiceMessageButton({
    super.key,
    required this.disabled,
    required this.room,
  });

  final bool disabled;
  final Room room;

  @override
  Widget build(BuildContext context) {
    callOnceAfterThisBuild(
      (context) => di<DraftManager>().checkPermissionForRecordingCommand.run(),
    );

    final hasPermission = watchValue(
      (DraftManager m) => m.checkPermissionForRecordingCommand,
    );

    final isRecording = watchPropertyValue((DraftManager m) => m.isRecording);
    return IconButton(
      tooltip: hasPermission == false
          ? context.l10n.noPermission
          : isRecording
          ? context.l10n.endRecordingVoiceMessage
          : context.l10n.startRecordingVoiceMessage,
      padding: EdgeInsets.zero,
      icon: isRecording
          ? const Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.red,
                    valueColor: AlwaysStoppedAnimation(Colors.red),
                  ),
                ),
                Icon(YaruIcons.stop, color: Colors.red),
              ],
            )
          : const Icon(YaruIcons.microphone),
      onPressed: disabled || hasPermission != true
          ? null
          : () => di<DraftManager>().toggleRecording(room.id),
    );
  }
}
