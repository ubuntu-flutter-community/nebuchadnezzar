import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';

import '../../../common/date_time_x.dart';
import '../../../common/view/build_context_x.dart';
import '../../../l10n/l10n.dart';
import '../../common/event_x.dart';
import '../../settings/settings_model.dart';
import 'chat_event_tile.dart';

class ChatEventColumn extends StatelessWidget with WatchItMixin {
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
    final showChatAvatarChanges =
        watchPropertyValue((SettingsModel m) => m.showChatAvatarChanges);
    final showChatDisplaynameChanges =
        watchPropertyValue((SettingsModel m) => m.showChatDisplaynameChanges);

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
        if (!hideEventInTimeline(
          event: event,
          showAvatarChanges: showChatAvatarChanges,
          showDisplayNameChanges: showChatDisplaynameChanges,
        ))
          ChatEventTile(
            event: event,
            timeline: timeline,
            onReplyOriginClick: jump,
            partOfMessageCohort: _partOfMessageCohort(
              event,
              maybePreviousEvent,
            ),
          ),
      ],
    );
  }

  bool hideEventInTimeline({
    required Event event,
    required bool showAvatarChanges,
    required bool showDisplayNameChanges,
  }) {
    if (event.type == EventTypes.RoomMember &&
        event.roomMemberChangeType == RoomMemberChangeType.avatar &&
        !showAvatarChanges) {
      return true;
    }
    if (event.type == EventTypes.RoomMember &&
        event.roomMemberChangeType == RoomMemberChangeType.displayname &&
        !showDisplayNameChanges) {
      return true;
    }

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
