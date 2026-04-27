import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';

import '../../app/view/splash_page.dart';
import '../../common/view/build_context_x.dart';
import '../../l10n/l10n.dart';
import '../encryption_manager.dart';
import 'chat_global_handlers.dart';
import 'encryption_setup_error_page.dart';
import 'new_key_created_page.dart';

class InitCryptoIdentityProgressPage extends StatelessWidget
    with WatchItMixin, ChatGlobalHandlerMixin {
  const InitCryptoIdentityProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    registerGlobalChatHandlers();

    registerHandler(
      select: (EncryptionManager m) => m.initCryptoIdentityCommand.results,
      handler: (context, results, cancel) {
        if (results.error != null) {
          context.teleport(
            (context) => EncryptionSetupErrorPage(error: results.error!),
          );
        } else if (results.data != null) {
          context.teleport(
            (context) => NewKeyCreatedPage(encryptionKey: results.data!),
          );
        }
      },
    );

    return SplashPage(
      title: Text(context.l10n.initializingCryptoIdentityPleaseWait),
    );
  }
}
