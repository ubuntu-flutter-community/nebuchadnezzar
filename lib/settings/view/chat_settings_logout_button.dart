import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../authentication/authentication_service.dart';
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
            await di<AuthenticationService>().logout();
            di<ChatManager>().setSelectedRoom(null);
            if (context.mounted && !di<AuthenticationService>().isLogged) {
              await Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const ChatLoginPage()),
                (route) => false,
              );
            }
          },
        );
      },
      child: Text(l10n.logout),
    );
  }
}
