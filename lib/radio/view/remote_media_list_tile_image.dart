import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/safe_network_image.dart';
import '../../common/view/ui_constants.dart';
import '../../player/data/station_media.dart';

class RemoteMediaListTileImage extends StatelessWidget {
  const RemoteMediaListTileImage({super.key, required this.media});

  final StationMedia media;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: kDefaultTileLeadingDimension,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SafeNetworkImage(
          fallBackIcon: const Icon(YaruIcons.radio),
          url: media.artUrl,
          width: kDefaultTileLeadingDimension,
          height: kDefaultTileLeadingDimension,
        ),
      ),
    );
  }
}
