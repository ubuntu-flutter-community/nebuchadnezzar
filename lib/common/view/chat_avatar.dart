import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import 'avatar_vignette.dart';
import 'safe_network_image.dart';
import 'ui_constants.dart';
import '../remote_image_manager.dart';

class ChatAvatar extends StatefulWidget with WatchItStatefulWidgetMixin {
  const ChatAvatar({
    super.key,
    this.dimension = kAvatarDefaultSize,
    this.fallBackIcon,
    this.fallBackIconSize,
    this.avatarUri,
    this.fallBackColor,
    this.onTap,
    this.onLongPress,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  final double dimension;
  final Uri? avatarUri;
  final IconData? fallBackIcon;
  final double? fallBackIconSize;
  final Color? fallBackColor;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final BorderRadius? borderRadius;
  final BoxFit fit;

  @override
  State<ChatAvatar> createState() => _ChatAvatarState();
}

class _ChatAvatarState extends State<ChatAvatar> {
  Future<Uri?>? _futureUri;

  @override
  void initState() {
    super.initState();
    final uri = widget.avatarUri;

    if (uri != null && di<RemoteImageManager>().getAvatarUri(uri) == null) {
      _futureUri = di<RemoteImageManager>().fetchAvatarUri(
        uri: uri,
        width: widget.dimension,
        height: widget.dimension,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius =
        widget.borderRadius ?? BorderRadius.circular(widget.dimension / 2);
    final uri = watchPropertyValue(
      (RemoteImageManager m) => m.getAvatarUri(widget.avatarUri),
    );

    final fallback = Icon(
      widget.fallBackIcon ?? YaruIcons.user,
      size: widget.fallBackIconSize,
    );

    final sizedBox = AvatarVignette(
      fallBackColor: widget.fallBackColor,
      dimension: widget.dimension,
      borderRadius: borderRadius,
      child: uri != null || _futureUri == null
          ? SafeNetworkImage(
              httpHeaders: di<RemoteImageManager>().httpHeaders,
              url: uri.toString(),
              fit: widget.fit,
              fallBackIcon: fallback,
            )
          : FutureBuilder(
              future: _futureUri,
              builder: (context, snapshot) => SafeNetworkImage(
                fit: widget.fit,
                httpHeaders: di<RemoteImageManager>().httpHeaders,
                url: snapshot.data?.toString(),
                fallBackIcon: fallback,
              ),
            ),
    );

    if (widget.onTap == null) {
      return sizedBox;
    }

    return InkWell(
      borderRadius: borderRadius,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: sizedBox,
    );
  }
}
