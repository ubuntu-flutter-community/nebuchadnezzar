import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';

import '../../chat_room/create_or_edit/edit_room_manager.dart';
import '../../common/view/ui_constants.dart';
import '../../extensions/event_x.dart';
import '../chat_message_reaction_capsule.dart';
import 'chat_message_reaction.dart';
import 'chat_message_reactions_dialog.dart';

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
    final allReactionEvents = event.getAllReactionEvents(timeline);

    final reactions = Wrap(
      key: ValueKey('${event.eventId}reactions'),
      spacing: kSmallPadding,
      runSpacing: kSmallPadding,
      alignment: event.isUserEvent ? WrapAlignment.end : WrapAlignment.start,
      children: event
          .getReactionList(allReactionEvents)
          .map(
            (entry) => ChatMessageReaction(
              event: event,
              reactionKey: entry.key,
              count: entry.count,
              reacted: entry.reacted,
              onTap: () => di<EditRoomManager>()
                  .getSendReactionCommand(entry.key + event.eventId)
                  .run(
                    ChatMessageReactionCapsule(
                      allReactionEvents: allReactionEvents,
                      entry: entry,
                      event: event,
                    ),
                  ),
              onLongPress: () => showDialog(
                context: context,
                builder: (context) =>
                    ChatMessageReactionsDialog(reactionEntry: entry),
              ),
            ),
          )
          .toList(),
    );

    const nothing = SizedBox.shrink();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: reactions.children.isEmpty ? nothing : reactions,
    );
  }
}
