import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:photo_view/photo_view.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../app/view/error_page.dart';
import '../../common/date_time_x.dart';
import '../../common/event_x.dart';
import '../../common/local_image_manager.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/common_widgets.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../chat_download_manager.dart';

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
    _future = di<LocalImageManager>().downloadImage(
      event: widget.event,
      cache: false,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _zoom(bool zoomIn) {
    if (_controller.scale == null) {
      return;
    }
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
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      scrollable: true,
      titlePadding: EdgeInsets.zero,
      title: YaruDialogTitleBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: kSmallPadding,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 100),
              child:
                  (widget.event.fileDescription != null &&
                      widget.event.fileDescription!.isNotEmpty)
                  ? Text('${widget.event.fileDescription!}, ')
                  : Text(
                      '${widget.event.senderFromMemoryOrFallback.calcDisplayname()}, ',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
            Text(
              widget.event.originServerTs.toLocal().formatAndLocalize(context),
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
            const AnimatedSwitcher(duration: Duration(milliseconds: 300)),
          ],
        ),
        border: BorderSide.none,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            tooltip: l10n.downloadFile,
            onPressed: () => di<ChatDownloadManager>().safeFile(
              event: widget.event,
              dialogTitle: l10n.saveFile,
              confirmButtonText: l10n.saveFile,
            ),
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
              child: StreamBuilder(
                stream: _controller.outputStateStream,
                builder: (context, child) {
                  return Text(
                    'Scale: ${_controller.scale?.toStringAsFixed(2) ?? '0.5'}',
                  );
                },
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
                        if (snapshot.hasError) {
                          return ErrorBody(error: snapshot.error.toString());
                        }
                        if (snapshot.hasData) {
                          return ClipRRect(
                            child: PhotoView(
                              loadingBuilder: (context, event) =>
                                  const Center(child: Progress()),
                              imageProvider: MemoryImage(snapshot.data!),
                              minScale: PhotoViewComputedScale.contained * 0.8,
                              maxScale: PhotoViewComputedScale.covered * 10,
                              initialScale:
                                  PhotoViewComputedScale.contained * 0.5,
                              controller: _controller,
                            ),
                          );
                        } else {
                          return const Center(child: Progress());
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
}
