// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';

import '../../common/view/confirm.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../account_manager.dart';

class ChatSettingsPusherList extends StatelessWidget with WatchItMixin {
  const ChatSettingsPusherList({super.key});

  @override
  Widget build(BuildContext context) {
    callOnce((context) => di<AccountManager>().getPushers());

    final pushersFromStream = watchStream(
      (AccountManager c) => c.pusherStream,
      preserveState: false,
    ).data;

    final pushersFromFuture = watchFuture(
      (AccountManager c) => c.pushersFuture,
      preserveState: false,
      initialValue: [],
    ).data;

    final pushers = pushersFromStream ?? pushersFromFuture ?? [];

    return ListView.builder(
      shrinkWrap: true,
      itemCount: pushers.length,
      itemBuilder: (context, i) {
        final pusher = pushers[i];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: kMediumPadding,
            vertical: kSmallPadding,
          ),
          title: Text('${pusher.appDisplayName} - ${pusher.appId}'),
          subtitle: Text(pusher.data.url.toString()),
          onTap: () => ConfirmationDialog.show(
            context: context,
            title: Text('${context.l10n.delete}: ${pusher.deviceDisplayName}'),
            content: Text('${pusher.appDisplayName} (${pusher.appId})'),
            onConfirm: () => di<Client>().deletePusher(
              PusherId(appId: pusher.appId, pushkey: pusher.pushkey),
            ),
          ),
        );
      },
    );
  }
}
