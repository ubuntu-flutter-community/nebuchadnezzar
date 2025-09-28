import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import 'view/player_view_state.dart';

class PlayerManager {
  PlayerManager({required VideoController controller})
    : _controller = controller;

  final VideoController _controller;
  VideoController get videoController => _controller;

  final playerViewMode = SafeValueNotifier<PlayerViewState>(
    PlayerViewState(fullMode: false, showQueue: true),
  );

  void updateViewMode({bool? fullMode}) {
    playerViewMode.value = playerViewMode.value.copyWith(fullMode: fullMode);
  }

  Player get player => _controller.player;

  Stream<Duration> get positionStream => player.stream.position;

  Duration get position => player.state.position;

  Stream<Duration> get bufferedPositionStream => player.stream.buffer;

  Stream<Duration> get durationStream => player.stream.duration;

  Duration get duration => player.state.duration;

  Stream<bool> get isPlayingStream => player.stream.playing;

  bool get isPlaying => player.state.playing;

  Stream<Playlist> get playlistStream => player.stream.playlist;

  Stream<int> get playlistIndexStream => playlistStream.map((e) => e.index);

  int get playlistIndex => player.state.playlist.index;

  Playlist get playlist => player.state.playlist;

  Stream<Media?> get currentMediaStream =>
      playlistStream.map((e) => e.medias.firstOrNull);

  Media? get currentMedia => player.state.playlist.medias.firstOrNull;

  PlaylistMode get playlistMode => player.state.playlistMode;

  Stream<PlaylistMode> get playlistModeStream => player.stream.playlistMode;

  Stream<bool> get shuffleStream => player.stream.shuffle;

  bool get shuffle => player.state.shuffle;

  Stream<bool> get isVideoStream => player.stream.tracks.map(
    (tracks) =>
        tracks.video.isNotEmpty &&
        tracks.video.any((e) => e.fps != null && e.fps! > 1),
  );

  bool get isVideo =>
      player.state.tracks.video.isNotEmpty &&
      player.state.tracks.video.any((e) => e.fps != null && e.fps! > 1);

  Future<void> setPlaylist(
    List<Media> mediaList, {
    int index = 0,
    bool play = true,
  }) async {
    if (mediaList.isEmpty) return;
    await player.open(Playlist(mediaList, index: index));
  }

  Future<void> addToPlaylist(Media media) async {
    if (player.state.playlist.medias.contains(media)) return;
    await player.add(media);
  }

  Future<void> removeFromPlaylist(int index) async {
    if (playlist.medias.length < 2) return;
    await player.remove(index);
  }

  Future<void> jump(int index) => player.jump(index);

  Future<void> play() async => player.play();

  Future<void> pause() async => player.pause();

  Future<void> playOrPause() => player.playOrPause();

  Future<void> stop() async => player.stop();

  Future<void> seek(Duration position) async => player.seek(position);

  Future<void> setVolume(double volume) async => player.setVolume(volume);

  Future<void> next() async => player.next();

  Future<void> previous() async => player.previous();

  Future<void> setShuffle(bool shuffle) async => player.setShuffle(shuffle);

  Future<void> toggleShuffle() async =>
      player.setShuffle(!player.state.shuffle);

  Future<void> setPlaylistMode(PlaylistMode mode) async =>
      player.setPlaylistMode(mode);

  Future<void> changePlaylistMode() async {
    final currentMode = player.state.playlistMode;
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

  Future<void> dispose() async => player.dispose();
}
