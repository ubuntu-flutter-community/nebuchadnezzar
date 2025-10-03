import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../player/data/station_media.dart';
import '../../settings/settings_manager.dart';

class RadioBrowserStationStarButton extends StatelessWidget with WatchItMixin {
  const RadioBrowserStationStarButton({super.key, required this.media});

  final StationMedia media;

  @override
  Widget build(BuildContext context) {
    final isFavorite = watchPropertyValue(
      (SettingsManager s) => s.isFavoriteStation(media.id),
    );
    return IconButton(
      onPressed: () => isFavorite
          ? di<SettingsManager>().removeFavoriteStation(media.id)
          : di<SettingsManager>().addFavoriteStation(media.id),
      icon: Icon(isFavorite ? YaruIcons.star_filled : YaruIcons.star),
    );
  }
}
