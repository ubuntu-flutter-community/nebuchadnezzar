import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/common_widgets.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../../player/player_manager.dart';
import '../../player/view/player_control_mixin.dart';
import '../radio_manager.dart';
import 'radio_browser_station_star_button.dart';
import 'radio_host_not_connected_content.dart';
import 'remote_media_list_tile_image.dart';

class RadioBrowser extends StatefulWidget with WatchItStatefulWidgetMixin {
  const RadioBrowser({super.key});

  @override
  State<RadioBrowser> createState() => _RadioBrowserState();
}

class _RadioBrowserState extends State<RadioBrowser> with PlayerControlMixin {
  final TextEditingController _searchController = TextEditingController(
    text: di<RadioManager>().textChangedCommand.value,
  );

  @override
  Widget build(BuildContext context) {
    onDispose(_searchController.dispose);
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
                di<RadioManager>().textChangedCommand.run('');
              },
            ),
          ),
          controller: _searchController,
          onChanged: di<RadioManager>().textChangedCommand.run,
        ),
        Expanded(
          child: watchValue((RadioManager s) => s.updateSearchCommand.results)
              .toWidget(
                whileRunning: (lastResult, param) =>
                    const Center(child: Progress()),
                onError: (error, param, lastResult) =>
                    RadioHostNotConnectedContent(
                      message: 'Error: $error',
                      onRetry: di<RadioManager>().updateSearchCommand.run,
                    ),
                onData: (data, param) => ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final media = data[index];
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
                ),
              ),
        ),
      ],
    );
  }
}
