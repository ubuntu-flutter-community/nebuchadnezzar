import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../../chat_master/view/chat_master_detail_page.dart';
import '../../common/view/build_context_x.dart';
import '../../l10n/l10n.dart';

class EncryptionSetupDonePage extends StatelessWidget {
  const EncryptionSetupDonePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: YaruWindowTitleBar(
        title: Text(l10n.everythingReady),
        border: BorderSide.none,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
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
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => const ChatMasterDetailPage(),
                ),
                (route) => false,
              ),
              child: Text(l10n.start),
            ),
          ],
        ),
      ),
    );
  }
}
