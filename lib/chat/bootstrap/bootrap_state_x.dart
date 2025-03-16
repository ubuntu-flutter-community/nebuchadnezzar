import 'package:matrix/encryption/utils/bootstrap.dart';

import '../../l10n/app_localizations.dart';

extension BootstrapStateX on BootstrapState {
  String? localize(AppLocalizations l10n) => switch (this) {
        _ => l10n.loadingPleaseWait,
      };
}
