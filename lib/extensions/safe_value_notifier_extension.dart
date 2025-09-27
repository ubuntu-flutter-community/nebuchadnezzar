import 'package:safe_change_notifier/safe_change_notifier.dart';

extension SafeValueNotifierExtension on SafeValueNotifier<bool> {
  void toggle() => value = !value;
}
