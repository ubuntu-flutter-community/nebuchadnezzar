import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../player/data/unique_media.dart';
import '../radio_manager.dart';

class RadioBrowserStationStarButton extends StatelessWidget with WatchItMixin {
  const RadioBrowserStationStarButton({super.key, required this.media});

  final UniqueMedia media;

  @override
  Widget build(BuildContext context) {
    final isFavorite = watchValue(
      (RadioManager s) => s.favoriteStationsCommand.select(
        (favorites) => favorites.any((m) => m.id == media.id),
      ),
    );
    return IconButton(
      onPressed: () => isFavorite
          ? di<RadioManager>().removeFavoriteStation(media.id)
          : di<RadioManager>().addFavoriteStation(media.id),
      icon: Icon(isFavorite ? YaruIcons.star_filled : YaruIcons.star),
    );
  }
}
