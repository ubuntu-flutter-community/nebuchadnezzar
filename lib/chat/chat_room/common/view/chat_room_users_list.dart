import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../../common/view/build_context_x.dart';
import '../../../../common/view/common_widgets.dart';
import '../../../../common/view/snackbars.dart';

import '../../../common/chat_model.dart';
import '../../../common/view/chat_avatar.dart';

class ChatRoomUsersList extends StatelessWidget with WatchItMixin {
  const ChatRoomUsersList({
    super.key,
    required this.room,
    this.sliver = true,
    this.showChatIcon = true,
  });

  final Room room;
  final bool sliver;
  final bool showChatIcon;

  @override
  Widget build(BuildContext context) {
    final membershipFilter = [Membership.join];

    final users = watchStream(
      (ChatModel m) => m.getUsersStreamOfJoinedRoom(
        room,
        membershipFilter: membershipFilter,
      ),
      initialValue: room.getParticipants(membershipFilter),
      preserveState: false,
    ).data?.sorted(
          (a, b) => b.powerLevel.compareTo(a.powerLevel),
        );

    if (users == null || users.isEmpty) {
      if (!sliver) {
        return const Center(
          child: Progress(),
        );
      }

      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Progress(),
        ),
      );
    }

    _UserTile itemBuilder(BuildContext context, int index) {
      final user = users.elementAt(index);
      return _UserTile(
        showChatIcon: showChatIcon,
        key: ValueKey('invited${user.id}'),
        user: user,
        trailing: !showChatIcon && room.canKick
            ? IconButton(
                onPressed: () => room.kick(user.id),
                icon: Icon(
                  YaruIcons.trash,
                  color: context.colorScheme.error,
                ),
              )
            : null,
      );
    }

    if (sliver) {
      return SliverList.builder(
        itemCount: users.length,
        itemBuilder: itemBuilder,
      );
    }

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: itemBuilder,
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({
    super.key,
    required this.user,
    this.trailing,
    required this.showChatIcon,
  });

  final User user;
  final Widget? trailing;
  final bool showChatIcon;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final chatModel = di<ChatModel>();
    return ListTile(
      key: key,
      leading: Opacity(
        opacity: user.membership == Membership.invite ? 0.5 : 1,
        child: ChatAvatar(
          avatarUri: user.avatarUrl,
        ),
      ),
      title: Text(user.displayName ?? user.id),
      subtitle: user.membership == Membership.invite
          ? Text(l10n.invited)
          : Text(
              user.powerLevel == 0
                  ? context.l10n.participant
                  : context.l10n.admin,
            ),
      trailing: trailing ??
          (user.id == chatModel.myUserId || !showChatIcon
              ? null
              : IconButton(
                  onPressed: () => chatModel.joinDirectChat(
                    user.id,
                    onFail: (error) => showSnackBar(
                      context,
                      content: Text(error.toString()),
                    ),
                  ),
                  icon: const Icon(
                    YaruIcons.chat_bubble,
                  ),
                )),
    );
  }
}
