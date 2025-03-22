import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/icons.dart';

import '../../common/chat_model.dart';
import '../../common/event_x.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/common_widgets.dart';
import '../../common/view/ui_constants.dart';
import '../../events/view/chat_image.dart';
import '../../events/view/chat_message_image_full_screen_dialog.dart';
import '../../l10n/l10n.dart';
import '../timeline/timeline_model.dart';
import '../timeline/timeline_x.dart';

class ChatRoomInfoMediaGrid extends StatelessWidget with WatchItMixin {
  ChatRoomInfoMediaGrid({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    watchStream((ChatModel m) => m.getEventStream(room), initialValue: null);
    watchStream((ChatModel m) => m.getHistoryStream(room), initialValue: null);

    final timeline =
        watchPropertyValue((TimelineModel m) => m.getTimeline(room.id));

    if (timeline == null) {
      return Center(
        child: RepaintBoundary(
          child: CircleAvatar(
            backgroundColor: colorScheme.surface,
            maxRadius: 15,
            child: SizedBox.square(
              dimension: 18,
              child: Progress(
                strokeWidth: 2,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ),
      );
    }

    final events = timeline.imageEvents;

    if (events.isEmpty) {
      return const SizedBox.shrink();
    }

    return NotificationListener<ScrollEndNotification>(
      onNotification: (notification) {
        di<TimelineModel>().requestHistory(timeline, historyCount: 50);

        return true;
      },
      child: GridView.builder(
        padding: const EdgeInsets.only(
          left: kBigPadding,
          right: kBigPadding,
          bottom: 3 * kBigPadding,
        ),
        itemCount: events.length,
        itemBuilder: (context, i) {
          final event = events[i];

          return ChatImage(
            dimension: 200,
            event: event,
            timeline: timeline,
            onTap: event.isSvgImage
                ? null
                : () => showDialog(
                      context: context,
                      builder: (context) => ChatMessageImageFullScreenDialog(
                        event: event,
                      ),
                    ),
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 100,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }
}

class ChatLoadMoreHistoryButton extends StatelessWidget with WatchItMixin {
  const ChatLoadMoreHistoryButton({
    super.key,
    required this.timeline,
  });

  final Timeline timeline;

  @override
  Widget build(BuildContext context) {
    final updatingTimeline = watchPropertyValue(
      (TimelineModel m) => m.getUpdatingTimeline(timeline.room.id),
    );

    return OutlinedButton.icon(
      icon: updatingTimeline
          ? const SizedBox.square(
              dimension: 12,
              child: Progress(
                strokeWidth: 2,
              ),
            )
          : const Icon(YaruIcons.refresh),
      onPressed: () => di<TimelineModel>().requestHistory(
        timeline,
        filter: StateFilter(
          types: [EventTypes.Message],
        ),
        historyCount: 1000,
      ),
      label: Text(context.l10n.loadMore),
    );
  }
}
