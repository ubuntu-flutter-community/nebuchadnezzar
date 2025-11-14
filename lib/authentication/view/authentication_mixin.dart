import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:flutter_it/flutter_it.dart';

import '../../common/chat_manager.dart';
import '../../common/view/confirm.dart';
import '../../encryption/view/check_encryption_setup_page.dart';
import '../../extensions/safe_value_notifier_extension.dart';
import '../../l10n/l10n.dart';
import '../authentication_manager.dart';
import 'chat_login_page.dart';

mixin AuthenticationMixin {
  Future<void> login(
    BuildContext context, {
    required String loginMethod,
    required String homeServer,
    String? username,
    String? password,
  }) async {
    di<AuthenticationManager>().processingAccess.toggle();

    final result = await showFutureLoadingDialog(
      context: context,
      title: context.l10n.loginInPleaseWait,
      backLabel: context.l10n.close,
      future: () => di<AuthenticationManager>().login(
        loginMethod: loginMethod,
        homeServer: homeServer,
        username: username,
        password: password,
      ),
    );

    if (result.isValue && context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const CheckEncryptionSetupPage()),
        (route) => false,
      );
    }

    di<AuthenticationManager>().processingAccess.toggle();
  }

  Future<void> logout(BuildContext context) async => ConfirmationDialog.show(
    context: context,
    title: Text(context.l10n.logout),
    content: Text(context.l10n.areYouSureYouWantToLogout),
    onConfirm: () async {
      di<AuthenticationManager>().processingAccess.toggle();
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
      di<AuthenticationManager>().processingAccess.toggle();
    },
  );
}
