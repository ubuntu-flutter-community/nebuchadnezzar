import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/ui_constants.dart';
import '../data/unique_media.dart';
import 'player_album_art.dart';
import 'player_control_mixin.dart';

class PlayerBottomAlbumArt extends StatefulWidget {
  const PlayerBottomAlbumArt({super.key, required this.media});

  final UniqueMedia? media;

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
              width: kBottomPlayerHeight - kPlayerTrackHeight,
              height: kBottomPlayerHeight - kPlayerTrackHeight,
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
