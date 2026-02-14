import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:yaru/yaru.dart';

import '../l10n/app_localizations.dart';

extension EventX on Event {
  bool get isImage => messageType == MessageTypes.Image && !isSvgImage;
  bool get isFile => messageType == MessageTypes.File;
  bool get isVideo => messageType == MessageTypes.Video;
  bool get isAudio => messageType == MessageTypes.Audio;
  bool get isText => messageType == MessageTypes.Text;
  bool get isLocation => messageType == MessageTypes.Location;
  bool get isSticker => messageType == MessageTypes.Sticker;
  bool get isSvgImage => attachmentMimetype == 'image/svg+xml';

  String? get fileDescription {
    if (!{
      MessageTypes.File,
      MessageTypes.Image,
      MessageTypes.Video,
      MessageTypes.Audio,
    }.contains(messageType)) {
      return null;
    }
    final formattedBody = content.tryGet<String>('formatted_body');
    if (formattedBody != null) return formattedBody;

    final filename = content.tryGet<String>('filename');
    final body = content.tryGet<String>('body');
    if (filename != body && body != null && filename != null) return body;
    return null;
  }

  int? get fileSize {
    if (!{
      MessageTypes.File,
      MessageTypes.Image,
      MessageTypes.Video,
      MessageTypes.Audio,
    }.contains(messageType)) {
      return null;
    }
    return content.tryGet<Map<String, dynamic>>('info')?.tryGet<int>('size');
  }

  String? get fileName {
    if (!{
      MessageTypes.File,
      MessageTypes.Image,
      MessageTypes.Video,
      MessageTypes.Audio,
    }.contains(messageType)) {
      return null;
    }
    final filename = content.tryGet<String>('filename');
    if (filename != null) return filename;

    final body = content.tryGet<String>('body');
    if (body != null) return body;

    final url = content.tryGet<String>('url');
    if (url != null) {
      final uri = Uri.tryParse(url);
      if (uri != null) {
        return uri.pathSegments.isNotEmpty ? uri.pathSegments.last : url;
      }
      return url;
    }
    return null;
  }

  String getCustomLocalizationOrFallback({
    required AppLocalizations l10n,
    MatrixLocalizations? i18n,
  }) {
    i18n ??= i18n = const MatrixDefaultLocalizations();

    if (type == EventTypes.RoomPinnedEvents) {
      return 'Event was pinned';
    }

    final maybeSpaceChildOrParentId =
        '${stateKey?.isNotEmpty == true && room.client.getRoomById(stateKey!) != null ? room.client.getRoomById(stateKey!)?.getLocalizedDisplayname() : l10n.unavailable}';
    if (type == 'm.space.parent') {
      return '${l10n.space}: $maybeSpaceChildOrParentId';
    } else if (type == 'm.space.child') {
      final membership = unsigned?['membership'] as String?;
      final via = content['via'] as List<dynamic>?;

      if (membership == 'join' && via?.isEmpty == true) {
        return 'Chat has been removed from this space ${maybeSpaceChildOrParentId == l10n.unavailable ? '' : ': $maybeSpaceChildOrParentId'}';
      }

      return '${l10n.chatHasBeenAddedToThisSpace}${maybeSpaceChildOrParentId == l10n.unavailable ? '' : ': $maybeSpaceChildOrParentId'}';
    }

    return calcLocalizedBodyFallback(i18n);
  }

  bool get showAsSpecialBadge => {
    'm.space.parent',
    'm.space.child',
    EventTypes.RoomPinnedEvents,
  }.contains(type);

  bool get showAsBubble => type == EventTypes.Message;

  bool get showAsBadge => !showAsBubble;

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

  bool get isPartOfThread => relationshipType == RelationshipTypes.thread;

  bool hideInTimeline({
    required bool showAvatarChanges,
    required bool showDisplayNameChanges,
  }) {
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
      RelationshipTypes.thread,
    }.contains(relationshipType)) {
      return true;
    }

    return {
      EventTypes.Redaction,
      EventTypes.Reaction,
      'm.room.server_acl',
    }.contains(type);
  }

  EventPosition getEventPosition({
    required Event? prev,
    required Event? next,
    required bool showAvatarChanges,
    required bool showDisplayNameChanges,
  }) {
    final prevHidden =
        prev?.hideInTimeline(
          showAvatarChanges: showAvatarChanges,
          showDisplayNameChanges: showDisplayNameChanges,
        ) ??
        true;
    final nextHidden =
        next?.hideInTimeline(
          showAvatarChanges: showAvatarChanges,
          showDisplayNameChanges: showDisplayNameChanges,
        ) ??
        true;

    final prevFromOtherDay =
        !prevHidden &&
        prev != null &&
        prev.originServerTs.toLocal().day != originServerTs.toLocal().day;

    final nextFromOtherDay =
        !nextHidden &&
        next != null &&
        next.originServerTs.toLocal().day != originServerTs.toLocal().day;

    final prevBadge = !prevHidden && (prev?.showAsBadge ?? false);
    final nextBadge = !nextHidden && (next?.showAsBadge ?? false);

    final prevSameSender = !prevHidden && (prev?.senderId == senderId);
    final nextSameSender = !nextHidden && (next?.senderId == senderId);

    if (prevHidden || prevFromOtherDay || prevBadge || !prevSameSender) {
      if (nextFromOtherDay || nextHidden || nextBadge || !nextSameSender) {
        return EventPosition.single;
      }
      return EventPosition.top;
    } else {
      if (nextFromOtherDay || nextHidden || nextBadge || !nextSameSender) {
        return EventPosition.bottom;
      }
      return EventPosition.middle;
    }
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
      final newPinned = List<String>.from(room.pinnedEventIds)..remove(eventId);
      await room.setPinnedEvents(newPinned);
    } else {
      await room.setPinnedEvents([...room.pinnedEventIds, eventId]);
    }
  }

  bool get isEncryptedAndCouldDecrypt =>
      (type == EventTypes.Encrypted && type != MessageTypes.BadEncrypted) &&
      content['can_request_session'] == true;

  List<User> get seenByUsers => receipts
      .map((e) => e.user)
      .where((e) => e.id != room.client.userID)
      .toList();
}

enum EventPosition { top, bottom, middle, single }
