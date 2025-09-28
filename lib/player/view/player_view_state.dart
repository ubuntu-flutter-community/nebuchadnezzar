import 'dart:convert';
import 'dart:ui';

class PlayerViewState {
  const PlayerViewState({
    required this.fullMode,
    required this.showQueue,
    this.color,
  });

  final bool fullMode;
  final bool showQueue;
  final Color? color;

  PlayerViewState copyWith({bool? fullMode, bool? showQueue, Color? color}) {
    return PlayerViewState(
      fullMode: fullMode ?? this.fullMode,
      showQueue: showQueue ?? this.showQueue,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return {'fullMode': fullMode, 'showQueue': showQueue, 'color': color};
  }

  factory PlayerViewState.fromMap(Map<String, dynamic> map) {
    return PlayerViewState(
      fullMode: map['fullMode'] ?? false,
      showQueue: map['showQueue'] ?? false,
      color: map['color'] != null ? Color(map['color']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlayerViewState.fromJson(String source) =>
      PlayerViewState.fromMap(json.decode(source));

  @override
  String toString() =>
      'PlayerViewState(fullMode: $fullMode, showQueue: $showQueue, color: $color)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlayerViewState &&
        other.fullMode == fullMode &&
        other.showQueue == showQueue &&
        other.color == color;
  }

  @override
  int get hashCode => fullMode.hashCode ^ showQueue.hashCode ^ color.hashCode;
}
