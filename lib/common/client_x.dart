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
    // Configure sqflite FFI only for Linux desktop
    if (!kIsWeb && Platform.isLinux) {
      sqlite.Sqflite(); // Initialize FFI factory
      sqlite.databaseFactoryOrNull = databaseFactoryFfi;
    }

    final client = Client(
      AppConfig.appId,
      nativeImplementations: kIsWeb
          ? const NativeImplementationsDummy()
          : NativeImplementationsIsolate(compute),
      verificationMethods: {
        KeyVerificationMethod.numbers,
        KeyVerificationMethod.emoji,
      },
      // Use sqflite database ONLY on non-web platforms.
      // On web, let the matrix package handle storage (IndexedDB).
      databaseBuilder: kIsWeb
          ? null
          : (_) async {
              // This code runs only on mobile/desktop
              final dir = await getApplicationSupportDirectory();
              final db = MatrixSdkDatabase(
                AppConfig.appId,
                database: await sqlite.openDatabase(
                  p.join(dir.path, 'database.sqlite'),
                ),
              );
              await db.open();
              return db;
            },
    );
    // This reads potential credentials that might exist from previous sessions.
    await client.init();
    return client;
  }
}
