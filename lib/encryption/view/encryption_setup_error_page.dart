import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../../settings/view/chat_settings_logout_button.dart';
import 'check_encryption_setup_page.dart';

class EncryptionSetupErrorPage extends StatelessWidget {
  const EncryptionSetupErrorPage({super.key, this.error});

  final Object? error;

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
            if (error != null)
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: context.theme.textTheme.bodyMedium,
              ),
            ElevatedButton.icon(
              icon: const Icon(YaruIcons.refresh),
              onPressed: () =>
                  context.teleport((_) => const CheckEncryptionSetupPage()),
              label: Text(l10n.tryAgain),
            ),
            const ChatSettingsLogoutButton(),
          ],
        ),
      ),
    );
  }
}
