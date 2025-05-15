import 'package:flutter/material.dart';
import 'package:matrix/encryption.dart';
import 'package:watch_it/watch_it.dart';

import '../../app/view/splash_page.dart';
import '../../authentication/authentication_model.dart';
import '../../authentication/view/uia_request_handler.dart';
import '../../l10n/l10n.dart';
import '../encryption_model.dart';
import 'encryption_setup_done_page.dart';
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
    di<EncryptionModel>().startBootstrap(wipe: false);
  }

  @override
  Widget build(BuildContext context) {
    registerStreamHandler(
      select: (AuthenticationModel m) => m.onUiaRequestStream,
      handler: (context, newValue, cancel) {
        if (newValue.hasData) {
          uiaRequestHandler(uiaRequest: newValue.data!, context: context);
        }
      },
    );

    final bootstrap = watchPropertyValue((EncryptionModel m) => m.bootstrap);
    final bootstrapState = watchPropertyValue(
      (EncryptionModel m) => m.bootstrap?.state,
    );

    final wipe = watchPropertyValue((EncryptionModel m) => m.wipe);
    final recoveryKeyStored = watchPropertyValue(
      (EncryptionModel m) => m.recoveryKeyStored,
    );

    final key = watchPropertyValue((EncryptionModel m) => m.key);

    if (key != null && recoveryKeyStored == false) {
      return NewKeyCreatedPage(
        encryptionKey: key,
      );
    }

    switch (bootstrapState) {
      case BootstrapState.loading || null:
        return SplashPage(title: Text(context.l10n.synchronizingPleaseWait));
      case BootstrapState.askWipeSsss:
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => bootstrap?.wipeSsss(wipe),
        );
      case BootstrapState.askBadSsss:
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => bootstrap?.ignoreBadSecrets(true),
        );
      case BootstrapState.askUseExistingSsss:
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => bootstrap?.useExistingSsss(!wipe),
        );
      case BootstrapState.askUnlockSsss:
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => bootstrap?.unlockedSsss(),
        );
      case BootstrapState.askNewSsss:
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => bootstrap?.newSsss(),
        );
      case BootstrapState.openExistingSsss:
        di<EncryptionModel>().setRecoveryKeyStored(true);
        return const UnlockChatPage();
      case BootstrapState.askWipeCrossSigning:
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => bootstrap?.wipeCrossSigning(wipe),
        );
      case BootstrapState.askSetupCrossSigning:
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => bootstrap?.askSetupCrossSigning(
            setupMasterKey: true,
            setupSelfSigningKey: true,
            setupUserSigningKey: true,
          ),
        );
      case BootstrapState.askWipeOnlineKeyBackup:
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => bootstrap?.wipeOnlineKeyBackup(wipe),
        );

      case BootstrapState.askSetupOnlineKeyBackup:
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => bootstrap?.askSetupOnlineKeyBackup(true),
        );

      case BootstrapState.done:
        return const EncryptionSetupDonePage();

      case BootstrapState.error:
        return const EncryptionSetupErrorPage();
    }

    return SplashPage(title: Text(context.l10n.synchronizingPleaseWait));
  }
}
