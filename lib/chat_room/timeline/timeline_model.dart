import 'package:matrix/matrix.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

class TimelineModel extends SafeChangeNotifier {
  final Map<String, String> _timelineQuery = {};
  String? getTimelineQuery(String roomId) => _timelineQuery[roomId];
  void setTimelineQuery({required String roomId, required String query}) {
    if (query == _timelineQuery[roomId]) return;
    _timelineQuery[roomId] = query;
    notifyListeners();
  }

  final Map<String, bool> _timelineSearchActive = {};
  bool getTimelineSearchActive(String roomId) =>
      _timelineSearchActive[roomId] == true;
  void setTimelineSearchActive({required String roomId, required bool value}) {
    if (_timelineSearchActive[roomId] == value) return;
    _timelineSearchActive[roomId] = value;
    notifyListeners();
  }

  final Map<String, Timeline> _timelines = {};
  Timeline? getTimeline(String roomId) => _timelines[roomId];
  void addTimeline({required Timeline timeline}) {
    if (_timelines[timeline.room.id] == null) {
      _timelines[timeline.room.id] = timeline;
    }
    notifyListeners();
  }

  final Map<String, bool> _updatingTimeline = {};
  bool getUpdatingTimeline(String? roomId) => _updatingTimeline[roomId] == true;
  void setUpdatingTimeline({required String roomId, required bool value}) {
    if (_updatingTimeline[roomId] == value) return;
    _updatingTimeline[roomId] = value;
    notifyListeners();
  }

  Future<void> requestHistory(
    Timeline timeline, {
    int historyCount = 50,
    StateFilter? filter,
  }) async {
    addTimeline(timeline: timeline);
    if (!timeline.room.isArchived) {
      await timeline.setReadMarker();
    }

    if (!timeline.canRequestHistory) {
      setUpdatingTimeline(roomId: timeline.room.id, value: false);
      return;
    }

    if (timeline.isRequestingHistory) {
      setUpdatingTimeline(roomId: timeline.room.id, value: true);
      return;
    }

    setUpdatingTimeline(roomId: timeline.room.id, value: true);

    await timeline.requestHistory(filter: filter, historyCount: historyCount);
    await timeline.room.requestParticipants();
    setUpdatingTimeline(roomId: timeline.room.id, value: false);
  }
}
