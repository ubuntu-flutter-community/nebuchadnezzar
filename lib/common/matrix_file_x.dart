import 'package:matrix/matrix.dart';

extension MatrixFileX on MatrixFile {
  bool get isRegularImage => mimeType.startsWith('image') && !isSvgImage;
  bool get isSvgImage => mimeType == 'image/svg+xml';
  bool get isVideo => mimeType.startsWith('video');
  bool get isAudio => mimeType.startsWith('audio');
}
