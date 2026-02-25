import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../../common/view/build_context_x.dart';
import '../../../common/view/ui_constants.dart';
import '../../../extensions/matrix_file_x.dart';
import '../../../player/view/player_control_mixin.dart';
import '../../common/view/audio_visualizer.dart';
import '../draft_manager.dart';

class ChatPendingAttachment extends StatelessWidget
    with WatchItMixin, PlayerControlMixin {
  const ChatPendingAttachment({
    super.key,
    this.onTap,
    required this.file,
    this.onToggleCompress,
    required this.roomId,
  });

  final VoidCallback? onTap;
  final VoidCallback? onToggleCompress;
  final MatrixFile file;
  final String roomId;

  static const dimension = 220.0;

  @override
  Widget build(BuildContext context) {
    final pendingRecording = watchValue(
      (DraftManager m) => m.stopRecordCommand.select((r) => r?.path),
    );

    final sending = watchValue((DraftManager m) => m.sendCommand.isRunning);

    const borderRadius = BorderRadius.all(kBigBubbleRadius);
    return Opacity(
      opacity: sending ? 0.5 : 1.0,
      child: Padding(
        padding: const EdgeInsets.all(kSmallPadding),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: borderRadius,
              child: file.isRegularImage
                  ? Image.memory(
                      file.bytes,
                      height: dimension,
                      width: dimension,
                      fit: BoxFit.cover,
                    )
                  : InkWell(
                      hoverColor: context.colorScheme.primary.withValues(
                        alpha: 0.1,
                      ),
                      borderRadius: borderRadius,
                      onTap:
                          pendingRecording != null &&
                              (file is MatrixAudioFile ||
                                  file is MatrixVideoFile)
                          ? () => playAudioRecording(pendingRecording)
                          : null,
                      child: ChatPendingFile(
                        file: file,
                        height: dimension,
                        width: dimension,
                      ),
                    ),
            ),
            if (onTap != null && !sending)
              Positioned(
                right: kSmallPadding,
                top: kSmallPadding,
                child: IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withValues(alpha: 0.8),
                    shape: const CircleBorder(),
                  ),
                  onPressed: onTap,
                  icon: const Icon(YaruIcons.window_close, color: Colors.white),
                ),
              ),

            if (file is MatrixImageFile)
              Positioned(
                bottom: kSmallPadding,
                left: kSmallPadding,
                child: ChatPendingAttachmentCompressButton(
                  onToggleCompress: sending ? null : onToggleCompress,
                  file: file,
                  roomId: roomId,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ChatPendingAttachmentCompressButton extends StatelessWidget
    with WatchItMixin {
  const ChatPendingAttachmentCompressButton({
    super.key,
    required this.onToggleCompress,
    required this.file,
    required this.roomId,
  });

  final VoidCallback? onToggleCompress;
  final MatrixFile file;
  final String roomId;

  @override
  Widget build(BuildContext context) {
    final compress = watchPropertyValue(
      (DraftManager m) => m.getCompressFile(roomId: roomId, file: file),
    );
    return ElevatedButton.icon(
      onPressed: onToggleCompress,
      label: const Text('Compress'),
      icon: compress
          ? const Icon(YaruIcons.checkbox_checked_filled)
          : const Icon(YaruIcons.checkbox),
    );
  }
}

class ChatPendingFile extends StatelessWidget with WatchItMixin {
  const ChatPendingFile({
    super.key,
    required this.file,
    this.height,
    this.width,
  });

  final MatrixFile file;
  final double? height, width;

  @override
  Widget build(BuildContext context) {
    final recording = watchValue((DraftManager m) => m.stopRecordCommand);
    final showAudioVisualizer =
        recording != null &&
        (file is MatrixAudioFile || file is MatrixVideoFile);
    return Stack(
      alignment: Alignment.center,
      children: [
        if (showAudioVisualizer)
          AudioVisualizer(height: height ?? 32, recording: recording),
        Container(
          height: height,
          width: width,
          color: context.colorScheme.outline.withValues(
            alpha: showAudioVisualizer ? 0.5 : 0.9,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: kSmallPadding,
              children: [
                Icon(
                  file.isVideo
                      ? YaruIcons.video_filled
                      : file.isAudio
                      ? YaruIcons.media_play
                      : YaruIcons.document_filled,
                  color: Colors.white,
                  size: 100,
                ),
                Padding(
                  padding: const EdgeInsets.all(kMediumPadding),
                  child: Text(file.name),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
