import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file/file.dart' hide FileSystem;
import 'package:file/local.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart' as p;
import 'package:xdg_directories/xdg_directories.dart';
import 'package:yaru/yaru.dart';

class SafeNetworkImage extends StatelessWidget {
  const SafeNetworkImage({
    super.key,
    required this.url,
    this.filterQuality = FilterQuality.medium,
    this.fit = BoxFit.fitWidth,
    this.fallBackIcon,
    this.errorIcon,
    this.height,
    this.width,
    required this.httpHeaders,
    this.errorListener,
  });

  final String? url;
  final FilterQuality filterQuality;
  final BoxFit fit;
  final Widget? fallBackIcon;
  final Widget? errorIcon;
  final double? height;
  final double? width;
  final Map<String, String> httpHeaders;
  final void Function(Object)? errorListener;

  @override
  Widget build(BuildContext context) {
    final fallBack = Center(
      child: fallBackIcon ??
          Icon(
            YaruIcons.user,
            size: height != null ? height! * 0.7 : null,
          ),
    );

    if (url == null || url!.isEmpty) return fallBack; // Added empty check

    try {
      // Use Uri.parse to handle potential encoding issues and validate URL
      final uri = Uri.parse(url!);

      if (uri.path.toLowerCase().endsWith('.svg')) {
        // Check path extension
        return SvgPicture.network(
          uri.toString(), // Use the validated/parsed URI string
          headers: httpHeaders,
          fit: fit,
          height: height,
          width: width,
          placeholderBuilder: (BuildContext context) => fallBack,
          // Note: SvgPicture.network doesn't have a direct errorWidget like CachedNetworkImage.
          // Error handling might need adjustment depending on requirements.
          // The outer try-catch will handle fundamental loading errors.
        );
      }

      return CachedNetworkImage(
        httpHeaders: httpHeaders,
        // Use kIsWeb for clarity, though Platform.isLinux implies !kIsWeb
        cacheManager: !kIsWeb && Platform.isLinux ? XdgCacheManager() : null,
        imageUrl: uri.toString(), // Use the validated/parsed URI string
        imageBuilder: (context, imageProvider) => Image(
          image: imageProvider,
          filterQuality: filterQuality,
          fit: fit,
          height: height,
          width: width,
        ),
        errorWidget: (context, url, error) {
          // Optionally call errorListener here if needed for consistency
          // errorListener?.call(error ?? 'Unknown error');
          return errorIcon ?? fallBack;
        },
        // Pass the original error listener if provided
        errorListener: errorListener,
      );
    } catch (e) {
      // Catch parsing errors or other exceptions during setup
      errorListener?.call(e);
      return errorIcon ?? fallBack;
    }
  }
}

// Code by @d-loose
// This FileSystem implementation uses dart:io and is NOT web compatible.
// It's correctly guarded by the !kIsWeb && Platform.isLinux check above.
class _XdgFileSystem implements FileSystem {
  final Future<Directory> _fileDir;
  final String _cacheKey;

  _XdgFileSystem(this._cacheKey) : _fileDir = createDirectory(_cacheKey);

  static Future<Directory> createDirectory(String key) async {
    final baseDir = cacheHome;
    final path = p.join(baseDir.path, key, 'images');

    const fs = LocalFileSystem();
    final directory = fs.directory(path);
    await directory.create(recursive: true);
    return directory;
  }

  @override
  Future<File> createFile(String name) async {
    final directory = await _fileDir;
    if (!(await directory.exists())) {
      // Re-create directory if it somehow got deleted after initial creation
      await createDirectory(_cacheKey);
    }
    return directory.childFile(name);
  }
}

// This CacheManager uses _XdgFileSystem and is NOT web compatible.
// It's correctly guarded by the !kIsWeb && Platform.isLinux check above.
class XdgCacheManager extends CacheManager with ImageCacheManager {
  // Use a more specific key if possible, Platform.resolvedExecutable might be empty/unreliable on some platforms
  static final key = p.basename(
    Platform.resolvedExecutable.isNotEmpty
        ? Platform.resolvedExecutable
        : 'flutter_app_cache',
  );

  static final XdgCacheManager _instance = XdgCacheManager._();

  factory XdgCacheManager() {
    return _instance;
  }

  XdgCacheManager._() : super(Config(key, fileSystem: _XdgFileSystem(key)));
}
