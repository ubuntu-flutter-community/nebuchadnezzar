import 'package:matrix/matrix.dart';

import '../../extensions/event_x.dart';

extension TimelineX on Timeline {
  List<Event> getMediaEvents(String messageType) => events
      .where(
        (e) =>
            e.type == EventTypes.Message &&
            e.messageType == messageType &&
            !e.isSvgImage,
      )
      .toList();
}
