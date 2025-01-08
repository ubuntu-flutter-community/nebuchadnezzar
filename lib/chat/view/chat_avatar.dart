import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/safe_network_image.dart';
import '../../common/view/theme.dart';
import '../remote_image_model.dart';

class ChatAvatar extends StatefulWidget with WatchItStatefulWidgetMixin {
  const ChatAvatar({
    super.key,
    this.dimension = 38,
    this.fallBackIcon,
    this.fallBackIconSize,
    this.avatarUri,
    this.fallBackColor,
    this.onTap,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  final double dimension;
  final Uri? avatarUri;
  final IconData? fallBackIcon;
  final double? fallBackIconSize;
  final Color? fallBackColor;
  final void Function()? onTap;
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

    if (di<RemoteImageModel>().getAvatarUri(uri) == null && uri != null) {
      _futureUri = di<RemoteImageModel>().fetchAvatarUri(
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
      (RemoteImageModel m) => m.getAvatarUri(widget.avatarUri),
    );

    final sizedBox = SizedBox.square(
      dimension: widget.dimension,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: ColoredBox(
          color: widget.fallBackColor ??
              getMonochromeBg(
                theme: context.theme,
                factor: 6,
                darkFactor: 20,
              ),
          child: uri != null || _futureUri == null
              ? SafeNetworkImage(
                  httpHeaders: di<RemoteImageModel>().httpHeaders,
                  url: uri.toString(),
                  fit: widget.fit,
                  fallBackIcon: Icon(
                    widget.fallBackIcon ?? YaruIcons.user,
                    size: widget.fallBackIconSize,
                  ),
                )
              : FutureBuilder(
                  future: _futureUri,
                  builder: (context, snapshot) {
                    if (kIsWeb) {
                      return (snapshot.data == null
                          ? Icon(
                              widget.fallBackIcon ?? YaruIcons.user,
                              size: widget.fallBackIconSize,
                            )
                          : Image.network(snapshot.data!.toString()));
                    } else {
                      return SafeNetworkImage(
                        fit: widget.fit,
                        httpHeaders: di<RemoteImageModel>().httpHeaders,
                        url: snapshot.data?.toString(),
                        fallBackIcon: Icon(
                          widget.fallBackIcon ?? YaruIcons.user,
                          size: widget.fallBackIconSize,
                        ),
                      );
                    }
                  },
                ),
        ),
      ),
    );

    if (widget.onTap == null) {
      return sizedBox;
    }

    return InkWell(
      borderRadius: borderRadius,
      onTap: widget.onTap,
      child: sizedBox,
    );
  }
}
