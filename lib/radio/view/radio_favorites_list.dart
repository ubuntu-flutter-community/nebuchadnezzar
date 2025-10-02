import 'dart:async';

import 'package:flutter/material.dart';
import 'package:listen_it/listen_it.dart';
import 'package:media_kit/media_kit.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/common_widgets.dart';
import '../../common/view/ui_constants.dart';
import '../../extensions/media_x.dart';
import '../../l10n/l10n.dart';
import '../../player/player_manager.dart';
import '../../settings/settings_manager.dart';
import '../radio_service.dart';
import 'radio_browser_station_star_button.dart';
import 'radio_host_not_connected_content.dart';
import 'remote_media_list_tile_image.dart';

class RadioFavoritesList extends StatefulWidget {
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
          }
        }
        return Future.value(media);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Media>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return RadioHostNotConnectedContent(
            message: 'Error: ${snapshot.error}',
            onRetry: () async {
              await di<RadioService>().init();
              setState(() => _future = _loadFavorites());
            },
          );
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
            return Padding(
              padding: const EdgeInsets.only(bottom: kSmallPadding),
              child: _RadioFavoriteListTile(
                key: ValueKey(media.stationId ?? media.uri),
                media: media,
              ),
            );
          },
        );
      },
    );
  }
}

class _RadioFavoriteListTile extends StatelessWidget with WatchItMixin {
  const _RadioFavoriteListTile({super.key, required this.media});

  final Media media;

  @override
  Widget build(BuildContext context) {
    final isCurrentlyPlaying =
        watchStream(
          (PlayerManager p) => p.playlistStream,
          initialValue: di<PlayerManager>().playlist,
          preserveState: false,
        ).data?.medias.asMap().entries.any(
          (entry) =>
              entry.value.uri == media.uri &&
              entry.key == di<PlayerManager>().playlistIndex,
        ) ??
        false;

    final selectedColor = watchValue(
      (PlayerManager p) => p.playerViewState.select((e) => e.color),
    );

    return ListTile(
      title: Text(media.title),
      subtitle: Text(media.getRemoteTags(5) ?? context.l10n.radioStation),
      minLeadingWidth: kDefaultTileLeadingDimension,
      leading: RemoteMediaListTileImage(media: media),
      trailing: RadioBrowserStationStarButton(media: media),
      selected: isCurrentlyPlaying,
      selectedColor: context.colorScheme.isLight
          ? Colors.black
          : selectedColor?.scale(lightness: 0.3, saturation: 0.3),
      onTap: () => di<PlayerManager>().setPlaylist([media]),
    );
  }
}
