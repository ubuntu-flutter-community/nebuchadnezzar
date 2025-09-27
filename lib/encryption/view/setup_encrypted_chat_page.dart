import 'package:flutter/material.dart';
import 'package:matrix/encryption.dart';
import 'package:watch_it/watch_it.dart';

import '../../app/view/splash_page.dart';
import '../../authentication/authentication_service.dart';
import '../../authentication/view/uia_request_handler.dart';
import '../../chat_master/view/chat_master_detail_page.dart';
import '../../l10n/l10n.dart';
import '../encryption_manager.dart';
import 'encryption_setup_error_page.dart';
import 'new_key_created_page.dart';
import 'unlock_chat_page.dart';

class SetupEncryptedChatPage extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const SetupEncryptedChatPage({super.key});

  @override
  State<SetupEncryptedChatPage> createState() => _SetupEncryptedChatPageState();
}

class _SetupEncryptedChatPageState extends State<SetupEncryptedChatPage> {
  @override
  void initState() {
    super.initState();
    di<EncryptionManager>().startBootstrap(wipe: false);
  }

  @override
  Widget build(BuildContext context) {
    registerStreamHandler(
      select: (AuthenticationService m) => m.onUiaRequestStream,
      handler: (context, newValue, cancel) async {
        if (newValue.hasData) {
          await uiaRequestHandler(
            uiaRequest: newValue.data!,
            context: context,
            rootNavigator: true,
          );
        }
      },
    );

    final recoveryKeyStored = watchPropertyValue(
      (EncryptionManager m) => m.recoveryKeyStored,
    );

    final key = watchPropertyValue((EncryptionManager m) => m.key);

    if (key != null && recoveryKeyStored == false) {
      return NewKeyCreatedPage(encryptionKey: key);
    }

    final bootstrapState = watchPropertyValue(
      (EncryptionManager m) => m.bootstrap?.state,
    );

    return switch (bootstrapState) {
      BootstrapState.openExistingSsss => const UnlockChatPage(),
      BootstrapState.done => const ChatMasterDetailPage(),
      BootstrapState.error => const EncryptionSetupErrorPage(),
      _ => SplashPage(title: Text(context.l10n.loadingPleaseWait)),
    };
  }
}
