import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/common_widgets.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../../player/data/station_media.dart';
import '../../player/player_manager.dart';
import '../../player/view/player_control_mixin.dart';
import '../radio_service.dart';
import 'radio_browser_station_star_button.dart';
import 'radio_host_not_connected_content.dart';
import 'remote_media_list_tile_image.dart';

class RadioBrowser extends StatefulWidget {
  const RadioBrowser({super.key});

  @override
  State<RadioBrowser> createState() => _RadioBrowserState();
}

final _searchDraft = ValueNotifier('');

class _RadioBrowserState extends State<RadioBrowser> with PlayerControlMixin {
  late Future<List<StationMedia>> _future;
  final TextEditingController _searchController = TextEditingController(
    text: _searchDraft.value,
  );
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _future = _loadMedia(name: _searchController.text);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    _searchDraft.value = _searchController.text;
    super.dispose();
  }

  Future<List<StationMedia>> _loadMedia({
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
    return result?.map((e) => StationMedia.fromStation(e)).toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: kMediumPadding,
      children: [
        const SizedBox(height: kMediumPadding),
        TextField(
          decoration: InputDecoration(
            hint: Text(context.l10n.search),
            labelText: context.l10n.search,
            prefixIcon: const Icon(YaruIcons.search),
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
                _future = value.isEmpty
                    ? Future.value([])
                    : _loadMedia(name: value.isEmpty ? null : value);
              });
            });
          },
        ),
        Expanded(
          child: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    children: [
                      RadioHostNotConnectedContent(
                        message: 'Error: ${snapshot.error}',
                        onRetry: () async {
                          await di<RadioService>().init();
                          setState(() {
                            _future = _loadMedia();
                          });
                        },
                      ),
                    ],
                  ),
                );
              }

              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: Progress());
              }

              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    _searchController.text.isEmpty
                        ? ''
                        : context.l10n.nothingFound,
                    style: context.textTheme.bodyLarge,
                  ),
                );
              }

              return ListView.builder(
                itemBuilder: (context, index) {
                  final media = snapshot.data![index];
                  return ListTile(
                    key: ValueKey(media.id),
                    title: Text(media.title ?? context.l10n.radioStation),
                    minLeadingWidth: kDefaultTileLeadingDimension,
                    leading: RemoteMediaListTileImage(media: media),
                    subtitle: Text(media.genres.take(5).toList().join(', ')),
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
