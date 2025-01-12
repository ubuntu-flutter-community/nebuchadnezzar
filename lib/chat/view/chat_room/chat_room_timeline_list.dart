import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../common/view/build_context_x.dart';
import '../../../common/view/theme.dart';
import '../../../common/view/ui_constants.dart';
import '../../timeline_model.dart';
import '../events/chat_event_column.dart';
import 'chat_seen_by_indicator.dart';
import 'chat_typing_indicator.dart';
import 'titlebar/chat_room_title_bar.dart';

class ChatRoomTimelineList extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const ChatRoomTimelineList({
    super.key,
    required this.timeline,
    required this.listKey,
    required this.room,
  });

  final Timeline timeline;
  final Room room;
  final GlobalKey<AnimatedListState> listKey;

  @override
  State<ChatRoomTimelineList> createState() => _ChatRoomTimelineListState();
}

class _ChatRoomTimelineListState extends State<ChatRoomTimelineList> {
  final AutoScrollController _controller = AutoScrollController();
  bool _showScrollButton = false;
  int retryCount = 15;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => di<TimelineModel>().requestHistory(widget.timeline),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: NotificationListener<ScrollEndNotification>(
                onNotification: onScroll,
                child: AnimatedList(
                  controller: _controller,
                  padding: const EdgeInsets.symmetric(
                    horizontal: kMediumPadding,
                  ),
                  key: widget.listKey,
                  reverse: true,
                  initialItemCount: widget.timeline.events.length,
                  itemBuilder: (context, i, animation) {
                    final event = widget.timeline.events[i];

                    final maybePreviousEvent =
                        widget.timeline.events.elementAtOrNull(i + 1);

                    if (i == 0 && !widget.room.isArchived) {
                      widget.timeline.setReadMarker();
                    }

                    return AutoScrollTag(
                      index: i,
                      controller: _controller,
                      key: ValueKey('${event.eventId}tag'),
                      child: FadeTransition(
                        opacity: animation,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ChatEventColumn(
                              key: ValueKey('${event.eventId}column'),
                              event: event,
                              maybePreviousEvent: maybePreviousEvent,
                              jump: _jump,
                              showSeenByIndicator: i == 0,
                              timeline: widget.timeline,
                              room: widget.room,
                            ),
                            if (i == 0)
                              ChatEventSeenByIndicator(
                                key: ValueKey(
                                  '${event.eventId}${widget.timeline.events.length}',
                                ),
                                event: event,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            ChatTypingIndicator(room: widget.room),
          ],
        ),
        if (_showScrollButton)
          Positioned(
            right: kBigPadding,
            bottom: kBigPadding,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.only(
                bottom: _showScrollButton ? 3 * kBigPadding : 0,
              ),
              child: FloatingActionButton.small(
                backgroundColor: getMonochromeBg(theme: theme, darkFactor: 5),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => ChatRoomSearchDialog(room: widget.room),
                ),
                child: Icon(
                  YaruIcons.search,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
        if (_showScrollButton)
          Positioned(
            right: kBigPadding,
            bottom: kBigPadding,
            child: FloatingActionButton.small(
              backgroundColor: getMonochromeBg(
                theme: theme,
                darkFactor: 5,
              ),
              child: Icon(
                YaruIcons.go_down,
                color: theme.colorScheme.onSurface,
              ),
              onPressed: () => _maybeScrollTo(
                0,
                duration: const Duration(
                  milliseconds: 100,
                ),
              ),
            ),
          ),
      ],
    );
  }

  bool onScroll(scrollEnd) {
    final metrics = scrollEnd.metrics;
    if (metrics.atEdge) {
      final isAtBottom = metrics.pixels != 0;
      if (isAtBottom) {
        di<TimelineModel>().requestHistory(
          widget.timeline,
          historyCount: 150,
        );
      } else {
        setState(() => _showScrollButton = false);
      }
    } else {
      setState(() => _showScrollButton = true);
    }
    return true;
  }

  Future<void> _jump(Event event) async {
    int index = widget.timeline.events.indexOf(event);
    while (index == -1 && retryCount >= 0) {
      await di<TimelineModel>().requestHistory(
        widget.timeline,
        historyCount: 5,
      );
      index = widget.timeline.events.indexOf(event);
      retryCount--;
    }
    await _maybeScrollTo(index);
    if (!widget.room.isArchived) {
      widget.timeline.setReadMarker(eventId: event.eventId);
    }
  }

  Future<dynamic> _maybeScrollTo(
    int index, {
    Duration? duration,
  }) async {
    if (index == -1) {
      return;
    }

    await _controller.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.end,
      duration: duration ?? const Duration(milliseconds: 50),
    );
    retryCount = 15;
  }
}
