import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';

import '../../chat_room/create_or_edit/edit_room_manager.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/ui_constants.dart';

class ChatMessageReaction extends StatelessWidget with WatchItMixin {
  const ChatMessageReaction({
    super.key,
    required this.event,
    required this.reactionKey,
    required this.count,
    required this.reacted,
    required this.onTap,
    required this.onLongPress,
  });

  final Event event;
  final String reactionKey;
  final int count;
  final bool? reacted;
  final void Function()? onTap;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    if (reactionKey.startsWith('mxc://')) {
      return const SizedBox.shrink();
    }

    final isLoading = watchValue(
      (EditRoomManager m) =>
          m.getSendReactionCommand(reactionKey + event.eventId).isRunning,
    );

    registerHandler(
      select: (EditRoomManager m) =>
          m.getSendReactionCommand(reactionKey + event.eventId).errors,
      handler: (context, newValue, cancel) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending reaction: $newValue')),
        );
      },
    );

    if (isLoading) {
      return Container(
        height: 25,
        width: 25,
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surface,
          border: Border.all(
            width: 1,
            color: context.theme.colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(kBigBubbleRadius),
        ),
        child: const Center(
          child: SizedBox.square(
            dimension: 12,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    final theme = context.theme;
    final textColor = theme.brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    final color = theme.colorScheme.surface;

    var renderKey = Characters(reactionKey);
    if (renderKey.length > 10) {
      renderKey = renderKey.getRange(0, 9) + Characters('…');
    }
    final content = Text(
      renderKey.toString() + (count > 1 ? ' $count' : ''),
      textAlign: TextAlign.center,
      style: TextStyle(
        color: textColor,
        fontSize: DefaultTextStyle.of(context).style.fontSize,
      ),
    );

    return InkWell(
      onTap: () => onTap != null ? onTap!() : null,
      onLongPress: () => onLongPress != null ? onLongPress!() : null,
      borderRadius: const BorderRadius.all(kBigBubbleRadius),
      child: Container(
        height: 25,
        width: 25,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            width: 1,
            color: reacted!
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(kBigBubbleRadius),
        ),
        child: Center(child: content),
      ),
    );
  }
}
