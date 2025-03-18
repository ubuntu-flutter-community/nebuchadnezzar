import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/l10n.dart';

Future<String?> showTextInputDialog({
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
}) {
  final l10n = context.l10n;
  return showDialog<String>(
    context: context,
    useRootNavigator: useRootNavigator,
    builder: (context) {
      final controller = TextEditingController(text: initialText);
      final error = ValueNotifier<String?>(null);
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 512),
        child: AlertDialog(
          title: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 256),
            child: Text(title),
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 256),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                const SizedBox(height: 16),
                ValueListenableBuilder<String?>(
                  valueListenable: error,
                  builder: (context, error, _) {
                    return TextField(
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
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text(cancelLabel ?? l10n.cancel),
            ),
            TextButton(
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
      );
    },
  );
}
