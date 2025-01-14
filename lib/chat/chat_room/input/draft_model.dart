import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:matrix/matrix.dart';
import 'package:mime/mime.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';
import 'package:video_compress/video_compress.dart';
import 'package:yaru/yaru.dart';

import '../../../common/logging.dart';
import '../../common/local_image_service.dart';

class DraftModel extends SafeChangeNotifier {
  DraftModel({
    required Client client,
    required LocalImageService localImageService,
  })  : _client = client,
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

  Future<void> send({
    required Room room,
    required Function(String error) onFail,
  }) async {
    _setSending(true);

    try {
      room.setTyping(false);
    } on Exception catch (e, s) {
      onFail(e.toString());
      printMessageInDebugMode(e, s);
    }

    final matrixFiles = List<MatrixFile>.from(getFilesDraft(room.id));
    if (matrixFiles.isNotEmpty) {
      for (var matrixFile in matrixFiles) {
        removeFileFromDraft(roomId: room.id, file: matrixFile);
        final xFile = _matrixFilesToXFile[matrixFile];
        String? eventId;
        try {
          eventId = await room.sendFileEvent(
            matrixFile,
            thumbnail: matrixFile.mimeType.startsWith('video') && xFile != null
                ? await getVideoThumbnail(xFile)
                : null,
          );
          if (eventId != null) {
            _matrixFilesToXFile.remove(matrixFile);
          }
        } on Exception catch (e, s) {
          onFail(e.toString());
          printMessageInDebugMode(e, s);
        }
      }
    }

    if (getDraft(room.id)?.isNotEmpty == true) {
      final draft = '${getDraft(room.id)}';
      removeDraft(room.id);
      String? eventId;
      try {
        eventId = await room.sendTextEvent(
          draft.trim(),
          inReplyTo: replyEvent,
          editEventId: _editEvents[room.id]?.eventId,
        );
      } on Exception catch (e, s) {
        onFail(e.toString());
        printMessageInDebugMode(e, s);
      }
      if (eventId == null) {
        setDraft(roomId: room.id, draft: draft, notify: true);
      }
    }

    _sending = false;
    _replyEvent = null;
    _editEvents[room.id] = null;

    notifyListeners();
  }

  final Map<String, String> _drafts = {};
  int get draftLength => _drafts.length;
  Map<String, String?> get drafts => _drafts;
  String? getDraft(String roomId) => _drafts[roomId];
  void setDraft({
    required String roomId,
    required String draft,
    required bool notify,
  }) {
    _drafts[roomId] = draft;
    if (notify) {
      notifyListeners();
    }
  }

  void removeDraft(String roomId) {
    final oldDraft = _drafts[roomId];
    if (oldDraft == null) return;
    _drafts.remove(roomId);
    notifyListeners();
  }

  final Map<String, List<MatrixFile>> _filesDrafts = {};
  int get filesDraftLength => _filesDrafts.length;
  Map<String, List<MatrixFile>> get filesDrafts => _filesDrafts;
  List<MatrixFile> getFilesDraft(String roomId) => _filesDrafts[roomId] ?? [];
  void addFileToDraft({
    required String roomId,
    required MatrixFile file,
  }) {
    final files = _filesDrafts[roomId] ?? [];
    if (!files.contains(file)) {
      files.add(file);
      _localImageService.put(id: file.name, data: file.bytes);
      _filesDrafts.update(
        roomId,
        (value) => files,
        ifAbsent: () => files,
      );
    }
    notifyListeners();
  }

  void removeFileFromDraft({required String roomId, required MatrixFile file}) {
    final files = _filesDrafts[roomId] ?? [];
    if (files.contains(file)) {
      files.remove(file);
      _filesDrafts.update(
        roomId,
        (value) => files,
      );
      notifyListeners();
    }
    if (getFilesDraft(roomId).isEmpty) {
      setAttaching(false);
    }
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
  }) async {
    setAttaching(true);

    List<XFile>? xFiles;

    if (Platform.isLinux) {
      xFiles = await openFiles();
    } else {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );
      xFiles = result?.files
          .map(
            (f) => XFile(
              f.path!,
              mimeType: lookupMimeType(f.path!),
            ),
          )
          .toList();
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
        matrixFile = await MatrixImageFile.shrink(
          bytes: bytes,
          name: xFile.name,
          mimeType: mime,
          maxDimension: 2500,
          nativeImplementations: _client.nativeImplementations,
        );
      } else if (mime?.startsWith('video') == true) {
        matrixFile =
            MatrixVideoFile(bytes: bytes, name: xFile.name, mimeType: mime);
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

      addFileToDraft(
        roomId: roomId,
        file: matrixFile,
      );
    }

    setAttaching(false);
  }

  static const int max = 1200;
  static const int quality = 40;

  Future<MatrixVideoFile> resizeVideo(XFile xFile) async {
    MediaInfo? mediaInfo;
    try {
      if (isMobile) {
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
    if (!isMobile) return null;

    try {
      final bytes = await VideoCompress.getByteThumbnail(xFile.path);
      if (bytes == null) return null;
      return MatrixImageFile(
        bytes: bytes,
        name: xFile.name,
      );
    } catch (e, s) {
      Logs().w('Error while compressing video', e, s);
    }
    return null;
  }

  bool _attachingAvatar = false;
  bool get attachingAvatar => _attachingAvatar;
  void setAttachingAvatar(bool value) {
    if (value == _attachingAvatar) return;
    _attachingAvatar = value;

    notifyListeners();
  }

  MatrixFile? _avatarDraftFile;
  MatrixFile? get avatarDraftFile => _avatarDraftFile;
  void resetAvatar() {
    _avatarDraftFile = null;
    notifyListeners();
  }

  Future<void> setRoomAvatar({
    required Room? room,
    required Function(String error) onFail,
    required Function() onWrongFileFormat,
  }) async {
    setAttachingAvatar(true);

    try {
      XFile? xFile;
      if (Platform.isLinux) {
        xFile = await openFile();
      } else {
        final result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.image,
        );
        xFile = result?.files
            .map(
              (f) => XFile(
                f.path!,
                mimeType: lookupMimeType(f.path!),
              ),
            )
            .toList()
            .firstOrNull;
      }

      if (xFile == null) {
        setAttachingAvatar(false);
        return;
      }

      final mime = xFile.mimeType;
      final bytes = await xFile.readAsBytes();

      if (mime?.startsWith('image') == true && mime?.endsWith('svg') != true) {
        _avatarDraftFile = await MatrixImageFile.shrink(
          bytes: bytes,
          name: xFile.name,
          mimeType: mime,
          maxDimension: 1000,
          nativeImplementations: _client.nativeImplementations,
        );
      } else {
        onWrongFileFormat();
      }

      if (room != null) {
        await room.setAvatar(_avatarDraftFile);
        _avatarDraftFile = null;
      }
    } on Exception catch (e, s) {
      onFail(e.toString());
      printMessageInDebugMode(e, s);
    }

    setAttachingAvatar(false);
  }
}
