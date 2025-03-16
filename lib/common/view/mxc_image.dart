import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '../local_image_model.dart';
import 'image_shimmer.dart';

class MxcImage extends StatelessWidget with WatchItMixin {
  const MxcImage({
    super.key,
    required this.uri,
    this.width,
    this.height,
    this.dimension,
    this.fit,
  });

  final Uri uri;
  final double? width;
  final double? height;
  final double? dimension;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    final maybeImage =
        watchPropertyValue((LocalImageModel m) => m.get(uri.toString()));

    final theHeight = dimension ?? height;
    final theWidth = dimension ?? width;
    final theFit = fit ?? BoxFit.cover;

    return maybeImage != null
        ? Image.memory(
            maybeImage,
            fit: theFit,
            height: theHeight,
            width: theWidth,
          )
        : MxcImageFuture(
            uri: uri,
            width: theWidth,
            height: theHeight,
            fit: theFit,
          );
  }
}

class MxcImageFuture extends StatefulWidget {
  const MxcImageFuture({
    super.key,
    required this.uri,
    this.height,
    this.width,
    this.fit,
  });

  final Uri uri;
  final double? height;
  final double? width;
  final BoxFit? fit;

  @override
  State<MxcImageFuture> createState() => _MxcImageFutureState();
}

class _MxcImageFutureState extends State<MxcImageFuture> {
  late final Future<dynamic> _future;

  @override
  void initState() {
    super.initState();
    _future = di<LocalImageModel>().downloadMxcCached(uri: widget.uri);
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            return Image.memory(
              data!,
              fit: widget.fit,
              height: widget.height,
              width: widget.width,
            );
          }

          return const ImageShimmer();
        },
      );
}
