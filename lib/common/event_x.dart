import 'package:matrix/matrix.dart';

extension EventX on Event {
  bool get isImage => messageType == MessageTypes.Image;
  bool get isSvgImage => attachmentMimetype == 'image/svg+xml';

  bool get showAsBadge =>
      messageType == MessageTypes.Emote ||
      {
        EventTypes.RoomAvatar,
        EventTypes.RoomAliases,
        EventTypes.RoomTopic,
        EventTypes.RoomCreate,
        EventTypes.RoomPowerLevels,
        EventTypes.RoomJoinRules,
        EventTypes.HistoryVisibility,
        EventTypes.RoomName,
        EventTypes.RoomMember,
        EventTypes.Unknown,
        EventTypes.GuestAccess,
        EventTypes.Encryption,
      }.contains(type);

  bool hideInTimeline({
    required bool showAvatarChanges,
    required bool showDisplayNameChanges,
  }) {
    if (type == 'm.room.server_acl') {
      return true;
    }
    if (type == EventTypes.RoomPinnedEvents) {
      return true;
    }
    if (type == EventTypes.RoomMember &&
        roomMemberChangeType == RoomMemberChangeType.avatar &&
        !showAvatarChanges) {
      return true;
    }
    if (type == EventTypes.RoomMember &&
        roomMemberChangeType == RoomMemberChangeType.displayname &&
        !showDisplayNameChanges) {
      return true;
    }

    if ({RelationshipTypes.edit, RelationshipTypes.reaction}
        .contains(relationshipType)) {
      return true;
    }

    return {
      EventTypes.Redaction,
      EventTypes.Reaction,
    }.contains(type);
  }

  bool partOfMessageCohort(Event? maybePreviousEvent) {
    return maybePreviousEvent != null &&
        !maybePreviousEvent.showAsBadge &&
        !maybePreviousEvent.isImage &&
        maybePreviousEvent.senderId == senderId;
  }

  Uri? get geoUri {
    final maybe = content.tryGet<String>('geo_uri');
    if (maybe == null) {
      return null;
    }
    return Uri.tryParse(maybe);
  }

  bool get pinned => room.pinnedEventIds.contains(eventId);

  Future<void> togglePinned() async {
    if (pinned) {
      final newPinned = List<String>.from(room.pinnedEventIds);
      newPinned.remove(eventId);
      room.setPinnedEvents(newPinned);
    } else {
      room.setPinnedEvents(
        [
          ...room.pinnedEventIds,
          eventId,
        ],
      );
    }
  }
}
