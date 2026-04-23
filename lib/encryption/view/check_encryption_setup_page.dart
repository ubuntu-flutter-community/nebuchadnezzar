import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';

import '../../app/view/splash_page.dart';
import '../../chat_master/view/chat_master_detail_page.dart';
import '../../l10n/l10n.dart';
import '../encryption_manager.dart';
import 'encryption_setup_error_page.dart';
import 'unlock_chat_page.dart';

class CheckEncryptionSetupPage extends StatelessWidget with WatchItMixin {
  const CheckEncryptionSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    callOnceAfterThisBuild(
      (context) =>
          di<EncryptionManager>().checkIfEncryptionSetupIsNeededCommand.run(),
    );

    registerHandler(
      select: (EncryptionManager m) =>
          m.checkIfEncryptionSetupIsNeededCommand.results,
      handler: (context, newValue, cancel) {
        if (newValue.error != null) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => EncryptionSetupErrorPage(error: newValue.error),
            ),
            (route) => false,
          );
        } else if (newValue.data != null) {
          final cryptoIdentityState = newValue.data!;
          if (cryptoIdentityState.connected &&
              cryptoIdentityState.initialized) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const ChatMasterDetailPage()),
              (route) => false,
            );
          } else {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const UnlockChatPage()),
              (route) => false,
            );
          }
        }
      },
    );

    return SplashPage(title: Text(context.l10n.checkingEncryptionPleaseWait));
  }
}
