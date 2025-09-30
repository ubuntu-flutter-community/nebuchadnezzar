import 'package:flutter/material.dart';

import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';

class RadioHostNotConnectedContent extends StatelessWidget {
  const RadioHostNotConnectedContent({super.key, this.onRetry});

  final void Function()? onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(context.l10n.noRadioBrowserConnected),
        const SizedBox(height: kMediumPadding),
        ElevatedButton(onPressed: onRetry, child: Text(context.l10n.connect)),
      ],
    ),
  );
}
