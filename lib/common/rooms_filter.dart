import 'package:matrix/matrix.dart';

import '../l10n/app_localizations.dart';

enum RoomsFilter {
  directChat,
  spaces,
  unread,
  privateGroups,
  publicRooms;

  bool Function(Room) get filter => switch (this) {
        directChat => (r) => r.isDirectChat,
        unread => (r) => r.isUnreadOrInvited,
        privateGroups => (r) => !r.isDirectChat && r.encrypted,
        publicRooms => (r) => !r.isDirectChat && !r.encrypted && !r.isSpace,
        spaces => (r) => r.isSpace,
      };

  String localize(AppLocalizations l10n) => switch (this) {
        directChat => l10n.directChats,
        unread => l10n.unread,
        privateGroups => '${l10n.encrypted} ${l10n.groups}',
        publicRooms => l10n.publicRooms,
        spaces => l10n.spaces,
      };
}
