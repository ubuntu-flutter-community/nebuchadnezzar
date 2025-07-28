import 'package:file_selector/file_selector.dart';

extension XTypeGroupX on XTypeGroup {
  static XTypeGroup get jpgsTypeGroup =>
      const XTypeGroup(label: 'JPEGs', extensions: <String>['jpg', 'jpeg']);
  static XTypeGroup get pngTypeGroup =>
      const XTypeGroup(label: 'PNGs', extensions: <String>['png']);
}
