import 'package:matrix/matrix.dart';

extension RoomX on Room {
  bool get canEditAtleastSomething =>
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

  bool get isUnacceptedDirectChat {
    if (isDirectChat) {
      return getParticipants()
          .where((p) => p.membership == Membership.invite)
          .isNotEmpty;
    }
    return false;
  }
}
