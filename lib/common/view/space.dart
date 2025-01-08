import 'package:flutter/material.dart';

List<Widget> space({
  required Iterable<Widget> children,
  double? widthGap,
  double? heightGap,
  int skip = 1,
  final bool expand = false,
}) =>
    children
        .expand(
          (item) sync* {
            yield SizedBox(
              width: widthGap,
              height: heightGap,
            );
            yield expand ? Expanded(child: item) : item;
          },
        )
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
