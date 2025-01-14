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
}
