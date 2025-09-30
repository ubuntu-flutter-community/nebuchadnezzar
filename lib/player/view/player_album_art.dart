import 'package:flutter/material.dart';
import 'package:listen_it/listen_it.dart';
import 'package:media_kit/media_kit.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/safe_network_image.dart';
import '../../common/view/theme.dart';
import '../../extensions/media_x.dart';
import '../player_manager.dart';

class PlayerAlbumArt extends StatelessWidget {
  const PlayerAlbumArt({
    super.key,
    this.media,
    this.dimension,
    this.fit = BoxFit.cover,
  });

  final Media? media;
  final double? dimension;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final dim = dimension ?? bottomPlayerHeight - playerTrackHeight;

    if (media != null) {
      if (media!.isLocal && media?.localAlbumArt != null) {
        return SizedBox(
          width: dim,
          height: dim,
          child: Image.memory(
            media!.localAlbumArt!,
            width: dim,
            height: dim,
            fit: fit,
          ),
        );
      }

      return SizedBox(
        width: dim,
        height: dim,
        child: PlayerRemoteSourceImage(height: dim, width: dim, fit: fit),
      );
    }

    return Icon(YaruIcons.music_note, color: Colors.white, size: dim * 0.8);
  }
}

class PlayerRemoteSourceImage extends StatelessWidget with WatchItMixin {
  const PlayerRemoteSourceImage({
    super.key,
    required this.height,
    required this.width,
    required this.fit,
  });

  final double height;
  final double width;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    final remoteSourceArtUrl = watchValue(
      (PlayerManager p) =>
          p.playerViewState.select((e) => e.remoteSourceArtUrl),
    );

    final color = watchValue(
      (PlayerManager p) => p.playerViewState.select((e) => e.color),
    );

    return SafeNetworkImage(
      placeholder: (context, url) => Center(
        child: SizedBox(
          width: width * 0.3,
          height: width * 0.3,
          child: CircularProgressIndicator(
            color: color?.withValues(alpha: 0.5),
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? getPlayerIconColor(context.theme),
            ),
          ),
        ),
      ),
      onImageLoaded: di<PlayerManager>().setRemoteColorFromImageProvider,
      url: remoteSourceArtUrl,
      filterQuality: FilterQuality.medium,
      fit: fit ?? BoxFit.scaleDown,
      fallBackIcon: Icon(
        YaruIcons.music_note,
        size: width * 0.8,
        color: color ?? getPlayerIconColor(context.theme),
      ),
      errorIcon: Icon(
        YaruIcons.music_note,
        size: width * 0.8,
        color: color ?? getPlayerIconColor(context.theme),
      ),
      height: height,
      width: width,
    );
  }
}
