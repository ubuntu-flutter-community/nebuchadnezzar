import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/common_widgets.dart';
import '../../common/view/ui_constants.dart';
import '../timeline/timeline_manager.dart';

class ChatRoomInfoDrawerMediaGridHeadline extends StatelessWidget
    with WatchItMixin {
  const ChatRoomInfoDrawerMediaGridHeadline({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    final updating = watchPropertyValue(
      (TimelineManager m) => m.getUpdatingTimeline(room.id),
    );
    return Row(
      spacing: kSmallPadding,
      children: [
        const Icon(YaruIcons.image),
        Text('Media', style: context.textTheme.titleSmall),
        if (updating)
          const SizedBox.square(dimension: 15, child: Progress(strokeWidth: 2)),
      ],
    );
  }
}
