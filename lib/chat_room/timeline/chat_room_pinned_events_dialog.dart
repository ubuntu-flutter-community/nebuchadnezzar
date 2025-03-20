import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../../common/chat_model.dart';
import '../../events/view/chat_event_tile.dart';

class ChatRoomPinnedEventsDialog extends StatelessWidget with WatchItMixin {
  const ChatRoomPinnedEventsDialog({
    super.key,
    required this.timeline,
  });

  final Timeline timeline;

  @override
  Widget build(BuildContext context) {
    final pinnedEvents = watchStream(
          (ChatModel m) => m
              .getJoinedRoomUpdate(timeline.room.id)
              .map((_) => timeline.room.pinnedEventIds),
          initialValue: timeline.room.pinnedEventIds,
        ).data ??
        [];
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      title: YaruDialogTitleBar(
        title: Text(context.l10n.pin),
        backgroundColor: Colors.transparent,
        border: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: kBigPadding),
      content: SizedBox(
        height: 400,
        width: 400,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: kBigPadding),
          itemCount: pinnedEvents.length,
          itemBuilder: (context, index) => ChatRoomPinnedEventTile(
            eventId: pinnedEvents.elementAt(index),
            timeline: timeline,
          ),
        ),
      ),
    );
  }
}

class ChatRoomPinnedEventTile extends StatefulWidget {
  const ChatRoomPinnedEventTile({
    super.key,
    required this.timeline,
    required this.eventId,
  });

  final Timeline timeline;
  final String eventId;

  @override
  State<ChatRoomPinnedEventTile> createState() =>
      _ChatRoomPinnedEventTileState();
}

class _ChatRoomPinnedEventTileState extends State<ChatRoomPinnedEventTile> {
  late Future<Event?> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.timeline.room.getEventById(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (c, s) => s.hasData
          ? ChatEventTile(
              event: s.data!,
              timeline: widget.timeline,
              onReplyOriginClick: (p0) async {},
            )
          : const Text(''),
    );
  }
}
