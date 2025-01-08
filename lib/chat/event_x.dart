import 'package:matrix/matrix.dart';

extension EventX on Event {
  bool get isImage => messageType == MessageTypes.Image;

  bool get showAsBadge => {
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
}
