import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/common_widgets.dart';
import '../../l10n/l10n.dart';
import '../../settings/account_manager.dart';
import '../encryption_manager.dart';
import 'key_verification_dialog.dart';

class UnlockFromOtherDevicesButton extends StatelessWidget with WatchItMixin {
  const UnlockFromOtherDevicesButton({
    super.key,
    required this.recoveryKeyInputLoading,
  });

  final bool recoveryKeyInputLoading;

  @override
  Widget build(BuildContext context) {
    callOnceAfterThisBuild(
      (context) => di<AccountManager>().devicesRefreshCommand.run(),
    );

    final devices = watchValue((AccountManager m) => m.devicesCommand);

    if (devices == null) {
      return const Progress();
    }

    if (devices.isEmpty) {
      return const SizedBox.shrink();
    }

    return ElevatedButton.icon(
      icon: const Icon(YaruIcons.sync),
      label: Text(context.l10n.transferFromAnotherDevice),
      onPressed: recoveryKeyInputLoading
          ? null
          : () async {
              if (context.mounted) {
                final req = await showFutureLoadingDialog(
                  context: context,
                  future: di<EncryptionManager>().startKeyVerification,
                );
                if (context.mounted) {
                  if (req.error != null) return;
                  await KeyVerificationDialog(
                    request: req.result!,
                    verifyOther: false,
                  ).show(context);
                }
              }
            },
    );
  }
}
