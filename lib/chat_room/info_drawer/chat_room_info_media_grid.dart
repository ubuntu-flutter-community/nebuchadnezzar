import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';

import '../../common/event_x.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/common_widgets.dart';
import '../../common/view/ui_constants.dart';
import '../../events/view/chat_image.dart';
import '../../events/view/chat_message_image_full_screen_dialog.dart';
import '../timeline/timeline_model.dart';

class ChatRoomInfoMediaGrid extends StatelessWidget with WatchItMixin {
  ChatRoomInfoMediaGrid({super.key, required this.room});

  final Room room;

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    final timeline =
        watchPropertyValue((TimelineModel m) => m.getTimeline(room.id));

    final colorScheme = context.colorScheme;
    final updatingTimeline = watchPropertyValue(
      (TimelineModel m) => m.getUpdatingTimeline(timeline?.room.id),
    );

    if (updatingTimeline || timeline == null) {
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

    final events = timeline.events
        .where(
          (e) =>
              e.type == EventTypes.Message &&
              e.messageType == MessageTypes.Image &&
              !e.isSvgImage,
        )
        .toList();

    if (events.isEmpty) {
      return const SizedBox.shrink();
    }

    return GridView.builder(
      padding: const EdgeInsets.only(
        left: kBigPadding,
        right: kBigPadding,
        bottom: 3 * kBigPadding,
      ),
      itemCount: events.length,
      key: listKey,
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
    );
  }
}
