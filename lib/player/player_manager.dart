import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import '../common/logging.dart';
import '../extensions/media_x.dart';
import 'view/player_view_state.dart';

class PlayerManager {
  PlayerManager({required VideoController controller})
    : _controller = controller;

  final VideoController _controller;
  VideoController get videoController => _controller;

  final playerViewState = SafeValueNotifier<PlayerViewState>(
    const PlayerViewState(fullMode: false, showQueue: true),
  );

  void updateViewMode({bool? fullMode, bool? showQueue, Color? color}) {
    playerViewState.value = playerViewState.value.copyWith(
      fullMode: fullMode,
      showQueue: showQueue,
      color: color,
    );
  }

  Player get _player => _controller.player;

  Stream<Duration> get positionStream => _player.stream.position;

  Duration get position => _player.state.position;

  Stream<Duration> get bufferedPositionStream => _player.stream.buffer;

  Stream<Duration> get durationStream => _player.stream.duration;

  Duration get duration => _player.state.duration;

  Stream<bool> get isPlayingStream => _player.stream.playing;

  bool get isPlaying => _player.state.playing;

  Stream<Playlist> get playlistStream => _player.stream.playlist;

  Stream<int> get playlistIndexStream => playlistStream.map((e) => e.index);

  int get playlistIndex => _player.state.playlist.index;

  Playlist get playlist => _player.state.playlist;

  Stream<Media> get currentMediaStream =>
      _player.stream.duration.asyncMap((e) async {
        var media = _player.state.playlist.medias[_player.state.playlist.index];
        await _setLocalColor(media);
        return media;
      });

  Media? get currentMedia => _player.state.playlist.medias.isEmpty
      ? null
      : _player.state.playlist.medias[_player.state.playlist.index];

  PlaylistMode get playlistMode => _player.state.playlistMode;

  Stream<PlaylistMode> get playlistModeStream => _player.stream.playlistMode;

  Stream<bool> get shuffleStream => _player.stream.shuffle;

  bool get shuffle => _player.state.shuffle;

  Stream<bool> get isVideoStream => _player.stream.tracks.map(
    (tracks) =>
        tracks.video.isNotEmpty &&
        tracks.video.any((e) => e.fps != null && e.fps! > 1),
  );

  bool get isVideo =>
      _player.state.tracks.video.isNotEmpty &&
      _player.state.tracks.video.any((e) => e.fps != null && e.fps! > 1);

  Future<void> setPlaylist(
    List<Media> mediaList, {
    int index = 0,
    bool play = true,
  }) async {
    if (mediaList.isEmpty) return;
    await _player.open(Playlist(mediaList, index: index));
  }

  Future<void> addToPlaylist(Media media) async {
    if (_player.state.playlist.medias.contains(media)) return;
    await _player.add(media);
  }

  Future<void> removeFromPlaylist(int index) async {
    if (playlist.medias.length < 2) return;
    await _player.remove(index);
  }

  Future<void> jump(int index) => _player.jump(index);

  Future<void> move(int from, int to) => _player.move(from, to);

  Future<void> play() async => _player.play();

  Future<void> pause() async => _player.pause();

  Future<void> playOrPause() => _player.playOrPause();

  Future<void> stop() async => _player.stop();

  Future<void> seek(Duration position) async => _player.seek(position);

  Future<void> setVolume(double volume) async => _player.setVolume(volume);

  Future<void> next() async => _player.next();

  Future<void> previous() async => _player.previous();

  Future<void> setShuffle(bool shuffle) async => _player.setShuffle(shuffle);

  Future<void> toggleShuffle() async =>
      _player.setShuffle(!_player.state.shuffle);

  Future<void> changePlaylistMode() async {
    final currentMode = _player.state.playlistMode;
    PlaylistMode nextMode;
    switch (currentMode) {
      case PlaylistMode.none:
        nextMode = PlaylistMode.loop;
      case PlaylistMode.single:
        nextMode = PlaylistMode.none;
      case PlaylistMode.loop:
        nextMode = PlaylistMode.single;
    }
    await setPlaylistMode(nextMode);
  }

  Future<void> setPlaylistMode(PlaylistMode mode) async =>
      _player.setPlaylistMode(mode);

  Future<void> dispose() async => _player.dispose();

  Future<void> _setLocalColor(Media media) async {
    try {
      final art = media.albumArt;

      if (art != null) {
        final colorScheme = await ColorScheme.fromImageProvider(
          provider: MemoryImage(media.albumArt!),
        );
        updateViewMode(color: colorScheme.primary);
      }
    } on Exception catch (e) {
      printMessageInDebugMode(e);
    }
  }
}
