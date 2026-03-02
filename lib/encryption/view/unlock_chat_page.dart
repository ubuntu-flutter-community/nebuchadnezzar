import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
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
import 'key_verification_dialog.dart';

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
    final theme = context.theme;
    final l10n = context.l10n;

    callOnceAfterThisBuild(
      (context) =>
          di<EncryptionManager>().loadRecoveryKeyFromSecureStorageCommand.run(),
    );

    registerGlobalChatHandlers();

    final recoveryKeyInputLoading = watchValue(
      (EncryptionManager m) =>
          m.loadRecoveryKeyFromSecureStorageCommand.isRunning,
    );

    final recoveryKeyInputError = watchValue(
      (EncryptionManager m) => m.restoreCryptoIdentityCommand.results.select(
        (e) => e.error?.toString(),
      ),
    );

    registerHandler(
      select: (EncryptionManager m) => m.restoreCryptoIdentityCommand.results,
      handler: (context, newValue, cancel) {
        if (newValue.hasData) {
          final result = newValue.data!;
          if (result.connected && result.initialized) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const ChatMasterDetailPage()),
              (route) => false,
            );
          }
        }
      },
    );

    final isBootstrapping = watchValue(
      (EncryptionManager m) => m.restoreCryptoIdentityCommand.isRunning,
    );

    return Scaffold(
      appBar: const YaruWindowTitleBar(
        border: BorderSide.none,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: isBootstrapping
            ? const Progress()
            : SizedBox(
                width: 400,
                child: ListView(
                  shrinkWrap: true,
                  children: space(
                    heightGap: kBigPadding,
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        trailing: Icon(
                          YaruIcons.information,
                          color: theme.colorScheme.primary,
                        ),
                        subtitle: Text(l10n.pleaseEnterRecoveryKeyDescription),
                      ),
                      TextField(
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
                                  _recoveryKeyTextEditingController.text.isEmpty
                              ? null
                              : () => di<EncryptionManager>()
                                    .restoreCryptoIdentityCommand
                                    .run((
                                      keyIdentifier: null,
                                      keyOrPassphrase:
                                          _recoveryKeyTextEditingController.text
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
                      ElevatedButton.icon(
                        icon: const Icon(YaruIcons.sync),
                        label: Text(l10n.transferFromAnotherDevice),
                        onPressed: recoveryKeyInputLoading
                            ? null
                            : () async {
                                if (context.mounted) {
                                  final req = await showFutureLoadingDialog(
                                    context: context,
                                    future: di<EncryptionManager>()
                                        .startKeyVerification,
                                  );
                                  if (context.mounted) {
                                    if (req.error != null) return;
                                    await KeyVerificationDialog(
                                      request: req.result!,
                                      verifyOther: false,
                                    ).show(context);
                                  }
                                }
                              },
                      ),
                      InitCryptoIdentityButton(
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
