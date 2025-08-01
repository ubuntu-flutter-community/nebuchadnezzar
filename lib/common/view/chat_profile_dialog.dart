import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../app/view/error_page.dart';
import '../../authentication/authentication_model.dart';
import '../../chat_room/create_or_edit/create_or_edit_room_model.dart';
import '../../l10n/l10n.dart';
import '../../settings/view/chat_settings_dialog.dart';
import '../chat_model.dart';
import '../search_model.dart';
import 'build_context_x.dart';
import 'chat_avatar.dart';
import 'common_widgets.dart';
import 'ui_constants.dart';

class ChatProfileDialog extends StatelessWidget {
  const ChatProfileDialog({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(children: [ChatProfile(userId: userId)]);
  }
}

class ChatProfile extends StatefulWidget {
  const ChatProfile({super.key, required this.userId, this.showButton = true});

  final String userId;
  final bool showButton;

  @override
  State<ChatProfile> createState() => _ChatProfileState();
}

class _ChatProfileState extends State<ChatProfile> {
  late final Future<Profile> _future;

  @override
  void initState() {
    super.initState();
    _future = di<SearchModel>().lookupProfile(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorBody(error: snapshot.error.toString());
        }

        final myProfile =
            snapshot.hasData &&
            snapshot.data!.userId == di<AuthenticationModel>().loggedInUserId;
        return SizedBox(
          height: 300,
          width: 200,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                top: kBigPadding,
                left: kBigPadding,
                right: kBigPadding,
                bottom: kSmallPadding,
              ),
              child: snapshot.hasData
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ChatAvatar(
                          fallBackIconSize: 80,
                          dimension: 120,
                          avatarUri: snapshot.data?.avatarUrl,
                        ),
                        Column(
                          spacing: kSmallPadding,
                          children: [
                            Text(
                              snapshot.data!.userId,
                              textAlign: TextAlign.center,
                              style: context.theme.textTheme.bodyMedium,
                            ),
                            Text(
                              snapshot.data!.displayName ?? '',
                              textAlign: TextAlign.center,
                              style: context.theme.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        if (widget.showButton)
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
                                      builder: (context) =>
                                          const ChatSettingsDialog(),
                                    );
                                  } else {
                                    showFutureLoadingDialog(
                                      context: context,
                                      future: () => di<CreateOrEditRoomModel>()
                                          .startOrGetDirectChat(
                                            snapshot.data!.userId,
                                          ),
                                    ).then((result) {
                                      if (result.asValue?.value != null) {
                                        di<ChatModel>().setSelectedRoom(
                                          result.asValue!.value!,
                                        );
                                      }
                                    });
                                  }
                                },
                                label: Text(
                                  !myProfile
                                      ? l10n.startConversation
                                      : l10n.settings,
                                ),
                              ),
                            ),
                          ),
                      ],
                    )
                  : const Center(child: Progress()),
            ),
          ),
        );
      },
    );
  }
}
