import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/ui_constants.dart';
import '../../common/chat_model.dart';
import '../../common/search_model.dart';
import '../../common/view/chat_avatar.dart';
import '../../common/view/chat_profile_dialog.dart';

class ChatEventSeenByIndicator extends StatelessWidget with WatchItMixin {
  const ChatEventSeenByIndicator({
    super.key,
    required this.event,
  });

  final Event event;

  static const maxAvatars = 7;

  @override
  Widget build(BuildContext context) {
    final seenByUsers = watchStream(
          (ChatModel m) => m.getRoomsReceiptsStream(event),
          initialValue: event.receipts,
        )
            .data
            ?.map((e) => e.user)
            .where((e) => e.id != di<ChatModel>().myUserId)
            .toList() ??
        [];

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
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
                    ? seenByUsers.sublist(
                        0,
                        maxAvatars,
                      )
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
  const ChatEventSeenByAvatar({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: user.displayName ?? user.id,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () async {
          final profile = await di<SearchModel>().lookupProfile(user.id);
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (context) => ChatProfileDialog(userId: profile.userId),
            );
          }
        },
        child: ChatAvatar(
          avatarUri: user.avatarUrl,
          fallBackIconSize: 10,
          dimension: 15,
        ),
      ),
    );
  }
}
