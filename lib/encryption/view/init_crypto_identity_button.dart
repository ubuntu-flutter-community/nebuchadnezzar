import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../l10n/l10n.dart';
import 'init_crypto_identity_confirmation_dialog.dart';

class InitCryptoIdentityButton extends StatelessWidget {
  const InitCryptoIdentityButton({
    super.key,
    required this.loading,
    this.dialogTitle,
    this.label,
  });

  final bool loading;
  final String? label;
  final String? dialogTitle;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.error,
        foregroundColor: theme.colorScheme.onError,
      ),
      icon: Icon(YaruIcons.trash, color: theme.colorScheme.onError),
      label: Text(label ?? l10n.recoveryKeyLost),
      onPressed: loading
          ? null
          : () async {
              await showDialog(
                context: context,
                builder: (context) => InitCryptoIdentityConfirmationDialog(
                  title: dialogTitle ?? l10n.resetRecoveryKeyTitle,
                  confirmLabel: dialogTitle,
                ),
              );
            },
    );
  }
}
