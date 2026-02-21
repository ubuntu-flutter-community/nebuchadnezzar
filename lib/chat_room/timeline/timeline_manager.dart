import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import '../../common/logging.dart';
import '../../extensions/event_x.dart';

class TimelineManager extends SafeChangeNotifier {
  Future<Timeline> loadTimeline(
    Room room, {
    void Function(int)? onChange,
    void Function(int)? onRemove,
    void Function(int)? onInsert,
    void Function()? onNewEvent,
    void Function()? onUpdate,
    String? eventContextId,
    int? limit = Room.defaultHistoryCount,
  }) async {
    // This calls await postLoad() and then creates a new Timeline object
    final timeline = await room.getTimeline(
      onChange: onChange,
      onRemove: onRemove,
      onInsert: onInsert,
      onNewEvent: onNewEvent,
      onUpdate: onUpdate,
      eventContextId: eventContextId,
      limit: limit,
    );

    _setTimeline(timeline: timeline);
    return timeline;
  }

  Future<void> postTimelineLoad(Timeline timeline) async {
    _requestKeysForUndecryptableEvents(timeline);
    await getRequestHistoryCommand(
      timeline.room.id,
    ).runAsync((timeline: timeline, historyCount: 500, filter: null));
    await trySetReadMarker(timeline);
  }

  final Map<String, Timeline> _timelines = {};
  Timeline? getTimeline(String roomId) => _timelines[roomId];
  void _setTimeline({required Timeline timeline}) {
    _timelines[timeline.room.id] = timeline;
    notifyListeners();
  }

  void removeTimeline(String roomId) {
    _timelines.remove(roomId);
    _requestHistoryCommands.remove(roomId);
  }

  final _requestHistoryCommands =
      <
        String,
        Command<
          ({Timeline timeline, int historyCount, StateFilter? filter}),
          void
        >
      >{};
  Command<({Timeline timeline, int historyCount, StateFilter? filter}), void>
  getRequestHistoryCommand(String roomId) =>
      _requestHistoryCommands.putIfAbsent(
        roomId,
        () => Command.createAsync((param) async {
          final timeline = param.timeline;
          if (!timeline.canRequestHistory) {
            return;
          }

          if (timeline.isRequestingHistory) {
            await timeline.room.client.onHistoryEvent.stream
                .where((e) => e.roomId == timeline.room.id)
                .last;
          } else {
            await timeline.requestHistory(
              filter: param.filter,
              historyCount: param.historyCount,
            );
          }

          _setTimeline(timeline: timeline);
        }, initialValue: null),
      );

  Future<void> loadRoomStates(Room room) async {
    try {
      await room.postLoad();
    } on Exception catch (e, s) {
      printMessageInDebugMode(e, s);
    }
  }

  Future<void> trySetReadMarker(Timeline timeline, {String? eventId}) async {
    try {
      if (!timeline.room.isArchived) {
        String? maybeEventId;

        if (eventId != null) {
          final event = await timeline.room.getEventById(eventId);

          if (event?.status == EventStatus.synced) {
            maybeEventId = event?.eventId;
          }
        }

        await timeline.setReadMarker(eventId: maybeEventId);
      } else {
        printMessageInDebugMode(
          'Skipping setReadMarker() for "${timeline.room.getLocalizedDisplayname()}" as it is ${timeline.room.isArchived ? 'archived' : 'not unread'}.',
        );
      }
    } on Exception catch (e, s) {
      printMessageInDebugMode(e, s);
    }
  }

  // Request the keys for undecryptable events of this timeline
  void _requestKeysForUndecryptableEvents(Timeline timeline) {
    try {
      timeline.requestKeys(onlineKeyBackupOnly: false);
    } on Exception catch (e, s) {
      printMessageInDebugMode(e, s);
    }
  }

  final Set<String> _hasLoadedKeys = {};
  Future<void> loadSingleKeyForEvent(Event? event) async {
    if (event == null ||
        !event.isEncryptedAndCouldDecrypt ||
        _hasLoadedKeys.contains(event.eventId)) {
      return;
    }
    try {
      await event.requestKey();
      _hasLoadedKeys.add(event.eventId);

      printMessageInDebugMode(
        'Decrypted event ${event.eventId} in room ${event.room.getLocalizedDisplayname()}',
      );
    } on Exception catch (e, s) {
      printMessageInDebugMode(e, s);
    }
  }
}
