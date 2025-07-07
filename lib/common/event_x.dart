import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:yaru/yaru.dart';

extension EventX on Event {
  bool get isImage => messageType == MessageTypes.Image;
  bool get isSvgImage => attachmentMimetype == 'image/svg+xml';

  String? get fileDescription {
    if (!{MessageTypes.File, MessageTypes.Image}.contains(messageType)) {
      return null;
    }
    final formattedBody = content.tryGet<String>('formatted_body');
    if (formattedBody != null) return formattedBody;

    final filename = content.tryGet<String>('filename');
    final body = content.tryGet<String>('body');
    if (filename != body && body != null && filename != null) return body;
    return null;
  }

  bool get showAsBadge =>
      type.contains('m.call.') ||
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

  bool get isCallEvent => type.contains('m.call.');

  bool get isUserEvent => room.client.userID == senderId;

  // TODO: #6
  IconData get callIconData => switch (type) {
    'm.call.invite' => YaruIcons.call_outgoing,
    'm.call.answer' => YaruIcons.call_start,
    'm.call.candidates' => YaruIcons.call_start,
    'm.call.hangup' => YaruIcons.call_stop,
    'm.call.select_answer' => YaruIcons.call_start,
    'm.call.reject' => YaruIcons.call_stop,
    'm.call.negotiate' => YaruIcons.call_start,
    'm.call.replaces' => YaruIcons.call_start,
    'm.call.asserted_identity' => YaruIcons.call_start,
    _ => YaruIcons.error,
  };

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

    if ({
      RelationshipTypes.edit,
      RelationshipTypes.reaction,
    }.contains(relationshipType)) {
      return true;
    }

    return {EventTypes.Redaction, EventTypes.Reaction}.contains(type);
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
      room.setPinnedEvents([...room.pinnedEventIds, eventId]);
    }
  }
}
