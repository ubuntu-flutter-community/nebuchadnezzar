import 'dart:io';
import 'dart:typed_data';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:collection/collection.dart';
import 'package:media_kit/media_kit.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../common/platforms.dart';

extension MediaX on Media {
  static final _audioMetadataCache = <String, AudioMetadata?>{};
  static final _audioAlbumArtUriCache = <String, Uri?>{};

  AudioMetadata? get _metadata {
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

  String get artist => _metadata?.artist ?? 'Unknown Artist';

  String? get album => _metadata?.album;

  String get title =>
      _metadata?.title ?? basenameWithoutExtension(uri.toString());

  Duration? get duration => _metadata?.duration;

  Uint8List? get albumArt {
    final data = _metadata;
    if (data == null) return null;
    return data.pictures.firstWhereOrNull((e) => e.bytes.isNotEmpty)?.bytes;
  }

  String get albumId =>
      '${artist}_${album ?? 'unknown_album'}'.replaceAll(' ', '_');

  Future<Uri?> getAlbumArtUri({Media? media}) async {
    if (_audioAlbumArtUriCache.containsKey(media?.albumId)) {
      return _audioAlbumArtUriCache[media!.albumId];
    }

    final newData = media?.albumArt;
    if (newData != null && media?.albumId != null) {
      final File newFile = await _safeTempCover(
        imageData: newData,
        key: media!.albumId,
      );

      var artUri = Uri.file(newFile.path, windows: Platforms.isWindows);

      _audioAlbumArtUriCache[media.albumId] = artUri;
      return artUri;
    }

    return null;
  }

  Future<File> _safeTempCover({
    required String key,
    required Uint8List imageData,
  }) async {
    final workingDir = await getTemporaryDirectory();

    final imagesDir = p.join(workingDir.path, 'images');

    if (!(await Directory(imagesDir).exists())) {
      await Directory(imagesDir).create();
    }

    final file = File(p.join(imagesDir, '$key.png'));
    final newFile = await file.writeAsBytes(imageData);
    return newFile;
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
