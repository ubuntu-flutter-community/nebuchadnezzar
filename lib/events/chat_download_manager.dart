import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';
import 'package:mime/mime.dart';
import 'package:opus_caf_converter_dart/opus_caf_converter_dart.dart';
import 'package:path/path.dart' as p;
import 'package:safe_change_notifier/safe_change_notifier.dart';

import '../common/external_path_service.dart';
import '../common/platforms.dart';
import '../extensions/event_x.dart';
import '../settings/settings_service.dart';
import 'chat_export_service.dart';

class ChatDownloadManager extends SafeChangeNotifier {
  ChatDownloadManager({
    required ChatExportService service,
    required ExternalPathService externalPathService,
    required SettingsService settingsService,
  }) : _chatDownloadService = service,
       _externalPathService = externalPathService,
       _settingsService = settingsService;

  final ChatExportService _chatDownloadService;
  final SettingsService _settingsService;
  final ExternalPathService _externalPathService;
  StreamSubscription<bool>? _propertiesChangedSub;

  SetNotifier<Event> activeDownloads = SetNotifier();
  SetNotifier<DownloadCapsule> downloadedEventsInTemp = SetNotifier();

  late final Command<void, String?> downloadsDirCommand =
      Command.createAsyncNoParam(() async {
        final path = await _externalPathService.getPathOfDirectory();
        if (path != null) {
          await _settingsService.setValue(SettingKeys.downloadsDirPath, path);
        }
        return _settingsService.downloadsDir;
      }, initialValue: _settingsService.downloadsDir);

  late final Command<Timeline, void> fillRecentDownloadsCommand =
      Command.createAsync((timeline) async {
        final events = timeline.events.where((e) => e.hasAttachment).toList();

        for (final event in events.where((e) => e.fileName != null)) {
          final filePath = await Platforms.getDownloadFilePath(
            event.fileName!,
            subDir: SubDir.fromEvent(event),
          );
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
            getDownloadCommand(event).run();
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

        return result;
      }, initialValue: null);

  final _downloadCommands = <Event, Command<void, DownloadCapsule?>>{};
  Command<void, DownloadCapsule?> getDownloadCommand(Event event) =>
      _downloadCommands.putIfAbsent(
        event,
        () => Command.createAsyncWithProgress(
          (_, handle) async {
            File? file;
            MatrixFile? matrixFile;

            if (event.fileName == null) {
              return null;
            }

            final path = await Platforms.getDownloadFilePath(
              event.fileName!,
              subDir: SubDir.fromEvent(event),
            );
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

            if (Platform.isIOS &&
                matrixFile.mimeType.toLowerCase() == 'audio/ogg') {
              Logs().v('Convert ogg audio file for iOS...');
              final convertedFile = File('${file.path}.caf');
              if (await convertedFile.exists() == false) {
                OpusCaf().convertOpusToCaf(file.path, convertedFile.path);
              }
              file = convertedFile;
            }

            return DownloadCapsule(
              event: event,
              file: file,
              matrixFile: matrixFile,
            );
          },
          initialValue: downloadedEventsInTemp.firstWhereOrNull(
            (c) => c.event.fileName == event.fileName,
          ),
        ),
      );

  final _exportFileCommands =
      <
        Event,
        Command<({String confirmButtonText, String dialogTitle}), String?>
      >{};
  Command<({String confirmButtonText, String dialogTitle}), String?>
  getExportFileCommand(Event event) => _exportFileCommands.putIfAbsent(
    event,
    () => Command.createAsync(
      (param) => _chatDownloadService.pickLocationAndExportFile(
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
