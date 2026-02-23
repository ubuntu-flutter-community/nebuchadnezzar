import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';
import 'package:mime/mime.dart';
import 'package:opus_caf_converter_dart/opus_caf_converter_dart.dart';
import 'package:path/path.dart' as p;
import 'package:safe_change_notifier/safe_change_notifier.dart';

import '../extensions/event_x.dart';
import '../persistence_utils.dart';
import 'chat_download_service.dart';

class ChatDownloadManager extends SafeChangeNotifier {
  ChatDownloadManager({required ChatDownloadService service})
    : _service = service;

  final ChatDownloadService _service;
  StreamSubscription<bool>? _propertiesChangedSub;

  SetNotifier<Event> activeDownloads = SetNotifier();
  SetNotifier<DownloadCapsule> downloadedEventsInTemp = SetNotifier();

  late final Command<Timeline, void> fillRecentDownloadsCommand =
      Command.createAsync((timeline) async {
        final events = timeline.events.where((e) => e.hasAttachment).toList();

        for (final event in events.where((e) => e.fileName != null)) {
          final filePath = await getTempFilePath(event.fileName!);
          if (File(filePath).existsSync() &&
              downloadedEventsInTemp.none(
                (c) => c.event.fileName == event.fileName,
              )) {
            final file = File(filePath);
            downloadedEventsInTemp.add(
              DownloadCapsule(
                event: event,
                file: file,
                matrixFile: MatrixFile.fromMimeType(
                  name: p.basename(file.path),
                  bytes: file.readAsBytesSync(),
                  mimeType: lookupMimeType(file.path),
                ),
              ),
            );
          }
        }
      }, initialValue: null);

  late final Command<Event, DownloadCapsule?> globalDownloadCommand =
      Command.createAsync((event) async {
        activeDownloads.add(event);
        final result = await getDownloadCommand(event).runAsync();
        activeDownloads.remove(event);
        if (result != null &&
            downloadedEventsInTemp.none(
              (c) => c.event.fileName == result.event.fileName,
            )) {
          downloadedEventsInTemp.add(result);
        }
        _downloadCommands.remove(event);

        return result;
      }, initialValue: null);

  final _downloadCommands = <Event, Command<void, DownloadCapsule?>>{};
  Command<void, DownloadCapsule?> getDownloadCommand(
    Event event,
  ) => _downloadCommands.putIfAbsent(
    event,
    () => Command.createAsyncWithProgress((_, handle) async {
      File? file;
      MatrixFile? matrixFile;

      if (event.fileName == null) {
        return null;
      }

      final path = await getTempFilePath(event.fileName!);
      if (File(path).existsSync()) {
        file = File(path);
        matrixFile = MatrixFile.fromMimeType(
          name: p.basename(file.path),
          bytes: file.readAsBytesSync(),
          mimeType: lookupMimeType(file.path),
        );
      } else {
        matrixFile = await event.downloadAndDecryptAttachment(
          onDownloadProgress: (v) {
            final progress = event.fileSize != null && event.fileSize! > 0
                ? v / event.fileSize!
                : null;
            handle.updateProgress(progress ?? 0);
          },
        );

        file = File(path)..writeAsBytesSync(matrixFile.bytes);
      }

      if (Platform.isIOS && matrixFile.mimeType.toLowerCase() == 'audio/ogg') {
        Logs().v('Convert ogg audio file for iOS...');
        final convertedFile = File('${file.path}.caf');
        if (await convertedFile.exists() == false) {
          OpusCaf().convertOpusToCaf(file.path, convertedFile.path);
        }
        file = convertedFile;
      }

      return DownloadCapsule(event: event, file: file, matrixFile: matrixFile);
    }, initialValue: null),
  );

  final _saveFileCommands =
      <
        Event,
        Command<({String confirmButtonText, String dialogTitle}), String?>
      >{};
  Command<({String confirmButtonText, String dialogTitle}), String?>
  getSaveFileCommand(Event event) => _saveFileCommands.putIfAbsent(
    event,
    () => Command.createAsync(
      (param) => _service.safeFile(
        event: event,
        confirmButtonText: param.confirmButtonText,
        dialogTitle: param.dialogTitle,
      ),
      initialValue: null,
    ),
  );

  @override
  Future<void> dispose() async {
    await _propertiesChangedSub?.cancel();
    super.dispose();
  }
}

class DownloadCapsule {
  final Event event;
  final File? file;
  final MatrixFile? matrixFile;

  const DownloadCapsule({
    required this.event,
    required this.file,
    required this.matrixFile,
  });
}
