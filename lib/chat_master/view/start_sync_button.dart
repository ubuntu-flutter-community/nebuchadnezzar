import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/chat_manager.dart';
import '../../common/view/common_widgets.dart';
import '../../l10n/l10n.dart';

class StartSyncButton extends StatelessWidget with WatchItMixin {
  const StartSyncButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isRunning = watchValue(
      (ChatManager m) => m.startSyncingCommand.isRunning,
    );
    final errors = watchValue((ChatManager m) => m.startSyncingCommand.errors);

    return IconButton(
      tooltip: context.l10n.syncNow,
      onPressed: errors != null
          ? () => showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(context.l10n.oopsSomethingWentWrong),
                  content: Text(errors.error.toString()),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(context.l10n.ok),
                    ),
                  ],
                );
              },
            )
          : isRunning
          ? null
          : () => di<ChatManager>().startSyncingCommand.run(),
      icon: errors != null
          ? const Icon(YaruIcons.error)
          : isRunning
          ? const SizedBox(
              width: 16,
              height: 16,
              child: Progress(strokeWidth: 2),
            )
          : const Icon(YaruIcons.refresh),
    );
  }
}
