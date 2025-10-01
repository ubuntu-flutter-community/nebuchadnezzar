import 'package:flutter/material.dart';
import 'package:listen_it/listen_it.dart';
import 'package:watch_it/watch_it.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/ui_constants.dart';
import '../../extensions/duration_x.dart';
import '../../extensions/media_x.dart';
import '../../radio/view/radio_browser_station_star_button.dart';
import '../player_manager.dart';

class PlayerTrackInfo extends StatelessWidget with WatchItMixin {
  const PlayerTrackInfo({
    super.key,
    required this.textColor,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.artistStyle,
    this.titleStyle,
    this.durationStyle,
  });

  final Color textColor;
  final CrossAxisAlignment crossAxisAlignment;
  final TextStyle? artistStyle;
  final TextStyle? titleStyle;
  final TextStyle? durationStyle;

  @override
  Widget build(BuildContext context) {
    final media = watchStream(
      (PlayerManager p) => p.currentMediaStream,
      initialValue: di<PlayerManager>().currentMedia,
      preserveState: true,
    ).data;

    if (media == null) {
      return const SizedBox.shrink();
    }

    final textTheme = context.textTheme;

    final remoteTitle = watchValue(
      (PlayerManager p) => p.playerViewState.select((e) => e.remoteSourceTitle),
    );

    return Row(
      spacing: kSmallPadding,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: crossAxisAlignment,
            children: [
              Text(
                media.isLocal ? media.artist : media.title,
                maxLines: 1,
                style: (artistStyle ?? textTheme.labelSmall)?.copyWith(
                  color: textColor,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                media.isLocal ? media.title : remoteTitle ?? media.title,
                maxLines: 1,
                style: (titleStyle ?? textTheme.labelSmall)?.copyWith(
                  color: textColor,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              PlayerTrackProgressTimeText(
                durationStyle: durationStyle,
                textColor: textColor,
              ),
            ],
          ),
        ),
        if (!media.isLocal) RadioBrowserStationStarButton(media: media),
      ],
    );
  }
}

class PlayerTrackProgressTimeText extends StatelessWidget with WatchItMixin {
  const PlayerTrackProgressTimeText({
    super.key,
    this.durationStyle,
    this.textColor,
  });

  final TextStyle? durationStyle;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final position = watchStream(
      (PlayerManager p) => p.positionStream,
      initialValue: di<PlayerManager>().position,
      preserveState: true,
    ).data;

    final duration = watchStream(
      (PlayerManager p) => p.durationStream,
      initialValue: di<PlayerManager>().duration,
      preserveState: true,
    ).data;

    final positionWidth = (position?.inHours != null && position!.inHours > 0)
        ? 48.0
        : 35.0;
    final durationWidth = (duration?.inHours != null && duration!.inHours > 0)
        ? 48.0
        : 35.0;

    const slashWidth = 5.0;

    const height = 13.0;

    return SizedBox(
      width: positionWidth + durationWidth + slashWidth,
      height: 16,
      child: Row(
        children: [
          RepaintBoundary(
            child: SizedBox(
              width: positionWidth,
              height: height,
              child: Text(
                (position ?? Duration.zero).formattedTime,
                style: (durationStyle ?? textTheme.labelSmall)?.copyWith(
                  color: textColor,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          SizedBox(
            height: height,
            width: slashWidth,
            child: Text('/', style: durationStyle),
          ),
          RepaintBoundary(
            child: SizedBox(
              width: durationWidth,
              height: height,
              child: Text(
                (duration ?? Duration.zero).formattedTime,
                style: (durationStyle ?? textTheme.labelSmall)?.copyWith(
                  color: textColor,
                  overflow: TextOverflow.ellipsis,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
