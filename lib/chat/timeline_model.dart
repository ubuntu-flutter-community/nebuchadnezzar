import 'package:matrix/matrix.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

class TimelineModel extends SafeChangeNotifier {
  // TIMELINES

  bool _updatingTimeline = false;
  bool get updatingTimeline => _updatingTimeline;
  void setUpdatingTimeline(bool value) {
    if (value == _updatingTimeline) return;
    _updatingTimeline = value;
    notifyListeners();
  }

  Future<void> requestHistory(
    Timeline timeline, {
    int historyCount = 50,
    StateFilter? filter,
    bool notify = true,
  }) async {
    if (notify) {
      setUpdatingTimeline(true);
    }
    if (timeline.isRequestingHistory) {
      setUpdatingTimeline(false);
      return;
    }
    await timeline.requestHistory(filter: filter, historyCount: historyCount);
    if (notify) {
      setUpdatingTimeline(false);
    }
    await timeline.setReadMarker();
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
