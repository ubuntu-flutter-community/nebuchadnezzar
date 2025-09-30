import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/safe_network_image.dart';
import '../../common/view/ui_constants.dart';
import '../../extensions/media_x.dart';

class RemoteMediaListTileImage extends StatelessWidget {
  const RemoteMediaListTileImage({super.key, required this.media});

  final Media media;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: kDefaultTileLeadingDimension,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SafeNetworkImage(
          fallBackIcon: const Icon(YaruIcons.radio),
          url: media.remoteAlbumArt,
          width: kDefaultTileLeadingDimension,
          height: kDefaultTileLeadingDimension,
        ),
      ),
    );
  }
}
