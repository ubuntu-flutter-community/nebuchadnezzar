import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/chat_manager.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/common_widgets.dart';
import '../../common/view/ui_constants.dart';
import '../../events/chat_download_manager.dart';
import '../../events/view/chat_image.dart';
import '../../events/view/chat_message_image_full_screen_dialog.dart';
import '../../events/view/chat_message_media_avatar.dart';
import '../../extensions/event_x.dart';
import '../../l10n/l10n.dart';
import '../../player/view/player_control_mixin.dart';
import '../timeline/timeline_manager.dart';
import '../timeline/timeline_x.dart';

class ChatRoomInfoDrawerMediaGridTabs extends StatefulWidget {
  const ChatRoomInfoDrawerMediaGridTabs({super.key, required this.room});

  final Room room;

  @override
  State<ChatRoomInfoDrawerMediaGridTabs> createState() =>
      _ChatRoomInfoDrawerMediaGridTabsState();
}

class _ChatRoomInfoDrawerMediaGridTabsState
    extends State<ChatRoomInfoDrawerMediaGridTabs>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    spacing: kMediumPadding,
    children: [
      YaruTabBar(
        tabController: _controller,
        tabs: [
          const Tab(icon: Icon(YaruIcons.image)),
          const Tab(icon: Icon(YaruIcons.video)),
          const Tab(icon: Icon(YaruIcons.music_note)),
          const Tab(icon: Icon(YaruIcons.document)),
        ],
      ),
      Expanded(
        child: TabBarView(
          controller: _controller,
          children:
              [
                    MessageTypes.Image,
                    MessageTypes.Video,
                    MessageTypes.Audio,
                    MessageTypes.File,
                  ]
                  .map(
                    (e) => ChatRoomInfoMediaGrid(
                      room: widget.room,
                      messageType: e,
                    ),
                  )
                  .toList(),
        ),
      ),
    ],
  );
}

class ChatRoomInfoMediaGrid extends StatelessWidget
    with WatchItMixin, PlayerControlMixin {
  ChatRoomInfoMediaGrid({
    super.key,
    required this.room,
    e,
    required this.messageType,
  });

  final Room room;
  final String messageType;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    watchStream((ChatManager m) => m.getEventStream(room), initialValue: null);
    watchStream(
      (ChatManager m) => m.getHistoryStream(room),
      initialValue: null,
    );

    final timeline = watchPropertyValue(
      (TimelineManager m) => m.getTimeline(room.id),
    );

    if (timeline == null) {
      return Center(
        child: RepaintBoundary(
          child: CircleAvatar(
            backgroundColor: colorScheme.surface,
            maxRadius: 15,
            child: SizedBox.square(
              dimension: 18,
              child: Progress(strokeWidth: 2, color: colorScheme.onSurface),
            ),
          ),
        ),
      );
    }

    final events = timeline.getMediaEvents(messageType);

    if (events.isEmpty) {
      return const SizedBox.shrink();
    }

    return Center(
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (notification) {
          di<TimelineManager>().requestHistory(
            timeline,
            filter: StateFilter(types: [EventTypes.Message]),
            historyCount: 1000,
          );

          return true;
        },
        child: ListView.separated(
          padding: const EdgeInsets.only(
            left: kMediumPadding,
            right: kMediumPadding,
          ),
          itemCount: events.length,
          separatorBuilder: (context, index) => const Padding(
            padding: EdgeInsets.all(8.0),
            child: Divider(height: 0, thickness: 1),
          ),
          itemBuilder: (context, i) {
            final event = events[i];

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: kSmallPadding,
                horizontal: kMediumPadding,
              ),
              title: Text(
                event.fileName ?? event.fileDescription ?? 'Unknown',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: context.theme.textTheme.bodySmall,
              ),
              onTap: switch (messageType) {
                MessageTypes.Audio || MessageTypes.Video =>
                  () => playMatrixMedia(context, event: event),
                MessageTypes.Image => () => showDialog(
                  context: context,
                  builder: (context) =>
                      ChatMessageImageFullScreenDialog(event: event),
                ),
                _ => () => di<ChatDownloadManager>().safeFile(
                  event: event,
                  dialogTitle: l10n.saveFile,
                  confirmButtonText: l10n.saveFile,
                ),
              },
              minLeadingWidth: 50,
              leading: event.isImage
                  ? ChatImage(
                      event: event,
                      dimension: 50,
                      showDescription: false,
                      onlyImage: true,
                    )
                  : ChatMessageMediaAvatar(event: event),
            );
          },
        ),
      ),
    );
  }
}

class ChatLoadMoreHistoryButton extends StatelessWidget with WatchItMixin {
  const ChatLoadMoreHistoryButton({super.key, required this.timeline});

  final Timeline timeline;

  @override
  Widget build(BuildContext context) {
    final updatingTimeline = watchPropertyValue(
      (TimelineManager m) => m.getUpdatingTimeline(timeline.room.id),
    );

    return OutlinedButton.icon(
      icon: updatingTimeline
          ? const SizedBox.square(
              dimension: 12,
              child: Progress(strokeWidth: 2),
            )
          : const Icon(YaruIcons.refresh),
      onPressed: () => di<TimelineManager>().requestHistory(
        timeline,
        filter: StateFilter(types: [EventTypes.Message]),
        historyCount: 1000,
      ),
      label: Text(context.l10n.loadMore),
    );
  }
}
