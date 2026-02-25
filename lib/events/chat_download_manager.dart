import 'dart:async';
import 'dart:io';

import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';
import 'package:mime/mime.dart';
import 'package:open_folder/open_folder.dart';
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
  MapNotifier<Event, DownloadCapsule> recentDownloads = MapNotifier();

  late final Command<String, OpenResult?> openParentDirectoryCommand =
      Command.createAsync((path) async {
        final file = File(path);
        if (!(await file.exists())) {
          return Future.value(
            const OpenResult(
              type: ResultType.error,
              message: 'File does not exist',
            ),
          );
        }
        final directory = file.parent;
        return OpenFolder.openFolder(directory.path);
      }, initialValue: null);

  late final Command<void, String?> downloadsDirCommand =
      Command.createAsyncNoParam(() async {
        final path = await _externalPathService.getPathOfDirectory();
        if (path != null) {
          await _settingsService.setValue(SettingKeys.downloadsDirPath, path);
        }
        return _settingsService.downloadsDir;
      }, initialValue: _settingsService.downloadsDir);

  final _downloadCommands = <Event, Command<bool, DownloadCapsule?>>{};
  Command<bool, DownloadCapsule?> getDownloadCommand(
    Event event,
  ) => _downloadCommands.putIfAbsent(
    event,
    () => Command.createAsyncWithProgress((doDownload, handle) async {
      if (event.fileName == null) {
        return null;
      }

      final path = await Platforms.getDownloadFilePath(
        event.fileName!,
        subDir: SubDir.fromEvent(event),
      );

      var file = File(path);
      MatrixFile? matrixFile;

      if (file.existsSync()) {
        matrixFile = MatrixFile.fromMimeType(
          name: p.basename(file.path),
          bytes: await file.readAsBytes(),
          mimeType: lookupMimeType(file.path),
        );
      } else if (doDownload) {
        activeDownloads.add(event);
        matrixFile = await event.downloadAndDecryptAttachment(
          onDownloadProgress: (v) {
            final progress = event.fileSize != null && event.fileSize! > 0
                ? v / event.fileSize!
                : null;
            handle.updateProgress(progress ?? 0);
          },
        );

        await file.writeAsBytes(matrixFile.bytes);

        activeDownloads.remove(event);
      }

      if (Platform.isIOS && matrixFile?.mimeType.toLowerCase() == 'audio/ogg') {
        final convertedFile = File('${file.path}.caf');
        if (await convertedFile.exists() == false) {
          OpusCaf().convertOpusToCaf(file.path, convertedFile.path);
        }
        file = convertedFile;
      }

      if (file.existsSync()) {
        return recentDownloads.putIfAbsent(
          event,
          () =>
              DownloadCapsule(event: event, file: file, matrixFile: matrixFile),
        );
      }

      return null;
    }, initialValue: null),
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
