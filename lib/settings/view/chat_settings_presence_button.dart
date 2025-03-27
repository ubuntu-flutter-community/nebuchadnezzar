import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../common/view/confirm.dart';
import '../../l10n/l10n.dart';
import '../settings_model.dart';

class ChatSettingsPresenceButton extends StatelessWidget with WatchItMixin {
  const ChatSettingsPresenceButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settingsModel = di<SettingsModel>();
    final presence = watchStream(
      (SettingsModel m) => m.presenceStream,
      initialValue: settingsModel.presence,
    ).data;
    return TextButton(
      onPressed: () => showConfirmDialogWithInput(
        context: context,
        title: l10n.setStatus,
        message: l10n.leaveEmptyToClearStatus,
        okLabel: l10n.ok,
        cancelLabel: l10n.cancel,
        hintText: l10n.statusExampleMessage,
        maxLines: 6,
        minLines: 1,
        maxLength: 255,
      ).then((status) => di<SettingsModel>().setStatus(status)),
      child: Text(
        presence?.statusMsg ?? context.l10n.status,
      ),
    );
  }
}
