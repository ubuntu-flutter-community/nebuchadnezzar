import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/theme.dart';
import '../../extensions/media_x.dart';

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

    if (media?.albumArt != null) {
      return SizedBox(
        width: dim,
        height: dim,
        child: Image.memory(
          media!.albumArt!,
          width: dim,
          height: dim,
          fit: fit,
        ),
      );
    }
    return Icon(YaruIcons.music_note, color: Colors.white, size: dim * 0.8);
  }
}
