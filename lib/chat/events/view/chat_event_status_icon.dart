import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../common/date_time_x.dart';
import '../../../common/view/build_context_x.dart';
import '../../../common/view/ui_constants.dart';
import '../../../l10n/l10n.dart';
import '../../common/chat_model.dart';
import '../../common/event_x.dart';

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
    final userEvent = di<ChatModel>().isUserEvent(event);
    final icon = event.messageType == MessageTypes.BadEncrypted
        ? Icon(
            YaruIcons.lock,
            size: iconSize,
            color: foregroundColor,
          )
        : userEvent
            ? switch (event.status) {
                EventStatus.sending || EventStatus.sent => Icon(
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
                EventStatus.roomState => Icon(
                    key: ValueKey(event.status.index),
                    YaruIcons.information,
                    color: foregroundColor,
                  ),
                EventStatus.synced => Icon(
                    key: ValueKey(event.status.index),
                    YaruIcons.checkmark,
                    size: iconSize,
                    color: foregroundColor,
                  )
              }
            : const SizedBox.shrink();

    final style = textStyle ??
        context.textTheme.labelSmall?.copyWith(
          color: foregroundColor,
        );

    return Padding(
      padding: padding ?? const EdgeInsets.all(kSmallPadding),
      child: SizedBox(
        height: iconSize,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: kSmallPadding,
          children: [
            if (event.hasAggregatedEvents(timeline, RelationshipTypes.edit))
              const Icon(
                YaruIcons.pen,
                size: iconSize,
              ),
            if (event.room.pinnedEventIds.contains(event.eventId))
              const Icon(
                YaruIcons.pin,
                size: iconSize,
              ),
            if (!userEvent && event.isImage)
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 100),
                child: Text(
                  '${event.senderFromMemoryOrFallback.calcDisplayname()}, ',
                  style: style,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            Text(
              event.originServerTs
                  .toLocal()
                  .formatAndLocalizeTime(context.l10n),
              textAlign: TextAlign.start,
              style: style,
              overflow: TextOverflow.ellipsis,
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: icon,
            ),
          ],
        ),
      ),
    );
  }
}
