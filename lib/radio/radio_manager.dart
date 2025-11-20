import 'package:flutter_it/flutter_it.dart';

import '../player/data/station_media.dart';
import '../settings/settings_service.dart';
import 'radio_service.dart';

class RadioManager {
  RadioManager({
    required SettingsService settingsService,
    required RadioService radioService,
  }) : _settingsService = settingsService,
       _radioService = radioService {
    favoriteStationsCommand = Command.createAsyncNoParam(
      _loadFavorites,
      initialValue: [],
    );

    textChangedCommand = Command.createSync((s) => s, initialValue: '');

    textChangedCommand
        .debounce(const Duration(milliseconds: 500))
        .listen((filterText, sub) => updateSearchCommand.run(filterText));

    updateSearchCommand = Command.createAsync<String?, List<StationMedia>>(
      (filterText) => _loadMedia(name: filterText),
      initialValue: [],
    );
  }

  final SettingsService _settingsService;
  final RadioService _radioService;
  late Command<void, List<StationMedia>> favoriteStationsCommand;
  late Command<String, String> textChangedCommand;
  late Command<String?, List<StationMedia>> updateSearchCommand;

  Future<List<StationMedia>> _loadMedia({
    String? country,
    String? name,
    String? state,
    String? tag,
    String? language,
  }) async {
    if (name == null || name.isEmpty) {
      return [];
    }
    final result = await di<RadioService>().search(
      country: country,
      name: name,
      state: state,
      tag: tag,
      language: language,
    );
    return result?.map((e) => StationMedia.fromStation(e)).toList() ?? [];
  }

  Future<List<StationMedia>> _loadFavorites() async {
    final favoriteStations =
        _settingsService.getStringList(SettingKeys.favoriteStations) ??
        <String>[];

    return Future.wait(
      favoriteStations.map((stationId) async {
        StationMedia? media;
        media = StationMedia.getCachedStationMedia(stationId);
        if (media == null) {
          final station = await _radioService.getStationByUUID(stationId);
          if (station != null) {
            media = StationMedia.fromStation(station);
          }
        }
        return Future.value(media);
      }),
    );
  }

  Future<void> addFavoriteStation(String stationUuid) async {
    await _settingsService.addFavoriteStation(stationUuid);
    favoriteStationsCommand.run();
  }

  Future<void> removeFavoriteStation(String stationUuid) async {
    await _settingsService.removeFavoriteStation(stationUuid);
    favoriteStationsCommand.run();
  }
}
