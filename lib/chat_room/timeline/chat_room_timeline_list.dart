import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:yaru/yaru.dart';

import '../../common/chat_manager.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/common_widgets.dart';
import '../../common/view/ui_constants.dart';
import '../../events/view/chat_event_tile.dart';
import '../../extensions/date_time_x.dart';
import '../../extensions/event_x.dart';
import '../../l10n/l10n.dart';
import '../../settings/settings_manager.dart';
import 'chat_room_pinned_events_dialog.dart';
import 'chat_seen_by_indicator.dart';
import 'timeline_manager.dart';

class ChatRoomTimelineList extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const ChatRoomTimelineList({
    super.key,
    required this.timeline,
    required this.listKey,
  });

  final Timeline timeline;
  final GlobalKey<AnimatedListState> listKey;

  @override
  State<ChatRoomTimelineList> createState() => _ChatRoomTimelineListState();
}

class _ChatRoomTimelineListState extends State<ChatRoomTimelineList> {
  final AutoScrollController _controller = AutoScrollController();
  bool _showScrollButton = false;
  int retryCount = 15;
  String? scrolledToId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      di<TimelineManager>().postTimelineLoad(widget.timeline);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.timeline.cancelSubscriptions();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final showAvatarChanges = watchPropertyValue(
      (SettingsManager m) => m.showChatAvatarChanges,
    );
    final showDisplayNameChanges = watchPropertyValue(
      (SettingsManager m) => m.showChatDisplaynameChanges,
    );
    final pinnedEvents =
        watchStream(
          (ChatManager m) => m
              .getJoinedRoomUpdate(widget.timeline.room.id)
              .map((_) => widget.timeline.room.pinnedEventIds),
          initialValue: widget.timeline.room.pinnedEventIds,
        ).data ??
        [];

    final isRequestingHistory = watchValue(
      (TimelineManager m) =>
          m.getRequestHistoryCommand(widget.timeline.room.id).isRunning,
    );

    final canRequestHistory = widget.timeline.canRequestHistory;

    final fabBgColor = theme.colorScheme.isDark
        ? theme.colorScheme.scrim
        : theme.colorScheme.surface;
    final fapFgColor = contrastColor(fabBgColor);
    final circleBorder = CircleBorder(
      side: BorderSide(color: fapFgColor.withAlpha(50)),
    );

    return Stack(
      children: [
        NotificationListener<ScrollEndNotification>(
          onNotification: onScroll,
          child: AnimatedList(
            controller: _controller,
            padding: const EdgeInsets.symmetric(
              horizontal: kMediumPlusPadding,
              vertical: kMediumPlusPadding,
            ),
            key: widget.listKey,
            reverse: true,
            initialItemCount: widget.timeline.events.length,
            itemBuilder: (context, i, animation) {
              final event = widget.timeline.events[i];

              final previous = widget.timeline.events.elementAtOrNull(i + 1);
              final next = i == 0
                  ? null
                  : widget.timeline.events.elementAtOrNull(i - 1);

              if (i == 0) {
                di<TimelineManager>().trySetReadMarker(widget.timeline);
              }

              final hideInTimeline = event.hideInTimeline(
                showAvatarChanges: showAvatarChanges,
                showDisplayNameChanges: showDisplayNameChanges,
              );

              return AutoScrollTag(
                index: i,
                controller: _controller,
                key: ValueKey('${event.eventId}tag'),
                child: SizeTransition(
                  sizeFactor: animation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!hideInTimeline) ...[
                        if (previous != null &&
                            event.originServerTs.toLocal().day !=
                                previous.originServerTs.toLocal().day)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: kSmallPadding,
                            ),
                            child: Text(
                              previous.originServerTs
                                  .toLocal()
                                  .formatAndLocalizeDay(context),
                              textAlign: TextAlign.center,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        RepaintBoundary(
                          child: ChatEventTile(
                            key: ValueKey('${event.eventId}column'),
                            event: event,
                            eventPosition: event.getEventPosition(
                              prev: previous,
                              next: next,
                              showAvatarChanges: showAvatarChanges,
                              showDisplayNameChanges: showDisplayNameChanges,
                            ),
                            onReplyOriginClick: (event) => _jump(event),
                            timeline: widget.timeline,
                          ),
                        ),
                      ],

                      if (!widget.timeline.room.isSpace && i == 0)
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
        if (pinnedEvents.isNotEmpty)
          Positioned(
            right: kBigPadding,
            top: kBigPadding,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: FloatingActionButton.small(
                shape: circleBorder,
                backgroundColor: fabBgColor,
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) =>
                      ChatRoomPinnedEventsDialog(timeline: widget.timeline),
                ),
                child: Icon(YaruIcons.pin, color: fapFgColor),
              ),
            ),
          ),
        if (canRequestHistory)
          Positioned(
            right: kBigPadding,
            top: pinnedEvents.isNotEmpty ? 4 * kBigPadding : kBigPadding,
            child: FloatingActionButton.small(
              heroTag: 'historyRequestButtonTag',
              tooltip: context.l10n.loadMore,
              backgroundColor: fabBgColor,
              shape: circleBorder,
              onPressed: isRequestingHistory
                  ? null
                  : () => di<TimelineManager>()
                        .getRequestHistoryCommand(widget.timeline.room.id)
                        .run((
                          timeline: widget.timeline,
                          historyCount: 50,
                          filter: null,
                        )),
              child: isRequestingHistory
                  ? const SizedBox.square(
                      dimension: 18,
                      child: Progress(strokeWidth: 2),
                    )
                  : Icon(YaruIcons.history, color: fapFgColor),
            ),
          ),
        if (_showScrollButton)
          Positioned(
            right: kBigPadding,
            bottom: kBigPadding,
            child: FloatingActionButton.small(
              backgroundColor: fabBgColor,
              shape: circleBorder,
              child: Icon(YaruIcons.go_down, color: fapFgColor),
              onPressed: () => _maybeScrollTo(
                0,
                duration: const Duration(milliseconds: 100),
              ),
            ),
          ),
      ],
    );
  }

  bool onScroll(ScrollEndNotification scrollEnd) {
    final metrics = scrollEnd.metrics;
    if (metrics.atEdge) {
      final isAtBottom = metrics.pixels != 0;
      if (isAtBottom) {
        di<TimelineManager>()
            .getRequestHistoryCommand(widget.timeline.room.id)
            .run((timeline: widget.timeline, historyCount: 150, filter: null));
      } else {
        setState(() => _showScrollButton = false);
      }
    } else {
      setState(() => _showScrollButton = true);
    }
    return true;
  }

  Future<void> _jump(Event event) async {
    final eventInTimeline = widget.timeline.events.firstWhereOrNull(
      (timelineEvent) => timelineEvent.eventId == event.eventId,
    );

    var index = eventInTimeline == null
        ? -1
        : widget.timeline.events.indexOf(eventInTimeline);

    while (index == -1 && retryCount >= 0) {
      await di<TimelineManager>()
          .getRequestHistoryCommand(widget.timeline.room.id)
          .runAsync((timeline: widget.timeline, historyCount: 5, filter: null));
      index = widget.timeline.events.indexOf(event);
      retryCount--;
    }
    await _maybeScrollTo(index);
    if (!widget.timeline.room.isArchived) {
      await di<TimelineManager>().trySetReadMarker(
        widget.timeline,
        eventId: event.eventId,
      );
    }
  }

  Future<dynamic> _maybeScrollTo(int index, {Duration? duration}) async {
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
