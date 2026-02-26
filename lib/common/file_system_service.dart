import 'dart:io';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:open_folder/open_folder.dart';
import 'package:permission_handler/permission_handler.dart';

import 'platforms.dart';

class FileSystemService {
  const FileSystemService();

  Future<OpenResult?> openParentDirectory(
    String path, {
    required String fileDoesNotExistMessage,
  }) async {
    final file = File(path);
    if (!(await file.exists())) {
      return Future.value(
        OpenResult(type: ResultType.error, message: fileDoesNotExistMessage),
      );
    }
    final directory = file.parent;
    return OpenFolder.openFolder(directory.path);
  }

  Future<String?> pickLocationAndExportFile({
    required String confirmButtonText,
    required String dialogTitle,
    required Uint8List bytes,
    required String name,
    required String id,
  }) async {
    String? path;
    if (Platforms.isMobile) {
      path = await FilePicker.platform.saveFile(fileName: name, bytes: bytes);
    } else {
      String? directoryPath;
      if (Platforms.isLinux) {
        directoryPath = await getDirectoryPath(
          confirmButtonText: confirmButtonText,
        );
      } else {
        directoryPath = await FilePicker.platform.getDirectoryPath(
          dialogTitle: dialogTitle,
        );
      }
      if (directoryPath != null) {
        path = '$directoryPath/$name';
        final download = File(path);
        await download.writeAsBytes(bytes);
      }
    }

    return path;
  }

  Future<String?> getPathOfDirectory() async {
    if (Platforms.isMobile && await _androidPermissionsGranted()) {
      return FilePicker.platform.getDirectoryPath();
    }

    if (Platforms.isMacOS || Platforms.isLinux || Platforms.isWindows) {
      return getDirectoryPath();
    }
    return null;
  }

  Future<String?> getPathOfFile() async {
    if (Platforms.isMobile && await _androidPermissionsGranted()) {
      return (await FilePicker.platform.pickFiles(
        allowMultiple: false,
      ))?.files.firstOrNull?.path;
    }

    if (Platforms.isMacOS || Platforms.isLinux || Platforms.isWindows) {
      return (await openFile())?.path;
    }
    return null;
  }

  Future<List<String>> getPathsOfFiles() async {
    if (Platforms.isMobile && await _androidPermissionsGranted()) {
      final filePickerResult = await FilePicker.platform.pickFiles(
        allowMultiple: true,
      );

      if (filePickerResult == null) {
        return [];
      }

      return filePickerResult.files
          .map((e) => XFile(e.path!))
          .map((e) => e.path)
          .toList();
    } else if (Platforms.isMacOS || Platforms.isLinux || Platforms.isWindows) {
      return (await openFiles()).map((e) => e.path).toList();
    }
    return [];
  }

  Future<bool> _androidPermissionsGranted() async =>
      (await Permission.audio
              .onDeniedCallback(() {})
              .onGrantedCallback(() {})
              .onPermanentlyDeniedCallback(() {})
              .onRestrictedCallback(() {})
              .onLimitedCallback(() {})
              .onProvisionalCallback(() {})
              .request())
          .isGranted;
}
