import 'package:matrix/matrix.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

class TimelineModel extends SafeChangeNotifier {
  final Map<String, bool> _updatingTimeline = {};
  bool getUpdatingTimeline(String roomId) => _updatingTimeline[roomId] == true;
  void setUpdatingTimeline({
    required String roomId,
    required bool value,
  }) {
    if (_updatingTimeline[roomId] == value) return;
    _updatingTimeline[roomId] = value;
    notifyListeners();
  }

  Future<void> requestHistory(
    Timeline timeline, {
    int historyCount = 50,
    StateFilter? filter,
    bool notify = true,
  }) async {
    if (notify) {
      setUpdatingTimeline(roomId: timeline.room.id, value: true);
    }
    if (timeline.isRequestingHistory) {
      setUpdatingTimeline(roomId: timeline.room.id, value: false);
      return;
    }
    await timeline.requestHistory(filter: filter, historyCount: historyCount);
    if (notify) {
      setUpdatingTimeline(roomId: timeline.room.id, value: false);
    }
    if (!timeline.room.isArchived) {
      await timeline.setReadMarker();
    }
  }

  bool _timelineSearchActive = false;
  bool get timelineSearchActive => _timelineSearchActive;
  void toggleTimelineSearch({bool? value}) {
    bool theValue = value ?? !_timelineSearchActive;
    if (theValue == _timelineSearchActive) return;
    _timelineSearchActive = theValue;
    notifyListeners();
  }
}
