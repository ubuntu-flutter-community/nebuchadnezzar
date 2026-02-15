import 'package:matrix/matrix.dart';

class ChatMessageReactionEntry {
  ChatMessageReactionEntry({
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
