import 'dart:typed_data';

import 'package:media_kit/media_kit.dart';

abstract interface class UniqueMedia extends Media {
  UniqueMedia(
    super.resource, {
    super.extras,
    super.httpHeaders,
    super.start,
    super.end,
  });

  String get id;

  String? get title;

  String? get artist;

  int? get bitrate;

  String? get collectionName;

  DateTime? get creationDateTime;

  String? get language;

  List<String>? get performers;

  Duration? get duration;

  List<String> get genres;

  String? get artUrl;

  String? get collectionArtUrl;

  Uint8List? get artData;

  Future<Uri?> get artUri;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UniqueMedia && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
