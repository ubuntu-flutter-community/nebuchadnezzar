import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/encryption.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../chat_master/view/chat_master_detail_page.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/common_widgets.dart';
import '../../common/view/snackbars.dart';
import '../../common/view/space.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../../settings/view/logout_button.dart';
import '../authentication_model.dart';
import 'chat_login_page.dart';
import 'key_verification_dialog.dart';
import 'uia_request_handler.dart';

class CheckBootstrapPage extends StatefulWidget {
  const CheckBootstrapPage({super.key});

  @override
  State<CheckBootstrapPage> createState() => _CheckBootstrapPageState();
}

class _CheckBootstrapPageState extends State<CheckBootstrapPage> {
  late Future<bool> _requireBootstrapInitial;

  @override
  void initState() {
    super.initState();
    _requireBootstrapInitial = di<AuthenticationModel>()
        .checkBootstrap(startBootstrappingIfNeeded: true);
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: _requireBootstrapInitial,
        builder: (context, snapshot) => snapshot.data != false
            ? const _BootstrapPage()
            : const ChatMasterDetailPage(),
      );
}

class _BootstrapPage extends StatelessWidget with WatchItMixin {
  const _BootstrapPage();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final model = di<AuthenticationModel>();

    registerStreamHandler(
      select: (AuthenticationModel m) => m.onUiaRequestStream,
      handler: (context, newValue, cancel) {
        if (newValue.hasData) {
          uiaRequestHandler(uiaRequest: newValue.data!, context: context);
        }
      },
    );

    final bootstrap =
        watchPropertyValue((AuthenticationModel m) => m.bootstrap);
    final bootstrapState =
        watchPropertyValue((AuthenticationModel m) => m.bootstrap?.state);

    final wipe = watchPropertyValue((AuthenticationModel m) => m.wipe);
    final recoveryKeyStored =
        watchPropertyValue((AuthenticationModel m) => m.recoveryKeyStored);
    final recoveryKeyCopied =
        watchPropertyValue((AuthenticationModel m) => m.recoveryKeyCopied);
    final storeInSecureStorage =
        watchPropertyValue((AuthenticationModel m) => m.storeInSecureStorage);
    final key = watchPropertyValue((AuthenticationModel m) => m.key);

    final buttons = <Widget>[];
    Widget body = const Progress();
    var titleText = '';

    if (key != null && recoveryKeyStored == false) {
      return Scaffold(
        appBar: YaruWindowTitleBar(
          border: BorderSide.none,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(YaruIcons.window_close),
            onPressed: Navigator.of(context).pop,
          ),
          title: Text(l10n.recoveryKey),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                  trailing: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      YaruIcons.information,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  subtitle: Text(l10n.chatBackupDescription),
                ),
                const Divider(
                  height: 32,
                  thickness: 1,
                ),
                TextField(
                  minLines: 2,
                  maxLines: 4,
                  readOnly: true,
                  style: const TextStyle(fontFamily: 'UbuntuMono'),
                  controller: TextEditingController(text: key),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(16),
                    suffixIcon: Icon(YaruIcons.key),
                  ),
                ),
                const SizedBox(height: 16),
                YaruCheckboxListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                  value: storeInSecureStorage,
                  onChanged: (v) => model.setStoreInSecureStorage(v ?? false),
                  title: Text(getSecureStorageLocalizedName(context.l10n)),
                  subtitle: Text(l10n.storeInSecureStorageDescription),
                ),
                const SizedBox(height: 16),
                YaruCheckboxListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                  value: recoveryKeyCopied,
                  onChanged: (b) {
                    Clipboard.setData(ClipboardData(text: key));
                    showSnackBar(
                      context,
                      content: Text(l10n.copiedToClipboard),
                    );
                    model.setRecoveryKeyCopied(true);
                  },
                  title: Text(l10n.copyToClipboard),
                  subtitle: Text(l10n.saveKeyManuallyDescription),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(YaruIcons.checkmark),
                  label: Text(l10n.next),
                  onPressed: (recoveryKeyCopied || storeInSecureStorage)
                      ? () => model.storeRecoveryKey()
                      : null,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      if (bootstrapState != null && bootstrap != null) {
        switch (bootstrapState) {
          case BootstrapState.loading:
            break;
          case BootstrapState.askWipeSsss:
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => bootstrap.wipeSsss(wipe),
            );
          case BootstrapState.askBadSsss:
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => bootstrap.ignoreBadSecrets(true),
            );
          case BootstrapState.askUseExistingSsss:
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => bootstrap.useExistingSsss(!wipe),
            );
          case BootstrapState.askUnlockSsss:
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => bootstrap.unlockedSsss(),
            );
          case BootstrapState.askNewSsss:
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => bootstrap.newSsss(),
            );
          case BootstrapState.openExistingSsss:
            model.setRecoveryKeyStored(true);
            return const OpenExistingSSSSPage();
          case BootstrapState.askWipeCrossSigning:
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => bootstrap.wipeCrossSigning(wipe),
            );
          case BootstrapState.askSetupCrossSigning:
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => bootstrap.askSetupCrossSigning(
                setupMasterKey: true,
                setupSelfSigningKey: true,
                setupUserSigningKey: true,
              ),
            );
          case BootstrapState.askWipeOnlineKeyBackup:
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => bootstrap.wipeOnlineKeyBackup(wipe),
            );

          case BootstrapState.askSetupOnlineKeyBackup:
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => bootstrap.askSetupOnlineKeyBackup(true),
            );
          case BootstrapState.error:
            titleText = l10n.oopsSomethingWentWrong;
            body = const Icon(YaruIcons.error, color: Colors.red, size: 80);
            buttons.add(
              OutlinedButton(
                onPressed: () => () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => const ChatLoginPage(),
                      ),
                      (route) => false,
                    ),
                child: Text(l10n.close),
              ),
            );
          case BootstrapState.done:
            titleText = l10n.everythingReady;
            body = Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  YaruIcons.ok_filled,
                  size: 120,
                  color: context.colorScheme.success,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.yourChatBackupHasBeenSetUp,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 16),
              ],
            );
            buttons.add(
              OutlinedButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const ChatMasterDetailPage(),
                  ),
                  (route) => false,
                ),
                child: Text(l10n.close),
              ),
            );
        }
      }
    }

    return Scaffold(
      appBar: YaruWindowTitleBar(
        title: Text(titleText),
        border: BorderSide.none,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            body,
            const SizedBox(height: 8),
            ...buttons,
          ],
        ),
      ),
    );
  }

  String getSecureStorageLocalizedName(AppLocalizations l10n) {
    if (Platform.isAndroid) {
      return l10n.storeInAndroidKeystore;
    }
    if (Platform.isIOS || Platform.isMacOS) {
      return l10n.storeInAppleKeyChain;
    }
    return l10n.storeSecurlyOnThisDevice;
  }
}

class OpenExistingSSSSPage extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const OpenExistingSSSSPage({super.key});

  @override
  State<OpenExistingSSSSPage> createState() => _OpenExistingSSSSPageState();
}

class _OpenExistingSSSSPageState extends State<OpenExistingSSSSPage> {
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
    final model = di<AuthenticationModel>();

    final bootstrap =
        watchPropertyValue((AuthenticationModel m) => m.bootstrap);
    final recoveryKeyInputLoading = watchPropertyValue(
      (AuthenticationModel m) => m.recoveryKeyInputLoading,
    );
    final recoveryKeyInputError =
        watchPropertyValue((AuthenticationModel m) => m.recoveryKeyInputError);

    return Scaffold(
      appBar: const YaruWindowTitleBar(
        border: BorderSide.none,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SizedBox(
          width: 400,
          child: ListView(
            shrinkWrap: true,
            children: space(
              heightGap: kBigPadding,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                  trailing: Icon(
                    YaruIcons.information,
                    color: theme.colorScheme.primary,
                  ),
                  subtitle: Text(
                    l10n.pleaseEnterRecoveryKeyDescription,
                  ),
                ),
                TextField(
                  controller: _recoveryKeyTextEditingController,
                  minLines: 1,
                  maxLines: 2,
                  autocorrect: false,
                  readOnly: recoveryKeyInputLoading,
                  autofillHints:
                      recoveryKeyInputLoading ? null : [AutofillHints.password],
                  style: const TextStyle(fontFamily: 'UbuntuMono'),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(YaruIcons.key),
                    labelText: l10n.recoveryKey,
                    hintText: 'Es** **** **** ****',
                    errorText: recoveryKeyInputError,
                    errorMaxLines: 2,
                  ),
                ),
                ElevatedButton.icon(
                  icon: recoveryKeyInputLoading
                      ? const CircularProgressIndicator.adaptive()
                      : const Icon(Icons.lock_open_outlined),
                  label: Text(l10n.unlockOldMessages),
                  onPressed: recoveryKeyInputLoading
                      ? null
                      : () async {
                          model.setRecoveryKeyInputError(null);
                          model.setRecoveryKeyInputLoading(true);
                          try {
                            final newKey =
                                _recoveryKeyTextEditingController.text.trim();
                            if (newKey.isEmpty == true) return;
                            await bootstrap?.newSsssKey
                                ?.unlock(keyOrPassphrase: newKey);
                            await bootstrap?.openExistingSsss();
                            Logs().d('SSSS unlocked');
                            if (bootstrap?.encryption.crossSigning.enabled ==
                                true) {
                              Logs().v(
                                'Cross signing is already enabled. Try to self-sign',
                              );
                              try {
                                await bootstrap?.client.encryption!.crossSigning
                                    .selfSign(recoveryKey: newKey);
                                Logs().d('Successful selfsigned');
                              } catch (e, s) {
                                Logs().e(
                                  'Unable to self sign with recovery key after successfully open existing SSSS',
                                  e,
                                  s,
                                );
                              }
                            }
                          } on InvalidPassphraseException catch (e) {
                            if (context.mounted) {
                              showSnackBar(
                                context,
                                content: Text(e.toString()),
                              );
                            }
                          } on FormatException catch (_) {
                            model.setRecoveryKeyInputError(
                              l10n.wrongRecoveryKey,
                            );
                          } catch (e, _) {
                            if (context.mounted) {
                              showSnackBar(
                                context,
                                content: Text(e.toString()),
                              );
                            }
                          } finally {
                            model.setRecoveryKeyInputLoading(false);
                          }
                        },
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
                              future: di<AuthenticationModel>()
                                  .startKeyVerification,
                            );
                            if (context.mounted) {
                              if (req.error != null) return;
                              await KeyVerificationDialog(
                                request: req.result!,
                              ).show(context);
                            }
                          }
                        },
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                    foregroundColor: theme.colorScheme.onError,
                  ),
                  icon: const Icon(YaruIcons.trash),
                  label: Text(l10n.recoveryKeyLost),
                  onPressed: recoveryKeyInputLoading
                      ? null
                      : () async {
                          final result = await showOkCancelAlertDialog(
                            useRootNavigator: false,
                            context: context,
                            title: l10n.recoveryKeyLost,
                            message: l10n.wipeChatBackup,
                            okLabel: l10n.ok,
                            cancelLabel: l10n.cancel,
                            isDestructiveAction: true,
                          );
                          if (result == OkCancelResult.ok) {
                            await model.startBootstrap(wipe: true);
                          }
                        },
                ),
                const LogoutButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
