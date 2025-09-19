import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:window_manager/window_manager.dart';

const kTinyPadding = 2.5;

const kSmallPadding = 5.0;

const kMediumPadding = 10.0;

const kMediumPlusPadding = 15.0;

const kBigPadding = 20.0;

const kCardPadding = 15.0;

const kSideBarWith = 280.0;

const kShowSideBarThreshHold = 600.0;

const kLoginFormWidth = 350.0;

const Duration kAvatarAnimationDuration = Duration(milliseconds: 250);
const Curve kAvatarAnimationCurve = Curves.easeInOut;
const kTypingAvatarSize = 20.0;
const kAvatarDefaultSize = 38.0;

const kBubbleRadiusValue = 4.0;
const kBigBubbleRadiusValue = 12.0;
const kBubbleRadius = Radius.circular(kBubbleRadiusValue);
const kBigBubbleRadius = Radius.circular(kBigBubbleRadiusValue);

const windowOptions = WindowOptions(
  size: Size(1024, 800),
  minimumSize: Size(400, 600),
  center: true,
);
