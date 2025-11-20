import 'dart:typed_data';

import 'package:media_kit/media_kit.dart';
import 'package:radio_browser_api/radio_browser_api.dart';

import 'unique_media.dart';

class StationMedia extends Media implements UniqueMedia {
  StationMedia(
    super.resource, {
    required this.station,
    super.extras,
    super.httpHeaders,
    super.start,
    super.end,
  });

  final Station station;

  static final _uuidToMediaCache = <String, StationMedia>{};
  static StationMedia? getCachedStationMedia(String uuid) =>
      _uuidToMediaCache[uuid];

  @override
  String get id => station.stationUUID;

  @override
  String? get title => station.name.trim();

  static StationMedia fromStation(Station station) {
    final media = StationMedia(
      station.urlResolved ?? station.url,
      station: station,
    );

    _uuidToMediaCache[station.stationUUID] = media;

    return media;
  }

  @override
  Future<Uri?> get artUri async {
    final url = station.favicon;
    if (url == null || url.isEmpty) return null;
    return Uri.tryParse(url);
  }

  @override
  String? get artUrl => station.favicon;

  @override
  Uint8List? get artData => null;

  @override
  String? get artist => station.name;

  @override
  int? get bitrate => station.bitrate;

  @override
  String? get collectionName => null;

  @override
  DateTime? get creationDateTime => station.lastCheckTime;

  @override
  Duration? get duration => null;

  @override
  List<String> get genres {
    final tags = station.tags;

    final cleanedTags = tags?.replaceAll(RegExp(r'[^a-zA-Z0-9,]'), '').trim();

    return cleanedTags?.split(',') ?? <String>[];
  }

  @override
  String? get language => station.language;

  @override
  List<String>? get performers => null;

  @override
  String? get collectionArtUrl => null;
}
