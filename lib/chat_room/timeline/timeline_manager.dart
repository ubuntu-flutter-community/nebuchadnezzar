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
    await requestHistory(timeline, historyCount: 500);
    await trySetReadMarker(timeline);
  }

  final Map<String, Timeline> _timelines = {};
  Timeline? getTimeline(String roomId) => _timelines[roomId];
  void _setTimeline({required Timeline timeline}) {
    _timelines[timeline.room.id] = timeline;
    notifyListeners();
  }

  final Map<String, bool> _updatingTimeline = {};
  bool getUpdatingTimeline(String? roomId) => _updatingTimeline[roomId] == true;
  void _setUpdatingTimeline({required String roomId, required bool value}) {
    if (_updatingTimeline[roomId] == value) return;
    _updatingTimeline[roomId] = value;
    notifyListeners();
  }

  Future<void> requestHistory(
    Timeline timeline, {
    int historyCount = 50,
    StateFilter? filter,
  }) async {
    _setUpdatingTimeline(roomId: timeline.room.id, value: true);
    _setTimeline(timeline: timeline);

    if (timeline.canRequestHistory) {
      try {
        await timeline.requestHistory(
          filter: filter,
          historyCount: historyCount,
        );
      } on Exception catch (e, s) {
        printMessageInDebugMode(e, s);
      }
    }

    _setUpdatingTimeline(roomId: timeline.room.id, value: false);
  }

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
