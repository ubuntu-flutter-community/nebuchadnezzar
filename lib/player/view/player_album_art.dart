import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:yaru/yaru.dart';

import '../../extensions/media_x.dart';

class PlayerAlbumArt extends StatelessWidget {
  const PlayerAlbumArt({
    super.key,
    this.media,
    this.dimension = 70,
    this.fit = BoxFit.cover,
  });

  final Media? media;
  final double dimension;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (media?.albumArt != null) {
      return SizedBox(
        width: dimension,
        child: Image.memory(
          media!.albumArt!,
          width: dimension,
          height: dimension,
          fit: fit,
        ),
      );
    }
    return Icon(
      YaruIcons.music_note,
      color: Colors.white,
      size: dimension * 0.8,
    );
  }
}
