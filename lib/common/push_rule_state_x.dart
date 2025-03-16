import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:yaru/yaru.dart';

import '../l10n/l10n.dart';

extension PushRuleStateX on PushRuleState {
  String localize(AppLocalizations l10n) => switch (this) {
        PushRuleState.dontNotify => l10n.muteChat,
        PushRuleState.notify => l10n.unmuteChat,
        PushRuleState.mentionsOnly => l10n.mention,
      };

  Icon getIcon(ColorScheme colorScheme) => switch (this) {
        PushRuleState.mentionsOnly => const Icon(YaruIcons.notification_filled),
        PushRuleState.notify => Icon(
            YaruIcons.notification_filled,
            color: colorScheme.primary,
          ),
        PushRuleState.dontNotify => const Icon(YaruIcons.notification),
      };
}
