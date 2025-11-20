import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../player/data/unique_media.dart';
import '../../settings/settings_manager.dart';

class RadioBrowserStationStarButton extends StatelessWidget with WatchItMixin {
  const RadioBrowserStationStarButton({super.key, required this.media});

  final UniqueMedia media;

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
