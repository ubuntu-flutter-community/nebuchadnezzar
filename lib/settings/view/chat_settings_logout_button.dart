import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../authentication/authentication_model.dart';
import '../../authentication/view/chat_login_page.dart';
import '../../common/chat_model.dart';
import '../../common/view/confirm.dart';
import '../../l10n/l10n.dart';

class ChatSettingsLogoutButton extends StatelessWidget {
  const ChatSettingsLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton(
      onPressed: () => showDialog(
        context: context,
        builder: (context) => ConfirmationDialog(
          title: Text(l10n.logout),
          content: Text(l10n.areYouSureYouWantToLogout),
          onConfirm: () async {
            di<ChatModel>().setSelectedRoom(null);
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const ChatLoginPage()),
              (route) => false,
            );
            await di<AuthenticationModel>().logout(
              onFail: (e) => ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(e.toString()))),
            );
          },
        ),
      ),
      child: Text(l10n.logout),
    );
  }
}
