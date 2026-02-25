import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../app/view/error_page.dart';
import '../../authentication/authentication_service.dart';
import '../../chat_room/create_or_edit/create_room_manager.dart';
import '../../l10n/l10n.dart';
import '../../settings/view/chat_settings_dialog.dart';
import '../chat_manager.dart';
import '../search_manager.dart';
import 'build_context_x.dart';
import 'chat_avatar.dart';
import 'common_widgets.dart';
import 'confirm.dart';
import 'ui_constants.dart';

class ChatProfileDialog extends StatelessWidget {
  const ChatProfileDialog({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) => SimpleDialog(
    children: [
      SizedBox(width: 200, height: 300, child: ChatProfile(userId: userId)),
    ],
  );
}

class ChatProfile extends StatelessWidget with WatchItMixin {
  const ChatProfile({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;

    callOnceAfterThisBuild(
      (context) => di<SearchManager>().lookupProfileCommand.run(userId),
    );

    final results = watchValue(
      (SearchManager m) => m.lookupProfileCommand.results,
    );

    final profile = results.data;

    final errors = results.error;

    if (!results.isRunning && errors != null) {
      return ErrorBody(error: errors.toString());
    }

    if (profile == null || results.isRunning) {
      return const Center(child: Progress());
    }

    final myProfile =
        profile.userId == di<AuthenticationService>().loggedInUserId;

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          top: kBigPadding,
          left: kBigPadding,
          right: kBigPadding,
          bottom: kSmallPadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ChatAvatar(
              fallBackIconSize: 80,
              dimension: 120,
              avatarUri: profile.avatarUrl,
            ),
            Column(
              spacing: kSmallPadding,
              children: [
                Text(
                  profile.userId,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  profile.displayName ?? '',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
            Flexible(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: myProfile
                      ? const Icon(YaruIcons.settings)
                      : const Icon(YaruIcons.chat_bubble),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (myProfile) {
                      showDialog(
                        context: context,
                        builder: (context) => const ChatSettingsDialog(),
                      );
                    } else {
                      di<ChatManager>().setSelectedRoom(null);
                      di<CreateRoomManager>().createOrGetDirectChatCommand.run(
                        profile.userId,
                      );
                    }
                  },
                  label: Text(
                    !myProfile ? l10n.startConversation : l10n.settings,
                  ),
                ),
              ),
            ),
            if (!myProfile)
              Flexible(
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: Icon(
                      YaruIcons.emote_shutmouth,
                      color: theme.colorScheme.error,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      ConfirmationDialog.show(
                        context: context,
                        title: Text(
                          l10n.blockUsername(
                            profile.displayName ?? profile.userId,
                          ),
                        ),
                        content: Text(profile.displayName ?? profile.userId),
                        onConfirm: () => di<SearchManager>()
                            .ignoreProfileCommand
                            .run(profile.userId),
                      );
                    },
                    label: Text(
                      l10n.block,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.error,
                      ),
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
