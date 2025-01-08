import 'package:matrix/matrix.dart';

extension MatrixFileX on MatrixFile {
  bool get isImage => mimeType.startsWith('image');
  bool get isVideo => mimeType.startsWith('video');
  bool get isAudio => mimeType.startsWith('audio');
}
