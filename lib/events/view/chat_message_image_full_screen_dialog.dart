import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:photo_view/photo_view.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/date_time_x.dart';
import '../../common/local_image_model.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/common_widgets.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../chat_download_model.dart';

class ChatMessageImageFullScreenDialog extends StatefulWidget {
  const ChatMessageImageFullScreenDialog({super.key, required this.event});

  final Event event;

  @override
  State<ChatMessageImageFullScreenDialog> createState() =>
      _ChatMessageImageFullScreenDialogState();
}

class _ChatMessageImageFullScreenDialogState
    extends State<ChatMessageImageFullScreenDialog> {
  XFile? file;
  late PhotoViewControllerBase<PhotoViewControllerValue> _controller;
  late final Future<Uint8List?> _future;

  @override
  void initState() {
    super.initState();
    _controller = PhotoViewController();
    _future = di<LocalImageModel>()
        .downloadImage(event: widget.event, getThumbnail: false);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _zoom(bool zoomIn) {
    if (zoomIn) {
      setState(() {
        _controller.scale = _controller.scale! + 0.1;
      });
    } else {
      setState(() {
        _controller.scale = _controller.scale! - 0.1;
      });
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        scrollable: true,
        titlePadding: EdgeInsets.zero,
        title: YaruDialogTitleBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: kSmallPadding,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 100),
                child: Text(
                  '${widget.event.senderFromMemoryOrFallback.calcDisplayname()}, ',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                widget.event.originServerTs
                    .toLocal()
                    .formatAndLocalize(context.l10n),
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
              ),
              const AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
              ),
            ],
          ),
          border: BorderSide.none,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              tooltip: context.l10n.downloadFile,
              onPressed: () => di<ChatDownloadModel>().safeFile(widget.event),
              icon: const Icon(YaruIcons.download),
            ),
          ],
        ),
        contentPadding: EdgeInsets.zero,
        actionsPadding: const EdgeInsets.symmetric(
          vertical: kMediumPadding,
          horizontal: kSmallPadding,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () => _zoom(false),
                icon: const Icon(YaruIcons.minus),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Scale: ${_controller.scale?.toStringAsFixed(2) ?? '0.5'}',
                ),
              ),
              IconButton(
                onPressed: () => _zoom(true),
                icon: const Icon(YaruIcons.plus),
              ),
            ],
          ),
        ],
        content: Builder(
          builder: (context) {
            return Listener(
              onPointerSignal: (event) {
                if (_controller.scale == null || event is! PointerScrollEvent) {
                  return;
                }

                _zoom(event.scrollDelta.dy < 0);
              },
              child: SizedBox(
                width: context.mediaQuerySize.width,
                height: context.mediaQuerySize.height - 150,
                child: Column(
                  spacing: kBigPadding,
                  children: [
                    Expanded(
                      child: FutureBuilder(
                        future: _future,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ClipRRect(
                              child: PhotoView(
                                imageProvider: MemoryImage(snapshot.data!),
                                minScale:
                                    PhotoViewComputedScale.contained * 0.8,
                                maxScale: PhotoViewComputedScale.covered * 10,
                                initialScale:
                                    PhotoViewComputedScale.contained * 0.5,
                                controller: _controller,
                              ),
                            );
                          } else {
                            return const Center(
                              child: Progress(),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
}
