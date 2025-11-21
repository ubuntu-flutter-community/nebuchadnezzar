import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/widgets.dart';

import '../../authentication/authentication_manager.dart';
import '../../authentication/view/chat_login_page.dart';
import '../../common/chat_manager.dart';
import '../../common/view/common_widgets.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';

class ChatSettingsLogoutButton extends StatelessWidget {
  const ChatSettingsLogoutButton({super.key});

  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: () => showDialog(
      context: context,
      builder: (context) => const LogoutDialog(),
    ),
    child: Text(context.l10n.logout),
  );
}

class LogoutDialog extends StatelessWidget with WatchItMixin {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    registerHandler(
      select: (AuthenticationManager m) => m.logoutCommand,
      handler: (context, _, cancel) {
        di<ChatManager>().setSelectedRoom(null);
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const ChatLoginPage()),
            (route) => false,
          );
        }
      },
    );

    return AlertDialog(
      title: YaruDialogTitleBar(
        backgroundColor: Colors.transparent,
        isClosable: false,
        title: Text(context.l10n.logout),
        border: BorderSide.none,
      ),
      titlePadding: EdgeInsets.zero,
      content:
          watchValue((AuthenticationManager s) => s.logoutCommand.isRunning)
          ? const SizedBox(height: 50, child: Center(child: Progress()))
          : Text(context.l10n.areYouSureYouWantToLogout),
      actionsAlignment: MainAxisAlignment.start,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsPadding: const EdgeInsets.all(kMediumPadding),
      actions: [
        Row(
          spacing: kMediumPadding,
          children: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: Text(context.l10n.cancel),
            ),
            ElevatedButton(
              onPressed: di<AuthenticationManager>().logoutCommand.run,
              child: Text(context.l10n.logout),
            ),
          ].map((e) => Expanded(child: e)).toList(),
        ),
      ],
    );
  }
}
