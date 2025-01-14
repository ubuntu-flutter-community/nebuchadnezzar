import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../common/view/build_context_x.dart';
import '../../../common/view/common_widgets.dart';
import '../../../common/view/snackbars.dart';
import '../../../common/view/ui_constants.dart';
import '../chat_model.dart';
import '../search_model.dart';
import 'chat_avatar.dart';

class ChatProfileDialog extends StatelessWidget {
  const ChatProfileDialog({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        ChatProfile(userId: userId),
      ],
    );
  }
}

class ChatProfile extends StatefulWidget {
  const ChatProfile({
    super.key,
    required this.userId,
    this.showButton = true,
  });

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
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) => SizedBox(
        height: 350,
        width: 200,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(kBigPadding),
            child: snapshot.hasData
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(
                        child: ChatAvatar(
                          fallBackIconSize: 80,
                          dimension: 120,
                          avatarUri: snapshot.data?.avatarUrl,
                        ),
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
                      if (widget.showButton &&
                          snapshot.data!.userId != di<ChatModel>().myUserId)
                        Flexible(
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(YaruIcons.chat_bubble),
                              onPressed: () {
                                Navigator.of(context).pop();
                                di<ChatModel>().joinDirectChat(
                                  snapshot.data!.userId,
                                  onFail: (error) => showSnackBar(
                                    context,
                                    content: Text(error),
                                  ),
                                );
                              },
                              label: const Text('Start direct chat'),
                            ),
                          ),
                        ),
                    ],
                  )
                : const Center(child: Progress()),
          ),
        ),
      ),
    );
  }
}
