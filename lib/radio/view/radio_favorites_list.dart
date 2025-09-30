import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:watch_it/watch_it.dart';

import '../../common/view/common_widgets.dart';
import '../../common/view/ui_constants.dart';
import '../../extensions/media_x.dart';
import '../../player/player_manager.dart';
import '../../settings/settings_manager.dart';
import '../radio_service.dart';
import 'radio_browser_station_star_button.dart';
import 'radio_host_not_connected_content.dart';
import 'remote_media_list_tile_image.dart';

class RadioFavoritesList extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const RadioFavoritesList({super.key});

  @override
  State<RadioFavoritesList> createState() => _RadioFavoritesListState();
}

class _RadioFavoritesListState extends State<RadioFavoritesList> {
  Future<List<Media>>? _future;

  @override
  void initState() {
    super.initState();
    _future = _loadFavorites();
  }

  Future<List<Media>> _loadFavorites() async {
    final favoriteStations = di<SettingsManager>().favoriteStations;
    return Future.wait(
      favoriteStations.map((stationId) async {
        Media? media;
        media = MediaX.getMediaByUuid(stationId);
        if (media == null) {
          final station = await di<RadioService>().getStationByUUID(stationId);
          if (station != null) {
            media = MediaX.fromStation(station);
            MediaX.addToCache(media);
          }
        }
        return Future.value(media);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final radioHostConnected =
        watchStream(
          (RadioService m) => m.hostConnectionChanges,
          initialValue: di<RadioService>().connectedHost != null,
          preserveState: false,
        ).data ??
        false;

    if (!radioHostConnected) {
      return RadioHostNotConnectedContent(
        onRetry: () async {
          await di<RadioService>().init();
          setState(() => _future = _loadFavorites());
        },
      );
    }

    return FutureBuilder<List<Media>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: Progress());
        }

        final favorites = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.only(top: kBigPadding),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final media = favorites[index];
            return ListTile(
              key: ValueKey(media.stationId),
              title: Text(media.title),
              minLeadingWidth: kDefaultTileLeadingDimension,
              leading: RemoteMediaListTileImage(media: media),
              trailing: RadioBrowserStationStarButton(media: media),
              onTap: () => di<PlayerManager>().setPlaylist([media]),
            );
          },
        );
      },
    );
  }
}
