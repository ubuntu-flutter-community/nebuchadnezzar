import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import '../../chat_room/common/view/audio_visualizer.dart';
import '../../chat_room/input/record_service.dart';

class ChatMessageVoiceRecordingVisualizer extends StatelessWidget {
  const ChatMessageVoiceRecordingVisualizer({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    final audioContent =
        event.content['org.matrix.msc1767.audio'] as Map<String, dynamic>?;
    final waveForm = audioContent?.tryGet<List<dynamic>>('waveform') ?? [];
    final durationSeconds = audioContent?.tryGet<int>('duration') ?? 0;

    return AudioVisualizer(
      event: event,
      height: 40,
      recording: AudioRecording(
        path: null,
        waveform: waveForm.map((e) => e as int).toList(),
        duration: Duration(seconds: durationSeconds),
      ),
    );
  }
}
