import 'package:matrix/matrix.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import '../../common/logging.dart';

class TimelineModel extends SafeChangeNotifier {
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

    if (!timeline.room.isArchived) {
      try {
        await timeline.requestHistory(
          filter: filter,
          historyCount: historyCount,
        );
        await timeline.room.requestParticipants();
      } on Exception catch (e, s) {
        printMessageInDebugMode(e, s);
      }
    }

    _setUpdatingTimeline(roomId: timeline.room.id, value: false);
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
}
