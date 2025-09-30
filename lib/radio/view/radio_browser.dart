import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../../extensions/media_x.dart';
import '../../l10n/l10n.dart';
import '../../player/player_manager.dart';
import '../../player/view/player_control_mixin.dart';
import '../radio_service.dart';
import 'radio_browser_station_star_button.dart';
import 'radio_host_not_connected_content.dart';
import 'remote_media_list_tile_image.dart';

class RadioBrowser extends StatefulWidget with WatchItStatefulWidgetMixin {
  const RadioBrowser({super.key});

  @override
  State<RadioBrowser> createState() => _RadioBrowserState();
}

class _RadioBrowserState extends State<RadioBrowser> with PlayerControlMixin {
  late Future<List<Media>> _future;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    if (di<RadioService>().connectedHost != null) {
      _future = _loadMedia();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<List<Media>> _loadMedia({
    String? country,
    String? name,
    String? state,
    String? tag,
    String? language,
  }) async {
    final result = await di<RadioService>().search(
      country: country,
      name: name,
      state: state,
      tag: tag,
      language: language,
    );
    return result?.map((e) => MediaX.fromStation(e)).toList() ?? [];
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
          setState(() {
            _future = _loadMedia();
          });
        },
      );
    }

    return Column(
      spacing: kMediumPadding,
      children: [
        const SizedBox(height: kMediumPadding),
        TextField(
          decoration: InputDecoration(
            labelText: context.l10n.search,
            suffixIcon: IconButton(
              style: textFieldSuffixStyle,
              icon: const Icon(YaruIcons.edit_clear),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _future = Future.value([]);
                });
              },
            ),
          ),
          controller: _searchController,
          onChanged: (value) {
            if (_debounce?.isActive ?? false) _debounce!.cancel();
            _debounce = Timer(const Duration(milliseconds: 500), () {
              setState(() {
                _future = _loadMedia(name: value.isEmpty ? null : value);
              });
            });
          },
        ),
        Expanded(
          child: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                itemBuilder: (context, index) {
                  final media = snapshot.data![index];
                  return ListTile(
                    key: ValueKey(media.stationId),
                    title: Text(media.title),
                    minLeadingWidth: kDefaultTileLeadingDimension,
                    leading: RemoteMediaListTileImage(media: media),
                    subtitle: Text(
                      media.getRemoteTags(5) ?? context.l10n.radioStation,
                    ),
                    onTap: () => di<PlayerManager>().setPlaylist([media]),
                    trailing: RadioBrowserStationStarButton(media: media),
                  );
                },
                itemCount: snapshot.data!.length,
              );
            },
          ),
        ),
      ],
    );
  }
}
