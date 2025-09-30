import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/safe_network_image.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../../extensions/media_x.dart';
import '../../l10n/l10n.dart';
import '../../player/player_manager.dart';
import '../../player/view/player_control_mixin.dart';
import '../radio_service.dart';

class RadioBrowser extends StatefulWidget {
  const RadioBrowser({super.key});

  @override
  State<RadioBrowser> createState() => _RadioBrowserState();
}

class _RadioBrowserState extends State<RadioBrowser> with PlayerControlMixin {
  late Future<List<Media>> _future;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _future = _loadMedia();
  }

  @override
  void dispose() {
    _searchController.dispose();
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
          onChanged: (value) => setState(() {
            _future = _loadMedia(name: value.isEmpty ? null : value);
          }),
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
                    title: Text(media.artist),
                    minLeadingWidth: 40,
                    leading: SizedBox(
                      width: 40,
                      height: 40,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: SafeNetworkImage(
                          url: media.remoteAlbumArt,
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                    subtitle: Text(
                      media.album
                          .split(',')
                          .map((e) => e.trim())
                          .take(5)
                          .join(', '),
                    ),
                    onTap: () => di<PlayerManager>().setPlaylist([media]),
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
