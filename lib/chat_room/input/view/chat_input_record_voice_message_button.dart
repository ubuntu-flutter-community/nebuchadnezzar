import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';
import 'package:yaru/yaru.dart';

import '../../../l10n/l10n.dart';
import '../draft_manager.dart';

class ChatInputRecordVoiceMessageButton extends StatelessWidget
    with WatchItMixin {
  const ChatInputRecordVoiceMessageButton({super.key, required this.room});

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
      onPressed: hasPermission != true
          ? null
          : () => di<DraftManager>().toggleRecording(room.id),
    );
  }
}
