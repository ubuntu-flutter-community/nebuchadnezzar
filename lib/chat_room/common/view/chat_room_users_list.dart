import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../common/user_x.dart';
import '../../../common/view/build_context_x.dart';
import '../../../common/view/chat_avatar.dart';
import '../../../common/view/chat_profile_dialog.dart';
import '../../../common/view/common_widgets.dart';
import '../../../common/view/confirm.dart';
import '../../../common/view/ui_constants.dart';
import '../../../l10n/l10n.dart';
import '../../create_or_edit/create_or_edit_room_model.dart';

class ChatRoomUsersList extends StatelessWidget with WatchItMixin {
  const ChatRoomUsersList({
    super.key,
    required this.room,
    this.sliver = true,
    this.showTrailing = true,
  });

  final Room room;
  final bool sliver;
  final bool showTrailing;

  @override
  Widget build(BuildContext context) {
    final membershipFilter = [Membership.join, Membership.invite];

    final users = watchStream(
      (CreateOrEditRoomModel m) => m.getUsersStreamOfJoinedRoom(
        room,
        membershipFilter: membershipFilter,
      ),
      initialValue: room.getParticipants(membershipFilter),
      preserveState: false,
    ).data?.sorted((a, b) => b.powerLevel.compareTo(a.powerLevel));

    if (users == null || users.isEmpty) {
      if (!sliver) {
        return const Center(child: Progress());
      }

      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: Progress()),
      );
    }

    _UserTile itemBuilder(BuildContext context, int index) {
      final user = users.elementAt(index);
      final l10n = context.l10n;
      return _UserTile(
        key: ValueKey('invited${user.id}'),
        user: user,
        trailing: showTrailing
            ? Row(
                mainAxisSize: MainAxisSize.min,
                spacing: kSmallPadding,
                children: [
                  if (room.canKick && !user.isLoggedInUser)
                    IconButton(
                      tooltip: l10n.kickFromChat,
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => ConfirmationDialog(
                          title: Text(l10n.kickFromChat),
                          content: Text(user.id),
                          onConfirm: () => room.kick(user.id),
                        ),
                      ),
                      icon: Icon(
                        YaruIcons.trash,
                        color: context.colorScheme.error,
                      ),
                    ),
                  if (room.canBan && !user.isLoggedInUser)
                    IconButton(
                      tooltip: context.l10n.banFromChat,
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => ConfirmationDialog(
                          title: Text(l10n.banFromChat),
                          content: Text(user.id),
                          onConfirm: () => room.ban(user.id),
                        ),
                      ),
                      icon: Icon(
                        YaruIcons.private_mask,
                        color: context.colorScheme.error,
                      ),
                    ),
                ],
              )
            : const SizedBox.shrink(),
      );
    }

    if (sliver) {
      return SliverList.builder(
        itemCount: users.length,
        itemBuilder: itemBuilder,
      );
    }

    return ListView.builder(itemCount: users.length, itemBuilder: itemBuilder);
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({super.key, required this.user, this.trailing});

  final User user;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => ListTile(
    key: key,
    leading: Opacity(
      opacity: user.membership == Membership.invite ? 0.5 : 1,
      child: ChatAvatar(
        avatarUri: user.avatarUrl,
        onTap: () => showDialog(
          context: context,
          builder: (context) => ChatProfileDialog(userId: user.id),
        ),
      ),
    ),
    title: Text(user.displayName ?? user.id),
    subtitle: user.membership == Membership.invite
        ? Text(context.l10n.invited)
        : Text(
            user.powerLevel == 0
                ? context.l10n.participant
                : context.l10n.admin,
          ),
    trailing: trailing,
  );
}
