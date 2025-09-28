import 'dart:io';
import 'dart:typed_data';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:collection/collection.dart';
import 'package:media_kit/media_kit.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

extension MediaX on Media {
  static final _audioMetadataCache = <String, AudioMetadata?>{};

  AudioMetadata? get metadata {
    if (_audioMetadataCache.containsKey(uri.toString())) {
      return _audioMetadataCache[uri.toString()];
    }
    AudioMetadata? data;
    final file = File(uri.toString());
    if (file.existsSync() && file.isPlayable) {
      try {
        data = readMetadata(file, getImage: true);
      } catch (_) {
        return null;
      }
      _audioMetadataCache[uri.toString()] = data;
      return data;
    }

    return null;
  }

  String get artist => metadata?.artist ?? 'Unknown Artist';

  String? get album => metadata?.album;

  String get title =>
      metadata?.title ?? basenameWithoutExtension(uri.toString());

  Uint8List? get albumArt {
    final data = metadata;
    if (data == null) return null;
    return data.pictures.firstWhereOrNull((e) => e.bytes.isNotEmpty)?.bytes;
  }
}

extension MediaFileX on File {
  bool get isPlayable => path.isPlayable;
}

final _resolver = MimeTypeResolver();

extension _ValidPathX on String {
  bool get isPlayable {
    for (var v in _SpecialMimeTypes.values) {
      _resolver
        ..addExtension(v.extension, v.mimeType)
        ..addMagicNumber(v.headerBytes, v.mimeType);
    }

    final mime = _resolver.lookup(this);

    return (mime?.contains('audio') ?? false) ||
        (mime?.contains('video') ?? false);
  }
}

enum _SpecialMimeTypes {
  opusAudio;

  String get mimeType => switch (this) {
    opusAudio => 'audio/opus',
  };

  String get extension => switch (this) {
    opusAudio => 'opus',
  };

  List<int> get headerBytes => switch (this) {
    opusAudio => [
      0x4F, // O
      0x67, // g
      0x67, // g
      0x53, // S
    ],
  };
}
