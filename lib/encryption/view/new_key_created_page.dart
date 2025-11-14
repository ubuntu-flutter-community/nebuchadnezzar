import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../chat_master/view/chat_master_detail_page.dart';
import '../../common/platforms.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/snackbars.dart';
import '../../common/view/space.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/l10n.dart';
import '../../settings/view/chat_settings_logout_button.dart';
import '../encryption_manager.dart';

class NewKeyCreatedPage extends StatelessWidget with WatchItMixin {
  const NewKeyCreatedPage({super.key, required this.encryptionKey});

  final String encryptionKey;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final encryptionManager = di<EncryptionManager>();

    final recoveryKeyCopied = watchPropertyValue(
      (EncryptionManager m) => m.recoveryKeyCopied,
    );
    final storeInSecureStorage = watchPropertyValue(
      (EncryptionManager m) => m.storeInSecureStorage,
    );

    return Scaffold(
      appBar: YaruWindowTitleBar(
        border: BorderSide.none,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(l10n.recoveryKey),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: space(
              heightGap: kMediumPadding,
              children: [
                ...[
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
                  const Divider(height: 32, thickness: 1),
                  TextField(
                    minLines: 2,
                    maxLines: 4,
                    readOnly: true,
                    style: const TextStyle(fontFamily: 'UbuntuMono'),
                    controller: TextEditingController(text: encryptionKey),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(16),
                      suffixIcon: Icon(YaruIcons.key),
                    ),
                  ),
                ],
                YaruCheckboxListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                  value: storeInSecureStorage,
                  onChanged: (v) =>
                      encryptionManager.setStoreInSecureStorage(v ?? false),
                  title: Text(getSecureStorageLocalizedName(context.l10n)),
                  subtitle: Text(l10n.storeInSecureStorageDescription),
                ),
                YaruCheckboxListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                  value: recoveryKeyCopied,
                  onChanged: (b) {
                    Clipboard.setData(ClipboardData(text: encryptionKey));
                    showSnackBar(
                      context,
                      content: Text(l10n.copiedToClipboard),
                    );
                    encryptionManager.setRecoveryKeyCopied(true);
                  },
                  title: Text(l10n.copyToClipboard),
                  subtitle: Text(l10n.saveKeyManuallyDescription),
                ),
                ElevatedButton.icon(
                  icon: const Icon(YaruIcons.checkmark),
                  label: Text(l10n.next),
                  onPressed: (recoveryKeyCopied || storeInSecureStorage)
                      ? () {
                          encryptionManager.storeRecoveryKey();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ChatMasterDetailPage(),
                            ),
                            (route) => false,
                          );
                        }
                      : null,
                ),
                const ChatSettingsLogoutButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getSecureStorageLocalizedName(AppLocalizations l10n) {
    if (Platforms.isAndroid) {
      return l10n.storeInAndroidKeystore;
    }
    if (Platforms.isIOS || Platforms.isMacOS) {
      return l10n.storeInAppleKeyChain;
    }
    return l10n.storeSecurlyOnThisDevice;
  }
}
