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
      select: (EncryptionManager m) => m.initCryptoIdentityCommand.results,
      handler: (context, newValue, cancel) {
        if (newValue.error != null) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => EncryptionSetupErrorPage(error: newValue.error),
            ),
            (route) => false,
          );
        } else if (newValue.data != null) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) =>
                  NewKeyCreatedPage(encryptionKey: newValue.data!),
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
