import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/ui_constants.dart';
import '../../extensions/duration_x.dart';
import '../../radio/view/radio_browser_station_star_button.dart';
import '../data/local_media.dart';
import '../data/station_media.dart';
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
      preserveState: false,
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
                (media is LocalMedia ? media.artist : media.title) ?? 'Unknown',
                maxLines: 1,
                style: (artistStyle ?? textTheme.labelSmall)?.copyWith(
                  color: textColor,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                (media is LocalMedia ? media.title : remoteTitle) ??
                    media.title ??
                    'Unknown',
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
        if (media is StationMedia) RadioBrowserStationStarButton(media: media),
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
    final duration = watchValue((PlayerManager p) => p.duration);

    final position = watchValue((PlayerManager p) => p.position);

    final positionWidth = (position.inHours > 0) ? 48.0 : 35.0;
    final durationWidth = (duration.inHours > 0) ? 48.0 : 35.0;

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
                position.formattedTime,
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
                duration.formattedTime,
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
