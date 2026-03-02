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

    return watchValue(
      (EncryptionManager m) => m.checkIfEncryptionSetupIsNeededCommand.results,
    ).toWidget(
      onError: (error, _, _) => EncryptionSetupErrorPage(error: error),
      whileRunning: (_, _) =>
          SplashPage(title: Text(context.l10n.checkingEncryptionPleaseWait)),
      onData: (result, param) => result == null
          ? SplashPage(title: Text(context.l10n.checkingEncryptionPleaseWait))
          : result.connected == false || result.initialized == false
          ? const UnlockChatPage()
          : const ChatMasterDetailPage(),
    );
  }
}
