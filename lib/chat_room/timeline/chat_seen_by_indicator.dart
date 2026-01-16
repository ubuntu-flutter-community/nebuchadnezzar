import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';

import '../../common/chat_manager.dart';
import '../../common/search_manager.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/chat_avatar.dart';
import '../../common/view/chat_profile_dialog.dart';
import '../../common/view/ui_constants.dart';
import '../../extensions/event_x.dart';

const maxAvatars = 7;

class ChatEventSeenByIndicator extends StatelessWidget with WatchItMixin {
  const ChatEventSeenByIndicator({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    final seenByUsers =
        watchStream(
          (ChatManager m) => m.getRoomsReceiptsStream(event),
          initialValue: event.seenByUsers,
        ).data ??
        <User>[];

    return SimpleChatSeenByIndicator(seenByUsers: seenByUsers);
  }
}

class SimpleChatSeenByIndicator extends StatelessWidget {
  const SimpleChatSeenByIndicator({
    super.key,
    required this.seenByUsers,
    this.alignment,
  });

  final List<User> seenByUsers;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: alignment ?? Alignment.centerRight,
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
            ...(seenByUsers.length > maxAvatars
                    ? seenByUsers.sublist(0, maxAvatars)
                    : seenByUsers)
                .map(
                  (user) => ChatEventSeenByAvatar(
                    key: ValueKey(user.id + user.avatarUrl.toString()),
                    user: user,
                  ),
                ),
            if (seenByUsers.length > maxAvatars)
              SizedBox(
                width: 15,
                height: 15,
                child: Material(
                  color: context.colorScheme.surface,
                  borderRadius: BorderRadius.circular(30),
                  child: Center(
                    child: Text(
                      '+${seenByUsers.length - maxAvatars}',
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

class ChatEventSeenByAvatar extends StatelessWidget {
  const ChatEventSeenByAvatar({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: user.displayName ?? user.id,
    child: InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () async {
        final profile = await di<SearchManager>().lookupProfile(user.id);
        if (context.mounted) {
          await showDialog(
            context: context,
            builder: (context) => ChatProfileDialog(userId: profile.userId),
          );
        }
      },
      child: ChatAvatar(
        avatarUri: user.avatarUrl,
        fallBackIconSize: 15,
        dimension: 20,
      ),
    ),
  );
}
