import 'package:local_notifier/local_notifier.dart';

extension LocalNotificationX on LocalNotification {
  void setOnClick(void Function() v) => onClick = v;
}
