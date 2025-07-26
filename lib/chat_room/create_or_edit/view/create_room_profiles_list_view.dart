import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../authentication/authentication_model.dart';
import '../../../common/view/chat_avatar.dart';
import '../../../common/view/ui_constants.dart';
import '../create_or_edit_room_model.dart';

class CreateRoomProfilesListView extends StatelessWidget with WatchItMixin {
  const CreateRoomProfilesListView({super.key});

  @override
  Widget build(BuildContext context) {
    final profiles = watchPropertyValue(
      (CreateOrEditRoomModel m) => m.profilesDraft,
    );
    final length = watchPropertyValue(
      (CreateOrEditRoomModel m) => m.profilesDraft.length,
    );

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: kMediumPadding,
        vertical: kBigPadding,
      ),
      itemCount: length,
      itemBuilder: (context, index) {
        final profile = profiles.elementAt(index);
        return ListTile(
          shape: const RoundedRectangleBorder(),
          contentPadding: EdgeInsets.zero,
          key: ValueKey(profile.userId),
          leading: ChatAvatar(avatarUri: profile.avatarUrl),
          title: Text(profile.displayName ?? profile.userId, maxLines: 1),
          subtitle: Text(profile.userId, maxLines: 1),
          trailing: profile.userId == di<AuthenticationModel>().loggedInUserId
              ? null
              : IconButton(
                  onPressed: () => di<CreateOrEditRoomModel>()
                      .removeProfileFromDraft(profile),
                  icon: const Icon(YaruIcons.trash),
                ),
        );
      },
    );
  }
}
