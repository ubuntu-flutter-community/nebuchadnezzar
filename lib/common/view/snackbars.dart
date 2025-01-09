import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/l10n.dart';
import 'build_context_x.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSnackBar(
  BuildContext context, {
  required Widget content,
}) {
  if (!context.mounted) return null;
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: content));
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showErrorSnackBar(
  BuildContext context,
  String error,
) {
  if (!context.mounted) return null;
  return ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(error)));
}

class CopyClipboardContent extends StatefulWidget {
  const CopyClipboardContent({
    super.key,
    required this.text,
    this.onSearch,
    this.showActions = true,
  });

  final String text;
  final void Function()? onSearch;
  final bool showActions;

  @override
  State<CopyClipboardContent> createState() => _CopyClipboardContentState();
}

class _CopyClipboardContentState extends State<CopyClipboardContent> {
  @override
  void initState() {
    super.initState();
    Clipboard.setData(ClipboardData(text: widget.text));
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final textColor =
        theme.snackBarTheme.contentTextStyle?.color?.withValues(alpha: 0.8);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                Text(
                  context.l10n.copiedToClipboard,
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
                Text(
                  widget.text,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
