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
      canChangeName ||
      canChangeTopic ||
      canChangeStateEvent(EventTypes.RoomAliases) ||
      canChangeStateEvent(EventTypes.RoomJoinRules) ||
      canChangeStateEvent(EventTypes.RoomPowerLevels);

  bool get canChangeName => canChangeStateEvent(EventTypes.RoomName);

  bool get canChangeTopic => canChangeStateEvent(EventTypes.RoomTopic);

  bool get isUnacceptedDirectChat {
    if (isDirectChat) {
      return getParticipants()
          .where((p) => p.membership == Membership.invite)
          .isNotEmpty;
    }
    return false;
  }

  Set<Profile> getProfiles([
    List<Membership> membershipFilter = const [
      Membership.join,
      Membership.invite,
      Membership.knock,
    ],
  ]) => getParticipants(membershipFilter)
      .where((e) {
        final id = e.id.split(':').firstOrNull?.replaceAll('@', '');

        return id?.isNotEmpty == true;
      })
      .map(
        (e) => Profile(
          userId: e.id.split(':').firstOrNull!.replaceAll('@', ''),
          avatarUrl: e.avatarUrl,
        ),
      )
      .toSet();
}
