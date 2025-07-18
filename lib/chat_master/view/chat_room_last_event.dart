import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import '../../common/event_x.dart';
import '../../l10n/l10n.dart';

class ChatRoomLastEvent extends StatelessWidget {
  const ChatRoomLastEvent({required this.lastEvent, super.key});

  final Event? lastEvent;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      key: ValueKey(
        '${lastEvent?.eventId}_${lastEvent?.type}_${lastEvent?.redacted}}',
      ),
      future: lastEvent?.calcLocalizedBody(
        const MatrixDefaultLocalizations(),
        hideReply: true,
        plaintextBody: true,
        withSenderNamePrefix: true,
      ),
      initialData: lastEvent?.calcLocalizedBodyFallback(
        const MatrixDefaultLocalizations(),
        hideReply: true,
        plaintextBody: true,
        withSenderNamePrefix: true,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('?', maxLines: 1);
        }
        if (lastEvent != null) {
          if (lastEvent!.hideInTimeline(
            showAvatarChanges: false,
            showDisplayNameChanges: false,
          )) {
            return const Text('...', maxLines: 1);
          }
          if (snapshot.hasData) {
            return Text(snapshot.data!, maxLines: 1);
          }
        }

        return Text(context.l10n.emptyChat, maxLines: 1);
      },
    );
  }
}
