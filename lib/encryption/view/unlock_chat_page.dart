import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/encryption.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../authentication/authentication_model.dart';
import '../../authentication/view/uia_request_handler.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/confirm.dart';
import '../../common/view/snackbars.dart';
import '../../common/view/space.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../../settings/view/chat_settings_logout_button.dart';
import '../encryption_model.dart';
import 'key_verification_dialog.dart';

class UnlockChatPage extends StatefulWidget with WatchItStatefulWidgetMixin {
  const UnlockChatPage({super.key});

  @override
  State<UnlockChatPage> createState() => _UnlockChatPageState();
}

class _UnlockChatPageState extends State<UnlockChatPage> {
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
    final model = di<EncryptionModel>();

    final bootstrap = watchPropertyValue((EncryptionModel m) => m.bootstrap);
    final recoveryKeyInputLoading = watchPropertyValue(
      (EncryptionModel m) => m.recoveryKeyInputLoading,
    );
    final recoveryKeyInputError = watchPropertyValue(
      (EncryptionModel m) => m.recoveryKeyInputError,
    );

    registerStreamHandler(
      select: (AuthenticationModel m) => m.onUiaRequestStream,
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

    return Scaffold(
      appBar: const YaruWindowTitleBar(
        border: BorderSide.none,
        backgroundColor: Colors.transparent,
        actions: [
          Flexible(child: ChatSettingsLogoutButton()),
          SizedBox(width: kSmallPadding),
        ],
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
                              future:
                                  di<EncryptionModel>().startKeyVerification,
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
                  icon: Icon(YaruIcons.trash, color: theme.colorScheme.onError),
                  label: Text(l10n.recoveryKeyLost),
                  onPressed: recoveryKeyInputLoading
                      ? null
                      : () async {
                          showDialog(
                            context: context,
                            builder: (context) => ConfirmationDialog(
                              title: Text(l10n.recoveryKeyLost),
                              content: Text(l10n.wipeChatBackup),
                              onConfirm: () => model.startBootstrap(wipe: true),
                            ),
                          );
                        },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
