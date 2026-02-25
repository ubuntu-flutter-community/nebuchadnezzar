import 'dart:async';

import 'package:record/record.dart';

import '../../common/platforms.dart';

class RecordService {
  RecordService({required AudioRecorder audioRecorder})
    : _audioRecorder = audioRecorder;

  final AudioRecorder _audioRecorder;

  Stopwatch? _stopwatch;
  List<double> _tempAmplitudeTimeline = [];
  List<int> _tempWaveform = [];

  Future<bool> hasPermission() => _audioRecorder.hasPermission(request: false);

  Future<void> startRecording() async {
    final path = await Platforms.getTempFilePath(
      'recording_${DateTime.now().millisecondsSinceEpoch}.m4a',
    );

    if (await _audioRecorder.hasPermission()) {
      await _audioRecorder.start(const RecordConfig(), path: path);
      _stopwatch = Stopwatch()..start();
      Timer.periodic(const Duration(milliseconds: 100), (timer) async {
        if (_stopwatch == null || !_stopwatch!.isRunning) {
          timer.cancel();
          return;
        }
        final amplitude = await _audioRecorder.getAmplitude();
        var value = 100 + amplitude.current * 2;
        value = value < 1 ? 1 : value;
        _tempAmplitudeTimeline.add(value);
      });
    } else {
      throw Exception('Microphone permission denied');
    }
  }

  Future<AudioRecording?> stopRecording() async {
    final path = await _audioRecorder.stop();
    _stopwatch?.stop();
    AudioRecording? audioRecording;
    if (path == null) {
      audioRecording = null;
    } else {
      const waveCount = AudioRecording.waveCount;
      final step = _tempAmplitudeTimeline.length < waveCount
          ? 1
          : (_tempAmplitudeTimeline.length / waveCount).round();
      for (var i = 0; i < _tempAmplitudeTimeline.length; i += step) {
        _tempWaveform.add((_tempAmplitudeTimeline[i] / 100 * 1024).round());
      }
      audioRecording = AudioRecording(
        path: path,
        waveform: _tempWaveform,
        duration: _stopwatch?.elapsed ?? Duration.zero,
      );
    }

    _tempAmplitudeTimeline = [];
    _tempWaveform = [];
    return audioRecording;
  }

  Future<void> cancelRecording() => _audioRecorder.cancel();

  Future<void> dispose() async {
    await _audioRecorder.dispose();
  }
}

class AudioRecording {
  const AudioRecording({
    required this.path,
    required this.waveform,
    required this.duration,
  });

  final String? path;
  final List<int> waveform;
  final Duration duration;

  static const waveCount = 40;

  List<int>? get normalizedWaveform {
    final eventWaveForm = List<int>.from(waveform);

    while (eventWaveForm.length < AudioRecording.waveCount) {
      for (var i = 0; i < eventWaveForm.length; i = i + 2) {
        eventWaveForm.insert(i, eventWaveForm[i]);
      }
    }
    var i = 0;
    final step = (eventWaveForm.length / AudioRecording.waveCount).round();
    while (eventWaveForm.length > AudioRecording.waveCount) {
      eventWaveForm.removeAt(i);
      i = (i + step) % AudioRecording.waveCount;
    }
    return eventWaveForm.map((i) => i > 1024 ? 1024 : i).toList();
  }
}
