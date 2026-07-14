import 'package:injectable/injectable.dart';
import 'package:record/record.dart';

@module
abstract class AudioRecorderModule {
  @lazySingleton
  AudioRecorder get audioRecorder => AudioRecorder();
}
