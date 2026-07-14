import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:matrix/matrix.dart';

import '../extensions/client_x.dart';
import '../settings/settings_service.dart';

@module
abstract class MatrixClientModule {
  @lazySingleton
  @preResolve
  Future<Client> create({
    required SettingsService settingsService,
    required FlutterSecureStorage flutterSecureStorage,
  }) => ClientX.registerAsync(
    settingsService: settingsService,
    flutterSecureStorage: flutterSecureStorage,
  );
}
