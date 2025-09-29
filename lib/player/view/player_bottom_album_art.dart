import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/theme.dart';
import 'player_album_art.dart';
import 'player_control_mixin.dart';

class PlayerBottomAlbumArt extends StatefulWidget {
  const PlayerBottomAlbumArt({super.key, required this.media});

  final Media? media;

  @override
  State<PlayerBottomAlbumArt> createState() => _PlayerBottomAlbumArtState();
}

class _PlayerBottomAlbumArtState extends State<PlayerBottomAlbumArt>
    with PlayerControlMixin {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: Stack(
        children: [
          PlayerAlbumArt(media: widget.media),
          if (_hovering)
            Container(
              width: bottomPlayerHeight - playerTrackHeight,
              height: bottomPlayerHeight - playerTrackHeight,
              color: Colors.black.withAlpha(100),
              child: Center(
                child: IconButton(
                  onPressed: () => togglePlayerFullMode(context),
                  icon: const Icon(YaruIcons.fullscreen, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
