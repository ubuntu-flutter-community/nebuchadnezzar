import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import 'build_context_x.dart';
import 'space.dart';
import 'ui_constants.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    this.onConfirm,
    this.onCancel,
    this.additionalActions,
    this.title,
    this.content,
    this.showCancel = true,
    this.showCloseIcon = true,
    this.scrollable = false,
    this.confirmLabel,
    this.cancelLabel,
  });

  final dynamic Function()? onConfirm;
  final dynamic Function()? onCancel;
  final List<Widget>? additionalActions;
  final Widget? title;
  final Widget? content;
  final bool showCancel;
  final bool showCloseIcon;
  final bool scrollable;
  final String? confirmLabel, cancelLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: YaruDialogTitleBar(
        title: title,
        backgroundColor: Colors.transparent,
        border: BorderSide.none,
        isClosable: showCloseIcon,
      ),
      scrollable: scrollable,
      titlePadding: EdgeInsets.zero,
      content: content,
      actionsAlignment: MainAxisAlignment.start,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsPadding: const EdgeInsets.all(kMediumPadding),
      actions: [
        Row(
          children: space(
            expand: true,
            widthGap: kMediumPadding,
            children: [
              ...?additionalActions,
              if (showCancel)
                OutlinedButton(
                  onPressed: () {
                    onCancel?.call();
                    if (context.mounted && Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(cancelLabel ?? l10n.cancel),
                ),
              ElevatedButton(
                onPressed: () {
                  onConfirm?.call();

                  if (context.mounted && Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  confirmLabel ?? l10n.ok,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
