import 'package:matrix/matrix.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import '../../common/event_x.dart';
import '../../common/logging.dart';

class TimelineModel extends SafeChangeNotifier {
  Future<void> postTimelineLoad(Timeline timeline) async {
    await loadRoomStates(timeline.room);
    await loadAllKeysFromRoom(timeline);
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

  Future<void> trySetReadMarker(Timeline timeline) async {
    try {
      if (!timeline.room.isArchived && timeline.room.isUnread) {
        await timeline.setReadMarker();
      } else {
        printMessageInDebugMode(
          'Skipping setReadMarker() for "${timeline.room.getLocalizedDisplayname()}" as it is ${timeline.room.isArchived ? 'archived' : 'not unread'}.',
        );
      }
    } on Exception catch (e, s) {
      printMessageInDebugMode(e, s);
    }
  }

  Future<void> loadAllKeysFromRoom(Timeline timeline) async {
    try {
      for (final event
          in timeline.events
              .toList(growable: false)
              .where(
                (e) =>
                    e.isEncryptedAndCouldDecrypt &&
                    !_hasLoadedKeys.contains(e.eventId),
              )) {
        await event.requestKey();
        await timeline.room.client.encryption?.decryptRoomEvent(
          event,
          store: event.stateKey != null,
        );
        _hasLoadedKeys.add(event.eventId);
        printMessageInDebugMode(
          'Decrypted event ${event.eventId} in room ${timeline.room.getLocalizedDisplayname()}',
        );
      }
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
