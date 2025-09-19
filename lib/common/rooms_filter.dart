import 'package:flutter/widgets.dart';
import 'package:matrix/matrix.dart';
import 'package:yaru/yaru.dart';

import '../l10n/app_localizations.dart';

enum RoomsFilter {
  spaces,
  directChat,
  publicRooms,
  unread;

  bool Function(Room) get filter => switch (this) {
    directChat => (r) => r.isDirectChat,
    unread => (r) => r.isUnreadOrInvited,

    publicRooms => (r) => !r.isDirectChat && !r.encrypted && !r.isSpace,
    spaces => (r) => r.isSpace,
  };

  static List<RoomsFilter> get shownValues => values;

  IconData get iconData => switch (this) {
    directChat => YaruIcons.user,
    unread => YaruIcons.mail_unread,

    publicRooms => YaruIcons.users,
    spaces => YaruIcons.globe,
  };

  String localize(AppLocalizations l10n) => switch (this) {
    directChat => l10n.directChats,
    unread => l10n.unread,

    publicRooms => l10n.publicRooms,
    spaces => l10n.spaces,
  };
}
