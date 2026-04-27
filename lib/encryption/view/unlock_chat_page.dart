import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../chat_master/view/chat_master_detail_page.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/common_widgets.dart';
import '../../common/view/space.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../../settings/view/chat_settings_logout_button.dart';
import '../encryption_manager.dart';
import 'chat_global_handlers.dart';
import 'init_crypto_identity_button.dart';
import 'unlock_from_other_devices_button.dart';

class UnlockChatPage extends StatefulWidget with WatchItStatefulWidgetMixin {
  const UnlockChatPage({super.key});

  @override
  State<UnlockChatPage> createState() => _UnlockChatPageState();
}

class _UnlockChatPageState extends State<UnlockChatPage>
    with ChatGlobalHandlerMixin {
  final TextEditingController _recoveryKeyTextEditingController =
      TextEditingController();

  @override
  void dispose() {
    _recoveryKeyTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    registerGlobalChatHandlers();

    registerHandler(
      select: (EncryptionManager m) => m.restoreCryptoIdentityCommand.results,
      handler: (context, newValue, cancel) {
        if (newValue.hasData) {
          final result = newValue.data!;
          if (result.connected && result.initialized) {
            context.teleport((_) => const ChatMasterDetailPage());
          }
        }
      },
    );

    final l10n = context.l10n;

    final cryptoIdentityInitialized = watchValue(
      (EncryptionManager m) => m.checkIfEncryptionSetupIsNeededCommand.select(
        (cryptoIdentityState) => cryptoIdentityState?.initialized ?? false,
      ),
    );

    final recoveryKeyResults = watchValue(
      (EncryptionManager m) =>
          m.loadRecoveryKeyFromSecureStorageCommand.results,
    );

    final recoveryKeyInputLoading = recoveryKeyResults.isRunning;

    final recoveryKeyInputError =
        recoveryKeyResults.hasError && !recoveryKeyInputLoading
        ? recoveryKeyResults.error?.toString()
        : null;

    final isRestoringCryptoIdentity = watchValue(
      (EncryptionManager m) => m.restoreCryptoIdentityCommand.isRunning,
    );

    return Scaffold(
      appBar: const YaruWindowTitleBar(
        border: BorderSide.none,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: isRestoringCryptoIdentity
            ? const Progress()
            : SizedBox(
                width: 400,
                child: ListView(
                  shrinkWrap: true,
                  children: space(
                    heightGap: kBigPadding,
                    children: [
                      if (cryptoIdentityInitialized) ...[
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                          ),
                          trailing: Icon(
                            YaruIcons.information,
                            color: context.colorScheme.primary,
                          ),
                          subtitle: Text(
                            l10n.pleaseEnterRecoveryKeyDescription,
                          ),
                        ),
                        TextField(
                          onChanged: (_) => di<EncryptionManager>()
                              .loadRecoveryKeyFromSecureStorageCommand
                              .clearErrors(),
                          controller: _recoveryKeyTextEditingController,
                          minLines: 1,
                          maxLines: 2,
                          autocorrect: false,
                          readOnly: recoveryKeyInputLoading,
                          autofillHints: recoveryKeyInputLoading
                              ? null
                              : [AutofillHints.password],
                          style: const TextStyle(fontFamily: 'UbuntuMono'),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(YaruIcons.key),
                            labelText: l10n.recoveryKey,
                            hintText: 'Es** **** **** ****',
                            errorText: recoveryKeyInputError != null
                                ? l10n.wrongRecoveryKey
                                : null,
                            errorMaxLines: 2,
                          ),
                        ),
                        ListenableBuilder(
                          listenable: _recoveryKeyTextEditingController,
                          builder: (context, child) => ElevatedButton.icon(
                            icon: recoveryKeyInputLoading
                                ? const Progress()
                                : const Icon(Icons.lock_open_outlined),
                            label: Text(l10n.unlockOldMessages),
                            onPressed:
                                recoveryKeyInputLoading ||
                                    _recoveryKeyTextEditingController
                                        .text
                                        .isEmpty
                                ? null
                                : () => di<EncryptionManager>()
                                      .restoreCryptoIdentityCommand
                                      .run((
                                        keyIdentifier: null,
                                        keyOrPassphrase:
                                            _recoveryKeyTextEditingController
                                                .text
                                                .trim(),
                                        selfSign: true,
                                      )),
                          ),
                        ),
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(l10n.or),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        UnlockFromOtherDevicesButton(
                          recoveryKeyInputLoading: recoveryKeyInputLoading,
                        ),
                      ],
                      InitCryptoIdentityButton(
                        label: cryptoIdentityInitialized
                            ? null
                            : l10n.createRecoveryKey,
                        loading: recoveryKeyInputLoading,
                      ),
                      const ChatSettingsLogoutButton(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
