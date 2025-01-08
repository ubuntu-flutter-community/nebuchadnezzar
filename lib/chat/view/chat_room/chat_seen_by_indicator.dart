import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';

import '../../../common/view/build_context_x.dart';
import '../../../common/view/ui_constants.dart';
import '../../chat_model.dart';
import '../../room_x.dart';
import '../../search_model.dart';
import '../chat_avatar.dart';
import '../chat_profile_dialog.dart';

class ChatSeenByIndicator extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const ChatSeenByIndicator({
    super.key,
    required this.room,
    required this.timeline,
  });

  final Room room;
  final Timeline timeline;

  static const maxAvatars = 7;

  @override
  State<ChatSeenByIndicator> createState() => _ChatSeenByIndicatorState();
}

class _ChatSeenByIndicatorState extends State<ChatSeenByIndicator> {
  @override
  void initState() {
    super.initState();
    widget.room.requestParticipants();
  }

  @override
  Widget build(BuildContext context) {
    final events = watchStream(
      (ChatModel m) => m.getReadEventsFromSync(widget.room),
      initialValue: widget.timeline.events,
    ).data;
    final list = <Event>{...widget.timeline.events, ...?events}.toList();
    final seenByUsers = widget.room.getSeenByUsers(list);

    return Container(
      width: double.infinity,
      alignment: widget.room.isDirectChat ||
              di<ChatModel>().isUserEvent(list.first) &&
                  list.first.type != EventTypes.Reaction
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: AnimatedContainer(
        padding: const EdgeInsets.symmetric(
          vertical: kSmallPadding,
          horizontal: kMediumPadding,
        ),
        height: seenByUsers.isEmpty ? 0 : 25,
        duration: const Duration(milliseconds: 200),
        child: Wrap(
          spacing: kSmallPadding,
          children: [
            ...(seenByUsers.length > ChatSeenByIndicator.maxAvatars
                    ? seenByUsers.sublist(0, ChatSeenByIndicator.maxAvatars)
                    : seenByUsers)
                .map(
              (user) => Tooltip(
                key: ValueKey(user.id + user.avatarUrl.toString()),
                message: user.displayName ?? user.id,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () async {
                    final profile =
                        await di<SearchModel>().lookupProfile(user.id);
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            ChatProfileDialog(userId: profile.userId),
                      );
                    }
                  },
                  child: ChatAvatar(
                    avatarUri: user.avatarUrl,
                    fallBackIconSize: 10,
                    dimension: 15,
                  ),
                ),
              ),
            ),
            if (seenByUsers.length > ChatSeenByIndicator.maxAvatars)
              SizedBox(
                width: 15,
                height: 15,
                child: Material(
                  color: context.colorScheme.surface,
                  borderRadius: BorderRadius.circular(30),
                  child: Center(
                    child: Text(
                      '+${seenByUsers.length - ChatSeenByIndicator.maxAvatars}',
                      style: const TextStyle(fontSize: 9),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
