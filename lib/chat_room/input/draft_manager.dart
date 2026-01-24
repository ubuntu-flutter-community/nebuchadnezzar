import 'dart:io';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:matrix/matrix.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';
import 'package:super_clipboard/super_clipboard.dart';
import 'package:video_compress/video_compress.dart';

import '../../common/local_image_service.dart';
import '../../common/logging.dart';
import '../../common/platforms.dart';

class DraftManager extends SafeChangeNotifier {
  DraftManager({
    required Client client,
    required LocalImageService localImageService,
  }) : _client = client,
       _localImageService = localImageService;

  final Client _client;
  final LocalImageService _localImageService;

  Event? _replyEvent;
  Event? get replyEvent => _replyEvent;
  void setReplyEvent(Event? event, {bool notify = true}) {
    _replyEvent = event;
    if (notify) {
      notifyListeners();
    }
  }

  final Map<String, Event?> _editEvents = {};
  Event? getEditEvent(String roomId) => _editEvents[roomId];
  void setEditEvent({
    required String roomId,
    Event? event,
    bool notify = true,
  }) {
    _editEvents[roomId] = event;
    if (notify) {
      notifyListeners();
    }
  }

  int get maxUploadSize => _mediaConfig?.mUploadSize ?? 100 * 1000 * 1000;
  MediaConfig? _mediaConfig;

  String? _threadRootEventId;
  String? get threadRootEventId => _threadRootEventId;
  void setThreadRootEventId(String? eventId, {bool notify = true}) {
    _threadRootEventId = eventId;
    if (notify) {
      notifyListeners();
    }
  }

  String? _threadLastEventId;
  String? get threadLastEventId => _threadLastEventId;
  void setThreadLastEventId(String? eventId, {bool notify = true}) {
    _threadLastEventId = eventId;
    if (notify) {
      notifyListeners();
    }
  }

  void resetThreadIds() {
    _threadLastEventId = null;
    _threadRootEventId = null;
  }

  Future<void> send({required Room room, String? text}) async {
    try {
      await room.setTyping(false);
    } on Exception catch (e, s) {
      printMessageInDebugMode(e, s);
    }

    final textDraft = getTextDraft(room.id) ?? '';
    removeTextDraft(room.id);
    final matrixFiles = List<MatrixFile>.from(getFilesDraft(room.id));
    if (matrixFiles.isNotEmpty) {
      for (var matrixFile in matrixFiles) {
        removeFileFromDraft(roomId: room.id, file: matrixFile);
        final xFile = _matrixFilesToXFile[matrixFile];
        String? eventId;
        MatrixFile? compressedFile;
        try {
          if (getCompressFile(roomId: room.id, file: matrixFile) ||
              matrixFile.bytes.length > maxUploadSize) {
            _mediaConfig ??= await _client.getConfig();
            compressedFile = await MatrixImageFile.shrink(
              bytes: matrixFile.bytes,
              name: matrixFile.name,
              mimeType: matrixFile.mimeType,
              maxDimension: maxUploadSize,
              nativeImplementations: _client.nativeImplementations,
            );
          }

          MatrixImageFile? thumbnail;

          if (matrixFile is MatrixVideoFile && xFile != null) {
            try {
              thumbnail = await getVideoThumbnail(xFile);
            } on Exception catch (e) {
              printMessageInDebugMode(e);
            }
          } else {
            thumbnail = null;
          }

          eventId = await room.sendFileEvent(
            compressedFile ?? matrixFile,
            inReplyTo: replyEvent,
            editEventId: _editEvents[room.id]?.eventId,
            thumbnail: thumbnail,
            extraContent: textDraft.isNotEmpty && textDraft != 'null'
                ? {'body': textDraft}
                : null,
          );
          if (eventId != null) {
            _matrixFilesToXFile.remove(matrixFile);
            removeCompress(roomId: room.id, file: matrixFile);
          }
        } on Exception catch (e, s) {
          printMessageInDebugMode(e, s);
        }
      }
    } else if (textDraft.isNotEmpty == true) {
      String? eventId;
      try {
        eventId = await room.sendTextEvent(
          textDraft.trim(),
          inReplyTo: replyEvent,
          editEventId: _editEvents[room.id]?.eventId,
          threadRootEventId: _threadRootEventId,
          threadLastEventId: _threadLastEventId,
        );
      } on Exception catch (e, s) {
        printMessageInDebugMode(e, s);
      }
      if (eventId == null) {
        setTextDraft(roomId: room.id, draft: textDraft, notify: true);
      }
    }

    _replyEvent = null;
    _editEvents[room.id] = null;

    notifyListeners();
  }

  final Map<String, int> _cursorPositions = {};
  int? getCursorPosition(String roomId) => _cursorPositions[roomId];
  void setCursorPosition({required String roomId, required int position}) {
    _cursorPositions[roomId] = position;
    // notifyListeners();
  }

  final Map<String, String> _textDrafts = {};
  int get draftLength => _textDrafts.length;
  String? getTextDraft(String roomId) => _textDrafts[roomId];
  void setTextDraft({
    required String roomId,
    required String draft,
    required bool notify,
    bool insertAtCursor = false,
  }) {
    if (insertAtCursor && _cursorPositions[roomId] != null) {
      final pos = _cursorPositions[roomId];
      final oldDraft = _textDrafts[roomId] ?? '';
      final newDraft =
          oldDraft.substring(0, pos!) +
          draft +
          oldDraft.substring(pos, oldDraft.length);
      _textDrafts[roomId] = newDraft;
      _cursorPositions[roomId] = pos + draft.length;
    } else {
      _textDrafts[roomId] = draft;
    }

    if (notify) {
      notifyListeners();
    }
  }

  void removeTextDraft(String roomId) {
    final oldDraft = _textDrafts[roomId];
    if (oldDraft == null) return;
    _textDrafts.remove(roomId);
    notifyListeners();
  }

  final Map<String, List<MatrixFile>> _filesDrafts = {};
  int get filesDraftLength => _filesDrafts.length;
  Map<String, List<MatrixFile>> get filesDrafts => _filesDrafts;
  List<MatrixFile> getFilesDraft(String roomId) => _filesDrafts[roomId] ?? [];
  void addFileToDraft({required String roomId, required MatrixFile file}) {
    final files = _filesDrafts[roomId] ?? [];
    if (!files.contains(file)) {
      files.add(file);
      _localImageService.put(id: file.name, data: file.bytes);
      _filesDrafts.update(roomId, (value) => files, ifAbsent: () => files);
    }
    notifyListeners();
  }

  void removeFileFromDraft({required String roomId, required MatrixFile file}) {
    final files = _filesDrafts[roomId] ?? [];
    if (files.contains(file)) {
      files.remove(file);
      _filesDrafts.update(roomId, (value) => files);
      _matrixFilesToXFile.remove(file);
      notifyListeners();
    }
    if (getFilesDraft(roomId).isEmpty) {
      setAttaching(false);
    }
  }

  final Map<String, Set<MatrixFile>> _toCompressFiles = {};
  bool getCompressFile({required String roomId, required MatrixFile file}) {
    final set = _toCompressFiles[roomId];
    if (set == null) {
      return false;
    }
    return set.contains(file);
  }

  void toggleCompress({required String roomId, required MatrixFile file}) {
    final files = _toCompressFiles[roomId] ?? {};
    if (files.contains(file)) {
      files.remove(file);
    } else {
      files.add(file);
    }
    _toCompressFiles.update(roomId, (value) => files, ifAbsent: () => files);
    notifyListeners();
  }

  void removeCompress({required String roomId, required MatrixFile file}) {
    final files = _toCompressFiles[roomId] ?? {};
    if (files.contains(file)) {
      files.remove(file);
    }

    notifyListeners();
  }

  bool _attaching = false;
  bool get attaching => _attaching;
  void setAttaching(bool value) {
    if (value == _attaching) return;
    _attaching = value;
    notifyListeners();
  }

  final Map<MatrixFile, XFile> _matrixFilesToXFile = {};
  Future<void> addAttachment(
    String roomId, {
    List<XFile>? existingFiles,
  }) async {
    setAttaching(true);

    List<XFile>? xFiles = existingFiles;

    if (xFiles == null) {
      if (Platforms.isLinux) {
        xFiles = await openFiles();
      } else {
        final result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.any,
        );
        xFiles = result?.files
            .map((f) => XFile(f.path!, mimeType: lookupMimeType(f.path!)))
            .toList();
      }
    }

    if (xFiles?.isEmpty ?? true) {
      setAttaching(false);
      return;
    }

    // TODO(Feichtmeier): add svg send support
    for (var xFile in xFiles!.where((e) => !e.path.contains('.svg'))) {
      MatrixFile matrixFile = await _createMatrixFileFromXFile(xFile);

      addFileToDraft(roomId: roomId, file: matrixFile);
    }

    setAttaching(false);
  }

  Future<MatrixFile> _createMatrixFileFromXFile(
    XFile xFile, [
    Uint8List? data,
    String? name,
    String? mimeType,
  ]) async {
    final mime = mimeType ?? xFile.mimeType;
    final bytes = data ?? await xFile.readAsBytes();
    final fileName = name ?? xFile.name;
    MatrixFile matrixFile;
    if (mime?.startsWith('image') == true) {
      matrixFile = MatrixImageFile(
        bytes: bytes,
        name: fileName,
        mimeType: mime,
      );
    } else if (mime?.startsWith('video') == true) {
      matrixFile = MatrixVideoFile(
        bytes: bytes,
        name: fileName,
        mimeType: mime,
      );
      _matrixFilesToXFile[matrixFile] = xFile;
    } else {
      matrixFile = MatrixFile.fromMimeType(
        bytes: bytes,
        name: fileName,
        mimeType: mime,
      );
    }
    return matrixFile;
  }

  static const int max = 1200;
  static const int quality = 40;

  Future<MatrixVideoFile> resizeVideo(XFile xFile) async {
    MediaInfo? mediaInfo;
    try {
      if (Platforms.isMobile || Platforms.isMacOS) {
        // will throw an error e.g. on Android SDK < 18
        mediaInfo = await VideoCompress.compressVideo(xFile.path);
      }
    } catch (e, s) {
      Logs().w('Error while compressing video', e, s);
    }
    return MatrixVideoFile(
      bytes:
          (await mediaInfo?.file?.readAsBytes()) ?? await xFile.readAsBytes(),
      name: xFile.name,
      mimeType: xFile.mimeType,
      width: mediaInfo?.width,
      height: mediaInfo?.height,
      duration: mediaInfo?.duration?.round(),
    );
  }

  Future<MatrixImageFile?> getVideoThumbnail(XFile xFile) async {
    if (!(Platforms.isMobile || Platforms.isMacOS)) return null;

    try {
      final bytes = await VideoCompress.getByteThumbnail(xFile.path);
      if (bytes == null) return null;
      return MatrixImageFile(bytes: bytes, name: xFile.name);
    } catch (e, s) {
      Logs().w('Error while compressing video', e, s);
    }
    return null;
  }

  final Map<String, bool> _selectedMessages = {};
  void setMessageSelected({required String eventId, required bool selected}) {
    if (isMessageSelected(eventId: eventId) == selected) return;
    _selectedMessages[eventId] = selected;
    notifyListeners();
  }

  bool isMessageSelected({required String eventId}) =>
      _selectedMessages[eventId] ?? false;

  Future<List<void>> addAttachMentFromClipboard(
    String roomId, {
    required String clipboardNotAvailable,
    required String noSupportedFormatFoundInClipboard,
    required String fileIsTooLarge,
  }) async {
    final clipboard = SystemClipboard.instance;
    if (clipboard == null) {
      return Future.error(clipboardNotAvailable);
    }
    ClipboardReader reader;
    try {
      reader = await clipboard.read();
    } on Exception catch (e) {
      return Future.error(e.toString());
    }

    if (reader.items.isEmpty) {
      return Future.value([]);
    }
    if (reader.canProvide(Formats.plainText) &&
        binaryFormats.none((format) => reader.canProvide(format))) {
      final text = await reader.readValue(Formats.plainText);
      setTextDraft(
        roomId: roomId,
        draft: text ?? '',
        notify: true,
        insertAtCursor: true,
      );
      return Future.value([]);
    } else {
      if (reader.items.none(
        (item) => binaryFormats.any((format) => item.canProvide(format)),
      )) {
        return Future.error(noSupportedFormatFoundInClipboard);
      }

      return Future.wait(
        binaryFormats.map(
          (format) => _processClipboardReader(
            roomId: roomId,
            format: format,
            reader: reader,
            fileIsTooLarge: fileIsTooLarge,
          ),
        ),
      );
    }
  }

  Future<void> _processClipboardReader({
    required String roomId,
    required SimpleFileFormat format,
    required ClipboardReader reader,
    required String fileIsTooLarge,
  }) async {
    if (reader.canProvide(format)) {
      reader.getFile(format, (dataReaderFile) async {
        if (dataReaderFile.fileSize == null ||
            dataReaderFile.fileSize! > maxUploadSize) {
          return Future.error(fileIsTooLarge);
        }

        final data = await dataReaderFile.readAll();

        if (data.isEmpty) {
          return Future.value(null);
        }

        final tempDir = await getTemporaryDirectory();
        final tempFile = File(p.join(tempDir.path, dataReaderFile.fileName));
        await tempFile.writeAsBytes(data);

        await addAttachment(
          roomId,
          existingFiles: [
            XFile(
              tempFile.path,
              name: dataReaderFile.fileName ?? 'clipboard',
              mimeType:
                  format.mimeTypes?.firstOrNull ??
                  lookupMimeType(tempFile.path),
            ),
          ],
        );

        await tempFile.delete();

        return Future.value(null);
      });
    }
  }
}

Set<SimpleFileFormat> get binaryFormats => {
  Formats.jpeg,
  Formats.png,
  Formats.gif,
  Formats.tiff,
  Formats.bmp,
  Formats.mp3,
  Formats.mp4,
  Formats.pdf,
};
