import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../common/matrix_file_x.dart';
import '../../../common/view/build_context_x.dart';
import '../../../common/view/ui_constants.dart';
import '../draft_model.dart';

class ChatPendingAttachment extends StatelessWidget {
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
    return Padding(
      padding: const EdgeInsets.all(kSmallPadding),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(kBigBubbleRadius),
            child: file.isRegularImage
                ? Image.memory(
                    file.bytes,
                    height: dimension,
                    width: dimension,
                    fit: BoxFit.cover,
                  )
                : ChatPendingFile(
                    file: file,
                    height: dimension,
                    width: dimension,
                  ),
          ),
          if (onTap != null)
            Positioned(
              right: kSmallPadding,
              top: kSmallPadding,
              child: IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withValues(alpha: 0.8),
                  shape: const CircleBorder(),
                ),
                onPressed: onTap,
                icon: const Icon(
                  YaruIcons.window_close,
                  color: Colors.white,
                ),
              ),
            ),
          Positioned(
            bottom: kSmallPadding,
            left: kSmallPadding,
            child: ChatPendingAttachmentCompressButton(
              onToggleCompress: onToggleCompress,
              file: file,
              roomId: roomId,
            ),
          ),
        ],
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
      (DraftModel m) => m.getCompressFile(roomId: roomId, file: file),
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

class ChatPendingFile extends StatelessWidget {
  const ChatPendingFile({
    super.key,
    required this.file,
    this.height,
    this.width,
  });

  final MatrixFile file;
  final double? height, width;

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        width: width,
        color: context.colorScheme.outline,
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
      );
}
