import 'package:matrix/matrix.dart';

import '../../common/event_x.dart';

extension TimelineX on Timeline {
  List<Event> get imageEvents => events
      .where(
        (e) =>
            e.type == EventTypes.Message &&
            e.messageType == MessageTypes.Image &&
            !e.isSvgImage,
      )
      .toList();
}
