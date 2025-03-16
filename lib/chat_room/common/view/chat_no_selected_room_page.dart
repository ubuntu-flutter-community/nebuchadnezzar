import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../../../common/view/build_context_x.dart';
import '../../../common/view/ui_constants.dart';
import '../../titlebar/side_bar_button.dart';

class ChatNoSelectedRoomPage extends StatelessWidget {
  const ChatNoSelectedRoomPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: YaruWindowTitleBar(
          heroTag: '<Right hero tag>',
          border: BorderSide.none,
          backgroundColor: Colors.transparent,
          title: const Text(''),
          leading: !kIsWeb && !Platform.isMacOS && !context.showSideBar
              ? const SideBarButton()
              : null,
          actions: [
            if (!context.showSideBar && !kIsWeb && Platform.isMacOS)
              const SideBarButton(),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: kYaruTitleBarHeight),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: kBigPadding,
              children: [
                Image.asset(
                  'assets/nebuchadnezzar.png',
                  width: 100,
                  height: 100,
                ),
                const Text('Please select a chatroom from the side panel.'),
              ],
            ),
          ),
        ),
      );
}
