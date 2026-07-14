import 'package:injectable/injectable.dart';
import 'package:local_notifier/local_notifier.dart';

import '../app/app_config.dart';
import '../common/platforms.dart';

@module
abstract class LocalNotifierModule {
  @preResolve
  Future<LocalNotifier> get create async {
    if (Platforms.isDesktop) {
      await localNotifier.setup(
        appName: AppConfig.appId,
        shortcutPolicy: ShortcutPolicy.requireCreate,
      );
    }
    return localNotifier;
  }
}
