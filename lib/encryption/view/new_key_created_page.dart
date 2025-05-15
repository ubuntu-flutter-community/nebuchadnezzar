import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/snackbars.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../../settings/view/chat_settings_logout_button.dart';
import '../encryption_model.dart';

class NewKeyCreatedPage extends StatelessWidget with WatchItMixin {
  const NewKeyCreatedPage({super.key, required this.encryptionKey});

  final String encryptionKey;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final model = di<EncryptionModel>();

    final recoveryKeyCopied = watchPropertyValue(
      (EncryptionModel m) => m.recoveryKeyCopied,
    );
    final storeInSecureStorage = watchPropertyValue(
      (EncryptionModel m) => m.storeInSecureStorage,
    );

    return Scaffold(
      appBar: YaruWindowTitleBar(
        border: BorderSide.none,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(l10n.recoveryKey),
        actions: [
          const ChatSettingsLogoutButton(),
          const SizedBox(width: kSmallPadding),
        ],
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
                controller: TextEditingController(text: encryptionKey),
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
                  Clipboard.setData(ClipboardData(text: encryptionKey));
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
