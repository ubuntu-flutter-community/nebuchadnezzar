import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:watch_it/watch_it.dart';

import '../../chat_room/input/draft_manager.dart';
import '../../common/chat_manager.dart';
import '../../l10n/l10n.dart';

class MouseAndKeyboardCommandWrapper extends StatelessWidget {
  const MouseAndKeyboardCommandWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Shortcuts(
    shortcuts: <LogicalKeySet, Intent>{
      LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyV):
          const _PasteIntent(), //For Mac
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyV):
          const _PasteIntent(), // For Windows/Linux
    },
    child: Actions(
      actions: <Type, Action<Intent>>{
        _PasteIntent: CallbackAction<_PasteIntent>(
          onInvoke: (intent) async {
            if (di<ChatManager>().selectedRoom != null) {
              await showFutureLoadingDialog(
                context: context,
                backLabel: context.l10n.cancel,
                title: context.l10n.loadingPleaseWait,
                future: () => di<DraftManager>().addAttachMentFromClipboard(
                  di<ChatManager>().selectedRoom!.id,
                  fileIsTooLarge: context.l10n.fileIsTooLarge,
                  clipboardNotAvailable: context.l10n.clipboardNotAvailable,
                  noSupportedFormatFoundInClipboard:
                      context.l10n.noSupportedFormatFoundInClipboard,
                ),
              );
            }
            return null;
          },
        ),
      },
      child: child,
    ),
  );
}

class _PasteIntent extends Intent {
  const _PasteIntent();
}
