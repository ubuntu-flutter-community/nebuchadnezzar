import 'dart:io';
import 'dart:typed_data';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xdg_directories/xdg_directories.dart';

import '../../app/app_config.dart';
import '../../common/platforms.dart';
import '../../extensions/media_file_x.dart';
import 'unique_media.dart';

class LocalMedia extends UniqueMedia {
  LocalMedia(
    super.path, {
    super.extras,
    super.httpHeaders,
    super.start,
    super.end,
  });

  @override
  String get id => artist == null
      ? uri.toString()
      : '${artist}_$title'.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');

  static final _audioMetadataCache = <String, AudioMetadata?>{};
  AudioMetadata? get _localMetadata {
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

  @override
  String? get artist => _localMetadata?.artist;

  @override
  String? get collectionName => _localMetadata?.album;

  @override
  List<String> get genres => _localMetadata?.genres ?? <String>[];

  @override
  String get title =>
      _localMetadata?.title ?? basenameWithoutExtension(uri.toString());

  @override
  Duration? get duration => _localMetadata?.duration;

  @override
  int? get bitrate => _localMetadata?.bitrate;

  @override
  String? get language => _localMetadata?.language;

  @override
  List<String> get performers => _localMetadata?.performers ?? <String>[];

  int? get trackNumber => _localMetadata?.trackNumber;

  int? get trackTotal => _localMetadata?.trackTotal;

  @override
  DateTime? get creationDateTime => _localMetadata?.year;

  @override
  Uint8List? get artData {
    final data = _localMetadata;
    if (data == null) return null;
    return data.pictures.firstWhereOrNull((e) => e.bytes.isNotEmpty)?.bytes;
  }

  @override
  String? get artUrl => null;

  static final _audioAlbumArtUriCache = <String, Uri?>{};

  @override
  Future<Uri?> get artUri async {
    if (_audioAlbumArtUriCache.containsKey(id)) {
      return _audioAlbumArtUriCache[id];
    }

    final newData = artData;
    if (newData != null) {
      final File newFile = await _safeTempCover(imageData: newData, key: id);

      var artUri = Uri.file(newFile.path, windows: Platforms.isWindows);

      _audioAlbumArtUriCache[id] = artUri;
      return artUri;
    }

    return null;
  }

  Future<File> _safeTempCover({
    required String key,
    required Uint8List imageData,
  }) async {
    final tempDir = Platforms.isLinux
        ? configHome.path
        : (await getTemporaryDirectory()).path;

    final imagesDir = p.join(tempDir, '${AppConfig.appName}_temp_images');

    if (!(await Directory(imagesDir).exists())) {
      await Directory(imagesDir).create();
    }

    final file = File(p.join(imagesDir, '$key.png'));
    final newFile = await file.writeAsBytes(imageData);
    return newFile;
  }

  @override
  String? get collectionArtUrl => null;
}
