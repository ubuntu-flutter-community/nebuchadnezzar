import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../../extensions/date_time_x.dart';
import '../../extensions/event_x.dart';

class ChatEventStatusIcon extends StatelessWidget {
  const ChatEventStatusIcon({
    super.key,
    required this.event,
    this.padding,
    this.foregroundColor,
    this.textStyle,
    required this.timeline,
  });

  final Event event;
  final EdgeInsetsGeometry? padding;
  final Color? foregroundColor;
  final TextStyle? textStyle;
  final Timeline timeline;

  static const iconSize = 15.0;

  @override
  Widget build(BuildContext context) {
    final userEvent = event.isUserEvent;
    final icon = event.messageType == MessageTypes.BadEncrypted
        ? Icon(YaruIcons.lock, size: iconSize, color: foregroundColor)
        : userEvent
        ? switch (event.status) {
            EventStatus.sending => Icon(
              key: ValueKey(event.status.index),
              YaruIcons.sync,
              size: iconSize,
              color: foregroundColor,
            ),
            EventStatus.error => Icon(
              key: ValueKey(event.status.index),
              YaruIcons.sync_error,
              size: iconSize,
              color: foregroundColor,
            ),
            EventStatus.sent => Icon(
              key: ValueKey(event.status.index),
              YaruIcons.checkmark,
              size: iconSize,
              color: foregroundColor,
            ),
            EventStatus.synced => Icon(
              key: ValueKey(event.status.index),
              YaruIcons.checkmark,
              size: iconSize,
              color: getTileIconColor(context.theme),
            ),
          }
        : const SizedBox.shrink();

    return Padding(
      padding: padding ?? const EdgeInsets.all(kSmallPadding),
      child: SizedBox(
        height: iconSize,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: kSmallPadding,
          children: [
            if (event.hasAggregatedEvents(timeline, RelationshipTypes.edit))
              const Icon(YaruIcons.pen, size: iconSize),

            Text(
              event.originServerTs.toLocal().formatAndLocalizeTime(context),
              textAlign: TextAlign.start,
              style: context.textTheme.labelSmall?.copyWith(
                color: foregroundColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            AnimatedSwitcher(
              key: ValueKey('${event.eventId}${event.status.index}'),
              duration: const Duration(milliseconds: 300),
              child: icon,
            ),
          ],
        ),
      ),
    );
  }
}
