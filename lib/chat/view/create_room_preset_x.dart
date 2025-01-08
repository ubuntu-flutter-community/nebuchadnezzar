import 'package:matrix/matrix.dart';

import '../../l10n/l10n.dart';

extension CreateRoomPresetX on CreateRoomPreset {
  String localize(AppLocalizations l10n) => switch (this) {
        // TODO: localize
        CreateRoomPreset.privateChat => 'Trusted Private Chat',
        CreateRoomPreset.publicChat => 'Public Chat',
        CreateRoomPreset.trustedPrivateChat => 'Trusted Private Chat',
      };
}
