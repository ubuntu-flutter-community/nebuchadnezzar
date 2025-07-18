import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import 'localized_display_event_text.dart';

class ChatMessageBadge extends StatelessWidget {
  const ChatMessageBadge({super.key, required this.displayEvent, this.leading});

  final Event displayEvent;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Padding(
      padding: const EdgeInsets.all(kSmallPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leading != null) leading!,
          Flexible(
            child: Badge(
              textColor: getEventBadgeTextColor(theme),
              backgroundColor: getEventBadgeColor(theme),
              label: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 400,
                  minWidth: 30,
                  minHeight: 16,
                  maxHeight: 16,
                ),
                child: LocalizedDisplayEventText(
                  displayEvent: displayEvent,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
