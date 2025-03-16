import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../common/view/build_context_x.dart';
import '../../../common/view/confirm.dart';

import '../../authentication/authentication_model.dart';
import '../../authentication/chat_login_page.dart';
import '../../common/chat_model.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final chatModel = di<ChatModel>();
    final l10n = context.l10n;
    return ElevatedButton(
      onPressed: () => showDialog(
        context: context,
        builder: (context) => ConfirmationDialog(
          title: Text(l10n.logout),
          content: Text(l10n.areYouSureYouWantToLogout),
          onConfirm: () {
            chatModel.setSelectedRoom(null);
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => const ChatLoginPage(),
              ),
              (route) => false,
            );
            di<AuthenticationModel>().logout(
              onFail: (e) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(e.toString()),
                ),
              ),
            );
          },
        ),
      ),
      child: Text(l10n.logout),
    );
  }
}
