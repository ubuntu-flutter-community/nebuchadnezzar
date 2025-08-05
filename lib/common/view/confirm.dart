import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaru/yaru.dart';

import '../../l10n/l10n.dart';
import 'build_context_x.dart';
import 'common_widgets.dart';
import 'space.dart';
import 'ui_constants.dart';

class ConfirmationDialog<T> extends StatefulWidget {
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
    this.confirmEnabled = true,
    this.contentPadding,
    this.titlePadding,
  });
  final Future<T> Function()? onConfirm;
  final Future<T> Function()? onCancel;
  final List<Widget>? additionalActions;
  final Widget? title;
  final Widget? content;
  final bool showCancel;
  final bool showCloseIcon;
  final bool scrollable;
  final String? confirmLabel;
  final String? cancelLabel;
  final EdgeInsetsGeometry? contentPadding;
  final bool confirmEnabled;
  final EdgeInsetsGeometry? titlePadding;

  static Future<T?> show<T>({
    required BuildContext context,
    required Future<T> Function() onConfirm,
    Widget? title,
    Widget? content,
    String? confirmLabel,
    String? cancelLabel,
    bool barrierDismissible = false,
    bool confirmEnabled = true,
    bool scrollable = false,
    List<Widget>? additionalActions,
    EdgeInsetsGeometry? contentPadding,
    Future<T> Function()? onCancel,
    bool showCancel = true,
  }) => showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => ConfirmationDialog<T>(
      title: title,
      content: content,
      onConfirm: onConfirm,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      showCloseIcon: barrierDismissible,
      confirmEnabled: confirmEnabled,
      scrollable: scrollable,
      additionalActions: additionalActions,
      contentPadding: contentPadding,
      onCancel: onCancel,
      showCancel: showCancel,
    ),
  );

  @override
  State<ConfirmationDialog<T>> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState<T> extends State<ConfirmationDialog<T>> {
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      titlePadding: widget.titlePadding,
      title: widget.title,
      scrollable: widget.scrollable,
      content: _error != null
          ? Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                _error!,
                style: context.textTheme.bodyLarge!.copyWith(
                  color: context.colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
            )
          : _loading
          ? const SizedBox.square(
              dimension: 60,
              child: Center(
                child: SizedBox.square(dimension: 24, child: Progress()),
              ),
            )
          : widget.content,
      contentPadding: widget.contentPadding,
      actionsAlignment: MainAxisAlignment.start,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsPadding: const EdgeInsets.all(16),
      actions: [
        Row(
          children: space(
            expand: true,
            widthGap: 16,
            children: _error != null
                ? [
                    OutlinedButton(
                      onPressed: () {
                        if (context.mounted && Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(l10n.ok),
                    ),
                  ]
                : [
                    if (widget.showCancel)
                      OutlinedButton(
                        onPressed: _loading
                            ? null
                            : () {
                                if (widget.onCancel is Future<T> Function()) {
                                  setState(() => _loading = true);
                                  widget.onCancel!()
                                      .then((_) {
                                        if (context.mounted &&
                                            Navigator.of(context).canPop()) {
                                          Navigator.of(context).pop();
                                        }
                                      })
                                      .catchError((error) {
                                        setState(() {
                                          _loading = false;
                                          _error = error.toString();
                                        });
                                      });
                                } else {
                                  widget.onCancel?.call();
                                  if (context.mounted &&
                                      Navigator.of(context).canPop()) {
                                    Navigator.of(context).pop();
                                  }
                                }
                              },
                        child: Text(widget.cancelLabel ?? l10n.cancel),
                      ),
                    ...?widget.additionalActions,
                    ElevatedButton(
                      onPressed: _loading
                          ? null
                          : widget.confirmEnabled
                          ? () {
                              if (widget.onConfirm != null) {
                                if (widget.onConfirm is Future<T> Function()) {
                                  setState(() => _loading = true);
                                  widget.onConfirm!()
                                      .then((_) {
                                        if (context.mounted &&
                                            Navigator.of(context).canPop()) {
                                          Navigator.of(context).pop();
                                        }
                                      })
                                      .catchError((error) {
                                        setState(() {
                                          _loading = false;
                                          _error = error.toString();
                                        });
                                      });
                                } else {
                                  widget.onConfirm!();
                                  setState(() => _loading = false);
                                }
                              } else if (context.mounted &&
                                  Navigator.of(context).canPop()) {
                                Navigator.of(context).pop();
                              }
                            }
                          : null,
                      child: Text(widget.confirmLabel ?? l10n.ok),
                    ),
                  ],
          ),
        ),
      ],
    );
  }
}

Future<String?> showConfirmDialogWithInput({
  required BuildContext context,
  required String title,
  String? message,
  String? okLabel,
  String? cancelLabel,
  bool useRootNavigator = true,
  String? hintText,
  String? labelText,
  String? initialText,
  String? prefixText,
  String? suffixText,
  bool obscureText = false,
  bool isDestructive = false,
  int? minLines,
  String? Function(String input)? validator,
  TextInputType? keyboardType,
  int? maxLength,
  bool autocorrect = true,
  int? maxLines,
}) {
  final l10n = context.l10n;
  return showDialog<String>(
    context: context,
    useRootNavigator: useRootNavigator,
    builder: (context) {
      final controller = TextEditingController(text: initialText);
      final error = ValueNotifier<String?>(null);
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        title: YaruDialogTitleBar(
          title: Text(title),
          backgroundColor: Colors.transparent,
          border: BorderSide.none,
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 256),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: kBigPadding,
            children: [
              if (message != null)
                SelectableLinkify(
                  text: message,
                  linkStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    decorationColor: Theme.of(context).colorScheme.primary,
                  ),
                  options: const LinkifyOptions(humanize: false),
                  onOpen: (url) => launchUrl(Uri.parse(url.url)),
                ),
              ValueListenableBuilder<String?>(
                valueListenable: error,
                builder: (context, error, _) {
                  return TextField(
                    maxLines: maxLines,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      hintText: hintText,
                      errorText: error,
                      labelText: labelText,
                      prefixText: prefixText,
                      suffixText: suffixText,
                    ),
                    controller: controller,
                    minLines: minLines,
                    maxLength: maxLength,
                    keyboardType: keyboardType,
                  );
                },
              ),
            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.start,
        actionsOverflowAlignment: OverflowBarAlignment.center,
        actionsPadding: const EdgeInsets.all(kMediumPadding),
        actions: [
          Row(
            children: space(
              widthGap: kMediumPadding,
              expand: true,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: Text(cancelLabel ?? l10n.cancel),
                ),
                ElevatedButton(
                  onPressed: () {
                    final input = controller.text;
                    final errorText = validator?.call(input);
                    if (errorText != null) {
                      error.value = errorText;
                      return;
                    }
                    Navigator.of(context).pop<String>(input);
                  },
                  autofocus: true,
                  child: Text(
                    okLabel ?? l10n.ok,
                    style: isDestructive
                        ? TextStyle(color: Theme.of(context).colorScheme.error)
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
