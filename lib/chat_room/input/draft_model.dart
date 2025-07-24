import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:matrix/matrix.dart';
import 'package:mime/mime.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';
import 'package:video_compress/video_compress.dart';

import '../../common/local_image_service.dart';
import '../../common/logging.dart';
import '../../common/platforms.dart';

class DraftModel extends SafeChangeNotifier {
  DraftModel({
    required Client client,
    required LocalImageService localImageService,
  }) : _client = client,
       _localImageService = localImageService;

  final Client _client;
  final LocalImageService _localImageService;

  bool _sending = false;
  bool get sending => _sending;
  void _setSending(bool value) {
    if (value == _sending) return;
    _sending = value;
    notifyListeners();
  }

  Event? _replyEvent;
  Event? get replyEvent => _replyEvent;
  void setReplyEvent(Event? event) {
    _replyEvent = event;
    notifyListeners();
  }

  final Map<String, Event?> _editEvents = {};
  Event? getEditEvent(String roomId) => _editEvents[roomId];
  void setEditEvent({required String roomId, Event? event}) {
    _editEvents[roomId] = event;
    notifyListeners();
  }

  int get maxUploadSize => _mediaConfig?.mUploadSize ?? 100 * 1000 * 1000;
  MediaConfig? _mediaConfig;

  Future<void> send({
    required Room room,
    String? text,
    required Function(String error) onFail,
    required Function() onSuccess,
  }) async {
    _setSending(true);

    try {
      await room.setTyping(false);
    } on Exception catch (e, s) {
      onFail(e.toString());
      printMessageInDebugMode(e, s);
    }

    final textDraft = '${getTextDraft(room.id)}';
    removeTextDraft(room.id);
    final matrixFiles = List<MatrixFile>.from(getFilesDraft(room.id));
    if (matrixFiles.isNotEmpty) {
      for (var matrixFile in matrixFiles) {
        removeFileFromDraft(roomId: room.id, file: matrixFile);
        final xFile = _matrixFilesToXFile[matrixFile];
        String? eventId;
        MatrixFile? compressedFile;
        try {
          if (getCompressFile(roomId: room.id, file: matrixFile)) {
            _mediaConfig ??= await _client.getConfig();
            compressedFile = await MatrixImageFile.shrink(
              bytes: matrixFile.bytes,
              name: matrixFile.name,
              mimeType: matrixFile.mimeType,
              maxDimension: 2500,
              nativeImplementations: _client.nativeImplementations,
            );
          }

          eventId = await room.sendFileEvent(
            compressedFile ?? matrixFile,
            inReplyTo: replyEvent,
            editEventId: _editEvents[room.id]?.eventId,
            thumbnail: matrixFile.mimeType.startsWith('video') && xFile != null
                ? await getVideoThumbnail(xFile)
                : null,
            extraContent: textDraft.isNotEmpty ? {'body': textDraft} : null,
          );
          if (eventId != null) {
            _matrixFilesToXFile.remove(matrixFile);
            removeCompress(roomId: room.id, file: matrixFile);
          }
          onSuccess();
        } on Exception catch (e, s) {
          onFail(e.toString());
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
        );
      } on Exception catch (e, s) {
        onFail(e.toString());
        printMessageInDebugMode(e, s);
      }
      if (eventId == null) {
        setTextDraft(roomId: room.id, draft: textDraft, notify: true);
      }
    }

    _sending = false;
    _replyEvent = null;
    _editEvents[room.id] = null;

    notifyListeners();
  }

  final Map<String, String> _textDrafts = {};
  int get draftLength => _textDrafts.length;
  String? getTextDraft(String roomId) => _textDrafts[roomId];
  void setTextDraft({
    required String roomId,
    required String draft,
    required bool notify,
  }) {
    _textDrafts[roomId] = draft;
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
    required Function(String error) onFail,
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
      final mime = xFile.mimeType;
      final bytes = await xFile.readAsBytes();
      MatrixFile matrixFile;
      if (mime?.startsWith('image') == true) {
        matrixFile = MatrixImageFile(
          bytes: bytes,
          name: xFile.name,
          mimeType: mime,
        );
      } else if (mime?.startsWith('video') == true) {
        matrixFile = MatrixVideoFile(
          bytes: bytes,
          name: xFile.name,
          mimeType: mime,
        );
        _matrixFilesToXFile.update(
          matrixFile,
          (v) => xFile,
          ifAbsent: () => xFile,
        );
      } else {
        matrixFile = MatrixFile.fromMimeType(
          bytes: bytes,
          name: xFile.name,
          mimeType: mime,
        );
      }

      addFileToDraft(roomId: roomId, file: matrixFile);
    }

    setAttaching(false);
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

  // final Map<MatrixVideoFile, XFile> _fileMap = {};

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
}
