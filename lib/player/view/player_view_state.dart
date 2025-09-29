// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:ui';

class PlayerViewState {
  const PlayerViewState({
    required this.fullMode,
    required this.showPlayerExplorer,
    this.explorerIndex = 0,
    this.color,
    this.remoteSourceArtUrl,
    this.remoteSourceTitle,
  });

  final bool fullMode;
  final bool showPlayerExplorer;
  final int explorerIndex;
  final Color? color;
  final String? remoteSourceArtUrl;
  final String? remoteSourceTitle;

  PlayerViewState copyWith({
    bool? fullMode,
    bool? showPlayerExplorer,
    int? explorerIndex,
    Color? color,
    String? remoteSourceArtUrl,
    String? remoteSourceTitle,
  }) => PlayerViewState(
    fullMode: fullMode ?? this.fullMode,
    showPlayerExplorer: showPlayerExplorer ?? this.showPlayerExplorer,
    explorerIndex: explorerIndex ?? this.explorerIndex,
    color: color ?? this.color,
    remoteSourceArtUrl: remoteSourceArtUrl ?? this.remoteSourceArtUrl,
    remoteSourceTitle: remoteSourceTitle ?? this.remoteSourceTitle,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullMode': fullMode,
      'showPlayerExplorer': showPlayerExplorer,
      'explorerIndex': explorerIndex,
      'color': color?.value,
      'remoteSourceArtUrl': remoteSourceArtUrl,
      'remoteSourceTitle': remoteSourceTitle,
    };
  }

  factory PlayerViewState.fromMap(Map<String, dynamic> map) {
    return PlayerViewState(
      fullMode: map['fullMode'] as bool,
      showPlayerExplorer: map['showPlayerExplorer'] as bool,
      explorerIndex: map['explorerIndex'] as int,
      color: map['color'] != null ? Color(map['color'] as int) : null,
      remoteSourceArtUrl: map['remoteSourceArtUrl'] as String?,
      remoteSourceTitle: map['remoteSourceTitle'] as String?,
    );
  }
  String toJson() => json.encode(toMap());
  factory PlayerViewState.fromJson(String source) =>
      PlayerViewState.fromMap(json.decode(source) as Map<String, dynamic>);
  @override
  String toString() {
    return 'PlayerViewState(fullMode: $fullMode, showPlayerExplorer: $showPlayerExplorer, explorerIndex: $explorerIndex, color: $color, remoteSourceArtUrl: $remoteSourceArtUrl, remoteSourceTitle: $remoteSourceTitle)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlayerViewState &&
        other.fullMode == fullMode &&
        other.showPlayerExplorer == showPlayerExplorer &&
        other.explorerIndex == explorerIndex &&
        other.color == color &&
        other.remoteSourceArtUrl == remoteSourceArtUrl &&
        other.remoteSourceTitle == remoteSourceTitle;
  }

  @override
  int get hashCode {
    return fullMode.hashCode ^
        showPlayerExplorer.hashCode ^
        explorerIndex.hashCode ^
        color.hashCode ^
        remoteSourceArtUrl.hashCode ^
        remoteSourceTitle.hashCode;
  }
}
