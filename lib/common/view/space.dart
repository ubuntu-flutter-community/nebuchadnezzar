import 'package:flutter/material.dart';

List<Widget> space({
  required Iterable<Widget> children,
  double? widthGap,
  double? heightGap,
  int skip = 1,
  final bool expand = false,
  final bool flex = false,
  final bool spaceEnd = false,
  final bool sliver = false,
}) => children
    .expand((item) sync* {
      if (!spaceEnd) {
        yield sliver
            ? SliverToBoxAdapter(
                child: SizedBox(width: widthGap, height: heightGap),
              )
            : SizedBox(width: widthGap, height: heightGap);
      }
      yield expand
          ? Expanded(child: item)
          : flex
          ? Flexible(child: item)
          : item;
      if (spaceEnd) {
        yield sliver
            ? SliverToBoxAdapter(
                child: SizedBox(width: widthGap, height: heightGap),
              )
            : SizedBox(width: widthGap, height: heightGap);
      }
    })
    .skip(skip)
    .toList();

class AppBarSpace extends StatelessWidget implements PreferredSizeWidget {
  const AppBarSpace({required this.size, super.key});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(size: size);
  }

  @override
  Size get preferredSize => size;
}
