import 'dart:convert';

class PlayerViewState {
  PlayerViewState({this.fullMode = false, required this.showQueue});

  final bool fullMode;
  final bool showQueue;

  PlayerViewState copyWith({bool? fullMode, bool? showQueue}) {
    return PlayerViewState(
      fullMode: fullMode ?? this.fullMode,
      showQueue: showQueue ?? this.showQueue,
    );
  }

  Map<String, dynamic> toMap() {
    return {'fullMode': fullMode, 'showQueue': showQueue};
  }

  factory PlayerViewState.fromMap(Map<String, dynamic> map) {
    return PlayerViewState(
      fullMode: map['fullMode'] ?? false,
      showQueue: map['showQueue'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlayerViewState.fromJson(String source) =>
      PlayerViewState.fromMap(json.decode(source));

  @override
  String toString() =>
      'PlayerViewState(fullMode: $fullMode, showQueue: $showQueue)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlayerViewState &&
        other.fullMode == fullMode &&
        other.showQueue == showQueue;
  }

  @override
  int get hashCode => fullMode.hashCode ^ showQueue.hashCode;
}
