import 'dart:io';

import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:media_kit/media_kit.dart';
import 'package:opus_caf_converter_dart/opus_caf_converter_dart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:watch_it/watch_it.dart';

import '../../common/platforms.dart';
import '../../extensions/media_x.dart';
import '../../l10n/l10n.dart';
import '../player_manager.dart';
import 'player_full_view.dart';

mixin PlayerControlMixin {
  Future<void> togglePlayerFullMode(BuildContext context) async {
    if (di<PlayerManager>().playerViewState.value.fullMode) {
      di<PlayerManager>().updateViewMode(fullMode: false);
      Navigator.of(context).maybePop();
    } else {
      di<PlayerManager>().updateViewMode(fullMode: true);
      showDialog(
        context: context,
        builder: (context) => const PlayerFullView(),
      );
    }
  }

  Future<void> playMatrixMedia(
    BuildContext context, {
    required Event event,
    bool addInQueue = false,
    bool play = true,
  }) async {
    File? file;
    MatrixFile? matrixFile;

    try {
      final result = await showFutureLoadingDialog(
        context: context,
        future: () => event.downloadAndDecryptAttachment(),
        title: context.l10n.loadingPleaseWait,
        backLabel: context.l10n.cancel,
        barrierDismissible: true,
      );

      matrixFile = result.asValue?.value;

      if (matrixFile != null) {
        if (!Platforms.isWeb) {
          final tempDir = await getTemporaryDirectory();

          file = File('${tempDir.path}/${matrixFile.name}');

          if (!file.existsSync()) {
            await file.writeAsBytes(matrixFile.bytes);
          }

          if (Platform.isIOS &&
              matrixFile.mimeType.toLowerCase() == 'audio/ogg') {
            Logs().v('Convert ogg audio file for iOS...');
            final convertedFile = File('${file.path}.caf');
            if (await convertedFile.exists() == false) {
              OpusCaf().convertOpusToCaf(file.path, convertedFile.path);
            }
            file = convertedFile;
          }
        }
      }
    } catch (e, s) {
      Logs().v('Could not download audio file', e, s);

      rethrow;
    }

    if (file != null) {
      final media = Media(file.path);
      if (addInQueue) {
        await di<PlayerManager>().addToPlaylist(media);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                context.l10n.appendedToQueue(
                  '${media.artist} - ${media.title}',
                ),
              ),
            ),
          );
        }
      } else {
        await di<PlayerManager>().setPlaylist([media], play: play);
      }
    }
  }
}
