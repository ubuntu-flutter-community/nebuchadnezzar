import 'package:matrix/matrix.dart';

extension RoomX on Room {
  bool get canChangeAnyRoomSetting =>
      canSendDefaultMessages &&
      (ownPowerLevel == 100 ||
          canKick ||
          canBan ||
          canChangeGuestAccess ||
          canChangeHistoryVisibility ||
          canChangeJoinRules ||
          canInvite ||
          canRedact ||
          canChangeName ||
          canChangeTopic ||
          canChangeRoomAlias ||
          canEditSpace ||
          canChangePowerLevel ||
          canChangeCanonicalAlias ||
          canChangeAvatar);

  bool get canChangeJoinRules => canChangeStateEvent(EventTypes.RoomJoinRules);

  bool get canChangeRoomAlias => canChangeStateEvent(EventTypes.RoomAliases);

  bool get canChangeName => canChangeStateEvent(EventTypes.RoomName);

  bool get canChangeTopic => canChangeStateEvent(EventTypes.RoomTopic);

  bool get canEditSpace => canChangeStateEvent(EventTypes.SpaceChild);

  bool get canChangeCanonicalAlias =>
      canChangeStateEvent(EventTypes.RoomCanonicalAlias);

  bool get canChangeAvatar => canChangeStateEvent(EventTypes.RoomAvatar);

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
