import 'package:flutter/material.dart';

import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';

class RadioHostNotConnectedContent extends StatelessWidget {
  const RadioHostNotConnectedContent({
    super.key,
    this.onRetry,
    required this.message,
  });

  final void Function()? onRetry;
  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(context.l10n.noRadioBrowserConnected),
        Text(message),
        const SizedBox(height: kMediumPadding),
        ElevatedButton(onPressed: onRetry, child: Text(context.l10n.connect)),
      ],
    ),
  );
}
