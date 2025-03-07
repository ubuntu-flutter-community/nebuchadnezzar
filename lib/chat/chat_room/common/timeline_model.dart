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
    if (timeline.isRequestingHistory || !timeline.canRequestHistory) {
      return;
    }

    if (notify) {
      setUpdatingTimeline(roomId: timeline.room.id, value: true);
    }

    await timeline.requestHistory(filter: filter, historyCount: historyCount);
    await timeline.room.requestParticipants();
    if (notify) {
      setUpdatingTimeline(roomId: timeline.room.id, value: false);
    }
    if (!timeline.room.isArchived) {
      await timeline.setReadMarker();
    }
  }
}
