import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import '../../../common/date_time_x.dart';
import '../../../common/view/build_context_x.dart';
import '../../../l10n/l10n.dart';
import '../../event_x.dart';
import '../chat_room/chat_seen_by_indicator.dart';
import 'chat_event_tile.dart';

class ChatEventColumn extends StatelessWidget {
  const ChatEventColumn({
    super.key,
    required this.event,
    this.maybePreviousEvent,
    required this.jump,
    required this.showSeenByIndicator,
    required this.timeline,
    required this.room,
  });

  final Event event;
  final Timeline timeline;
  final Room room;
  final Event? maybePreviousEvent;
  final Future<void> Function(Event event) jump;
  final bool showSeenByIndicator;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (maybePreviousEvent != null &&
            event.originServerTs.toLocal().day !=
                maybePreviousEvent?.originServerTs.toLocal().day)
          Text(
            maybePreviousEvent!.originServerTs
                .toLocal()
                .formatAndLocalizeDay(context.l10n),
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall,
          ),
        if (!hideEventInTimeline(event: event))
          ChatEventTile(
            event: event,
            timeline: timeline,
            onReplyOriginClick: jump,
            partOfMessageCohort: _partOfMessageCohort(
              event,
              maybePreviousEvent,
            ),
          ),
        if (showSeenByIndicator)
          ChatSeenByIndicator(
            room: room,
            timeline: timeline,
          ),
      ],
    );
  }

  bool hideEventInTimeline({required Event event}) {
    if ({RelationshipTypes.edit, RelationshipTypes.reaction}
        .contains(event.relationshipType)) {
      return true;
    }

    return {
      EventTypes.Redaction,
      EventTypes.Reaction,
    }.contains(event.type);
  }

  bool _partOfMessageCohort(Event event, Event? maybePreviousEvent) {
    return maybePreviousEvent != null &&
        !maybePreviousEvent.showAsBadge &&
        !maybePreviousEvent.isImage &&
        maybePreviousEvent.senderId == event.senderId;
  }
}
