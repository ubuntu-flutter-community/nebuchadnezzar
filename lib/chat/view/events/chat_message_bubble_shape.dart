import 'package:flutter/material.dart';
import '../../../common/view/ui_constants.dart';

enum ChatMessageBubbleShape {
  topRound,
  allRound,
  bottomRound;

  BorderRadius getBorderRadius(
    bool partOfMessageCascade, {
    bool header = false,
  }) =>
      switch (this) {
        topRound => BorderRadius.only(
            topLeft: kBigBubbleRadius,
            topRight: kBigBubbleRadius,
            bottomRight: header ? Radius.zero : kBubbleRadius,
            bottomLeft: header ? Radius.zero : kBubbleRadius,
          ),
        bottomRound => const BorderRadius.only(
            topLeft: kBubbleRadius,
            topRight: kBubbleRadius,
            bottomRight: kBigBubbleRadius,
            bottomLeft: kBigBubbleRadius,
          ),
        allRound => const BorderRadius.only(
            topLeft: kBigBubbleRadius,
            topRight: kBigBubbleRadius,
            bottomRight: kBigBubbleRadius,
            bottomLeft: kBigBubbleRadius,
          ),
      };
}
