import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../../settings/view/chat_settings_logout_button.dart';
import 'check_encryption_setup_page.dart';

class EncryptionSetupErrorPage extends StatelessWidget {
  const EncryptionSetupErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: YaruWindowTitleBar(
        title: Text(l10n.oopsSomethingWentWrong),
        border: BorderSide.none,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          spacing: kBigPadding,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(YaruIcons.error, color: Colors.red, size: 80),
            ElevatedButton.icon(
              icon: const Icon(YaruIcons.refresh),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const CheckEncryptionSetupPage(),
                  ),
                  (route) => false,
                );
              },
              label: Text(l10n.tryAgain),
            ),
            const ChatSettingsLogoutButton(),
          ],
        ),
      ),
    );
  }
}
