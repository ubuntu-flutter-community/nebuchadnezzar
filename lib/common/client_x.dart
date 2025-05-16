import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:matrix/encryption/utils/key_verification.dart';
import 'package:matrix/matrix.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../app/app_config.dart';

extension ClientX on Client {
  static Future<Client> registerAsync() async {
    if (Platform.isLinux) {
      sqlite.Sqflite();
      sqlite.databaseFactoryOrNull = databaseFactoryFfi;
    }
    final client = Client(
      AppConfig.appId,
      nativeImplementations: NativeImplementationsIsolate(compute),
      verificationMethods: {
        KeyVerificationMethod.numbers,
        if (Platform.isAndroid || Platform.isLinux) KeyVerificationMethod.emoji,
      },
      enableDehydratedDevices: true,
      shareKeysWith: ShareKeysWith.crossVerified,
      databaseBuilder: (_) async {
        final dir = await getApplicationSupportDirectory();
        final db = MatrixSdkDatabase(
          AppConfig.appId,
          database:
              await sqlite.openDatabase(p.join(dir.path, 'database.sqlite')),
        );
        await db.open();
        return db;
      },
    );
    // This reads potential credentials that might exist from previous sessions.
    await client.init().timeout(const Duration(seconds: 55));
    return client;
  }
}
