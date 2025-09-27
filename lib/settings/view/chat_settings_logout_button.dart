import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../authentication/authentication_manager.dart';
import '../../authentication/view/chat_login_page.dart';
import '../../common/chat_manager.dart';
import '../../common/view/confirm.dart';
import '../../l10n/l10n.dart';

class ChatSettingsLogoutButton extends StatelessWidget {
  const ChatSettingsLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton(
      onPressed: () async {
        await ConfirmationDialog.show(
          context: context,
          title: Text(l10n.logout),
          content: Text(l10n.areYouSureYouWantToLogout),
          onConfirm: () async {
            final result = await di<AuthenticationManager>().logout(context);
            if (result.isValue && context.mounted) {
              di<ChatManager>().setSelectedRoom(null);
              if (context.mounted) {
                await Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const ChatLoginPage()),
                  (route) => false,
                );
              }
            }
          },
        );
      },
      child: Text(l10n.logout),
    );
  }
}
