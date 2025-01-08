import 'package:matrix/matrix.dart';

extension RoomX on Room {
  List<User> getSeenByUsers(List<Event> events, {String? eventId}) {
    if (events.isEmpty) return [];
    eventId ??= events.first.eventId;

    final lastReceipts = <User>{};
    for (final e in events) {
      lastReceipts.addAll(
        e.receipts.map((r) => r.user).where(
              (u) => u.id != client.userID && u.id != events.first.senderId,
            ),
      );
      if (e.eventId == eventId) {
        break;
      }
    }

    return lastReceipts.toList();
  }

  bool get canEdit =>
      ownPowerLevel == 100 ||
      canKick ||
      canBan ||
      canChangeGuestAccess ||
      canChangeHistoryVisibility ||
      canChangeJoinRules ||
      canInvite ||
      canRedact ||
      canChangeStateEvent(EventTypes.RoomName) ||
      canChangeStateEvent(EventTypes.RoomAliases) ||
      canChangeStateEvent(EventTypes.RoomJoinRules) ||
      canChangeStateEvent(EventTypes.RoomPowerLevels);
}
