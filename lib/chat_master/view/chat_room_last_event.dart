import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:flutter_it/flutter_it.dart';

import '../../chat_room/timeline/timeline_manager.dart';
import '../../extensions/event_x.dart';
import '../../l10n/l10n.dart';

class ChatRoomLastEvent extends StatefulWidget {
  const ChatRoomLastEvent({required this.lastEvent, super.key});

  final Event? lastEvent;

  @override
  State<ChatRoomLastEvent> createState() => _ChatRoomLastEventState();
}

class _ChatRoomLastEventState extends State<ChatRoomLastEvent> {
  @override
  void initState() {
    super.initState();
    di<TimelineManager>().loadSingleKeyForEvent(widget.lastEvent);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      key: ValueKey(
        '${widget.lastEvent?.eventId}_${widget.lastEvent?.type}_${widget.lastEvent?.redacted}}',
      ),
      future: widget.lastEvent?.calcLocalizedBody(
        const MatrixDefaultLocalizations(),
        hideReply: true,
        plaintextBody: true,
        withSenderNamePrefix: true,
      ),
      initialData: widget.lastEvent?.calcLocalizedBodyFallback(
        const MatrixDefaultLocalizations(),
        hideReply: true,
        plaintextBody: true,
        withSenderNamePrefix: true,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('?', maxLines: 1);
        }
        if (widget.lastEvent != null) {
          if (widget.lastEvent!.hideInTimeline(
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
