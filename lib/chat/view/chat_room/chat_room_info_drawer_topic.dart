import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';

import '../../../common/view/ui_constants.dart';
import '../../timeline_model.dart';

class ChatRoomInfoDrawerTopic extends StatelessWidget with WatchItMixin {
  const ChatRoomInfoDrawerTopic({
    super.key,
    required this.room,
  });

  final Room room;

  @override
  Widget build(BuildContext context) {
    final updatingTimeline =
        watchPropertyValue((TimelineModel m) => m.getUpdatingTimeline(room.id));

    return SliverToBoxAdapter(
      child: Center(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: updatingTimeline ? 0 : 1,
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: kMediumPadding,
            ),
            child: ListTile(
              dense: true,
              title: Html(
                data: room.topic,
                style: {
                  'body': Style(
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                    textAlign: TextAlign.center,
                    fontSize: FontSize(12),
                  ),
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
