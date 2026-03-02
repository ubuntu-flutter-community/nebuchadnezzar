import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';

import '../../app/view/splash_page.dart';
import '../../l10n/l10n.dart';
import '../encryption_manager.dart';
import 'encryption_setup_error_page.dart';
import 'new_key_created_page.dart';

class InitCryptoIdentifyProgressPage extends StatelessWidget with WatchItMixin {
  const InitCryptoIdentifyProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    registerHandler(
      select: (EncryptionManager m) => m.newSsssKeyNotifier,
      handler: (context, newSsssKey, cancel) {
        if (newSsssKey != null) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) =>
                  NewKeyCreatedPage(encryptionKey: newSsssKey),
            ),
            (route) => false,
          );
        }
      },
    );

    registerHandler(
      select: (EncryptionManager m) => m.initCryptoIdentityCommandSync.results,
      handler: (context, results, cancel) {
        if (results.error != null) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) =>
                  EncryptionSetupErrorPage(error: results.error!),
            ),
            (route) => false,
          );
        }
      },
    );

    return SplashPage(
      title: Text(context.l10n.initializingCryptoIdentityPleaseWait),
    );
  }
}
