import 'package:matrix/matrix.dart';

import 'chat_message_reaction_entry.dart';

class ChatMessageReactionCapsule {
  const ChatMessageReactionCapsule({
    required this.allReactionEvents,
    required this.entry,
    required this.event,
  });

  final Set<Event>? allReactionEvents;
  final ChatMessageReactionEntry entry;
  final Event event;
}
