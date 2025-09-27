import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../authentication/authentication_service.dart';
import '../../../common/view/chat_avatar.dart';
import '../../../common/view/ui_constants.dart';
import '../create_room_manager.dart';

class CreateRoomProfilesListView extends StatelessWidget with WatchItMixin {
  const CreateRoomProfilesListView({super.key});

  @override
  Widget build(BuildContext context) {
    final profiles = watchValue((CreateRoomManager m) => m.profilesDraft);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: kMediumPadding,
        vertical: kBigPadding,
      ),
      itemCount: profiles.length,
      itemBuilder: (context, index) {
        final profile = profiles.elementAt(index);
        return ListTile(
          shape: const RoundedRectangleBorder(),
          contentPadding: EdgeInsets.zero,
          key: ValueKey(profile.userId),
          leading: ChatAvatar(avatarUri: profile.avatarUrl),
          title: Text(profile.displayName ?? profile.userId, maxLines: 1),
          subtitle: Text(profile.userId, maxLines: 1),
          trailing: profile.userId == di<AuthenticationService>().loggedInUserId
              ? null
              : IconButton(
                  onPressed: () =>
                      di<CreateRoomManager>().removeProfileFromDraft(profile),
                  icon: const Icon(YaruIcons.trash),
                ),
        );
      },
    );
  }
}
