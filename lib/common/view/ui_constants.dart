import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:window_manager/window_manager.dart';

const kTinyPadding = 2.5;

const kSmallPadding = 5.0;

const kMediumPadding = 10.0;

const kBigPadding = 20.0;

const kCardPadding = 15.0;

const kSideBarWith = 250.0;

const kShowSideBarThreshHold = 600.0;

const kLoginFormWidth = 350.0;

const Duration kAvatarAnimationDuration = Duration(milliseconds: 250);
const Curve kAvatarAnimationCurve = Curves.easeInOut;
const kTypingAvatarSize = 24.0;

const kBubbleRadius = Radius.circular(4.0);
const kBigBubbleRadius = Radius.circular(8.0);

const windowOptions = WindowOptions(
  size: Size(1280, 1000),
  minimumSize: Size(400, 600),
  center: true,
);
