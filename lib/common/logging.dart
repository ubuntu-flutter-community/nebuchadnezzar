import 'package:flutter/foundation.dart';

void printMessageInDebugMode(Object? object, [Object? stack]) {
  if (kDebugMode) {
    print(object);
    if (stack != null) {
      print(stack);
    }
  }
}
