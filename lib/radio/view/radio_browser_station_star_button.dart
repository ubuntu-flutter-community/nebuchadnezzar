import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../extensions/media_x.dart';
import '../../settings/settings_manager.dart';

class RadioBrowserStationStarButton extends StatelessWidget with WatchItMixin {
  const RadioBrowserStationStarButton({super.key, required this.media});

  final Media media;

  @override
  Widget build(BuildContext context) {
    final isFavorite = watchPropertyValue(
      (SettingsManager s) => s.isFavoriteStation(media.stationId!),
    );
    return IconButton(
      onPressed: () => isFavorite
          ? di<SettingsManager>().removeFavoriteStation(media.stationId!)
          : di<SettingsManager>().addFavoriteStation(media.stationId!),
      icon: Icon(isFavorite ? YaruIcons.star_filled : YaruIcons.star),
    );
  }
}
