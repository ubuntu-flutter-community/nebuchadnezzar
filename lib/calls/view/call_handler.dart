import 'package:flutter/material.dart';
import 'package:matrix/matrix_api_lite/model/basic_event_with_sender.dart';

import '../../common/view/chat_avatar.dart';
import '../../common/view/confirm.dart';

void callHandler(
  BuildContext context,
  AsyncSnapshot<List<BasicEventWithSender>?> newValue,
  void Function()? cancel,
) {
  if (newValue.hasData) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: Text(newValue.data!.last.type),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: ChatAvatar(
                dimension: 80,
                fallBackIconSize: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
