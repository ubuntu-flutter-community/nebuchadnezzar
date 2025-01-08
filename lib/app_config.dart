import 'dart:io';

import 'package:flutter/foundation.dart';

bool yaru = !kIsWeb && (Platform.isLinux || Platform.isMacOS);

bool isMobilePlatform =
    !kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia);
