import 'dart:math';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/common_widgets.dart';
import '../../common/view/space.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../../common/chat_model.dart';
import '../../common/view/chat_avatar.dart';
import '../../common/view/mxc_image.dart';

// Credit: this code has been initially copied from https://github.com/krille-chan/fluffychat
// Thank you @krille-chan
class ChatMessageReactions extends StatelessWidget {
  final Event event;
  final Timeline timeline;

  const ChatMessageReactions({
    required this.event,
    required this.timeline,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final allReactionEvents =
        event.aggregatedEvents(timeline, RelationshipTypes.reaction);
    final reactionMap = <String, ReactionEntry>{};

    for (final e in allReactionEvents) {
      final key = e.content
          .tryGetMap<String, dynamic>('m.relates_to')
          ?.tryGet<String>('key');
      if (key != null) {
        if (!reactionMap.containsKey(key)) {
          reactionMap[key] = ReactionEntry(
            key: key,
            count: 0,
            reacted: false,
            reactors: [],
          );
        }
        reactionMap[key]!.count++;
        reactionMap[key]!.reactors!.add(e.senderFromMemoryOrFallback);
        reactionMap[key]!.reacted |= e.senderId == e.room.client.userID;
      }
    }

    final reactionList = reactionMap.values.toList();
    reactionList.sort((a, b) => b.count - a.count > 0 ? 1 : -1);

    return Wrap(
      spacing: kSmallPadding,
      runSpacing: kSmallPadding,
      alignment: di<ChatModel>().isUserEvent(event)
          ? WrapAlignment.end
          : WrapAlignment.start,
      children: [
        ...reactionList.map(
          (r) => _Reaction(
            reactionKey: r.key,
            count: r.count,
            reacted: r.reacted,
            onTap: () {
              if (r.reacted) {
                final evt = allReactionEvents.firstWhereOrNull(
                  (e) =>
                      e.senderId == e.room.client.userID &&
                      e.content.tryGetMap('m.relates_to')?['key'] == r.key,
                );
                if (evt != null) {
                  showFutureLoadingDialog(
                    context: context,
                    future: () => evt.redactEvent(),
                  );
                }
              } else {
                event.room.sendReaction(event.eventId, r.key);
              }
            },
            onLongPress: () => showDialog(
              context: context,
              builder: (context) => ReactionsModal(
                reactionEntry: r,
              ),
            ),
          ),
        ),
        if (allReactionEvents.any((e) => e.status.isSending))
          const SizedBox(
            width: 24,
            height: 24,
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: Progress(strokeWidth: 1),
            ),
          ),
      ],
    );
  }
}

class _Reaction extends StatelessWidget {
  final String reactionKey;
  final int count;
  final bool? reacted;
  final void Function()? onTap;
  final void Function()? onLongPress;

  const _Reaction({
    required this.reactionKey,
    required this.count,
    required this.reacted,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final textColor =
        theme.brightness == Brightness.dark ? Colors.white : Colors.black;
    final color = theme.colorScheme.surface;
    Widget content;
    if (reactionKey.startsWith('mxc://')) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          MxcImage(
            uri: Uri.parse(reactionKey),
            width: 20,
            height: 20,
          ),
          if (count > 1) ...[
            const SizedBox(width: 4),
            Text(
              count.toString(),
              style: TextStyle(
                color: textColor,
                fontSize: DefaultTextStyle.of(context).style.fontSize,
              ),
            ),
          ],
        ],
      );
    } else {
      var renderKey = Characters(reactionKey);
      if (renderKey.length > 10) {
        renderKey = renderKey.getRange(0, 9) + Characters('…');
      }
      content = Text(
        renderKey.toString() + (count > 1 ? ' $count' : ''),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor,
          fontSize: DefaultTextStyle.of(context).style.fontSize,
        ),
      );
    }
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
        padding: EdgeInsets.only(left: yaru ? 3 : 0),
        child: Center(child: content),
      ),
    );
  }
}

class ReactionEntry {
  ReactionEntry({
    required this.key,
    required this.count,
    required this.reacted,
    this.reactors,
  });

  String key;
  int count;
  bool reacted;
  List<User>? reactors;
}

class ReactionsModal extends StatelessWidget {
  const ReactionsModal({super.key, this.reactionEntry});

  final ReactionEntry? reactionEntry;

  @override
  Widget build(BuildContext context) => SimpleDialog(
        title: YaruDialogTitleBar(
          title: Text(reactionEntry!.key),
          border: BorderSide.none,
          backgroundColor: Colors.transparent,
        ),
        titlePadding: EdgeInsets.zero,
        children: space(
          heightGap: kSmallPadding,
          children: [
            for (final reactor in reactionEntry!.reactors!)
              Chip(
                avatar: ChatAvatar(avatarUri: reactor.avatarUrl),
                label: Text(reactor.displayName ?? ''),
              ),
          ],
        ),
      );
}
