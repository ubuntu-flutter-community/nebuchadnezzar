import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';
import 'package:yaru/yaru.dart';

import '../common/logging.dart';
import '../extensions/string_x.dart';
import 'data/local_media.dart';
import 'data/unique_media.dart';
import 'view/player_view_state.dart';

class PlayerManager extends BaseAudioHandler with SeekHandler {
  PlayerManager({required VideoController controller})
    : _controller = controller {
    playbackState.add(
      PlaybackState(
        playing: false,
        systemActions: {
          MediaAction.seek,
          MediaAction.seekBackward,
          MediaAction.seekForward,
        },
        controls: [
          MediaControl.skipToPrevious,
          MediaControl.rewind,
          MediaControl.play,
          MediaControl.fastForward,
          MediaControl.skipToNext,
        ],
      ),
    );
  }

  final VideoController _controller;
  VideoController get videoController => _controller;

  final playerViewState = SafeValueNotifier<PlayerViewState>(
    const PlayerViewState(fullMode: false, showPlayerExplorer: true),
  );

  void updateState({
    bool? fullMode,
    bool? showPlayerExplorer,
    int? explorerIndex,
    Color? color,
    String? remoteSourceArtUrl,
    String? remoteSourceTitle,
  }) {
    final art = remoteSourceArtUrl?.endsWith('.ico') == true
        ? null
        : remoteSourceArtUrl;
    playerViewState.value = playerViewState.value.copyWith(
      fullMode: fullMode,
      showPlayerExplorer: showPlayerExplorer,
      explorerIndex: explorerIndex,
      color: color,
      remoteSourceArtUrl: art,
      remoteSourceTitle: remoteSourceTitle,
    );

    if (remoteSourceTitle != null) {
      final uri = Uri.tryParse(art ?? '');
      final split = remoteSourceTitle.splitByDash;
      mediaItem.add(
        MediaItem(
          id: remoteSourceTitle,
          title: remoteSourceTitle,
          artist: currentMedia?.artist ?? split.artist,
          artUri: uri,
        ),
      );
    }
  }

  Player get _player => _controller.player;
  Player get player => _player;

  Stream<Duration> get positionStream => _player.stream.position.map((e) {
    playbackState.add(playbackState.value.copyWith(updatePosition: position));
    return e;
  }).distinct();

  Duration get position => _player.state.position;

  Stream<Duration> get bufferedPositionStream =>
      _player.stream.buffer.distinct();

  Stream<Duration> get durationStream => _player.stream.duration.map((e) {
    if (mediaItem.value != null) {
      mediaItem.add(mediaItem.value!.copyWith(duration: duration));
    }
    return e;
  }).distinct();

  Duration get duration => _player.state.duration;

  Stream<bool> get isPlayingStream => _player.stream.playing.map((e) {
    playbackState.add(
      playbackState.value.copyWith(
        playing: isPlaying,
        controls: [
          MediaControl.skipToPrevious,
          isPlaying ? MediaControl.pause : MediaControl.play,

          MediaControl.skipToNext,
        ],
        processingState: AudioProcessingState.ready,
      ),
    );
    return e;
  }).distinct();

  bool get isPlaying => _player.state.playing;

  Stream<Playlist> get playlistStream => _player.stream.playlist.distinct();

  Stream<int> get playlistIndexStream =>
      playlistStream.map((e) => e.index).distinct();

  int get playlistIndex => _player.state.playlist.index;

  Playlist get playlist => _player.state.playlist;

  Stream<UniqueMedia> get currentMediaStream =>
      _player.stream.playlist.asyncMap((playlist) async {
        final media = playlist.medias[playlist.index] as UniqueMedia;

        final artUri =
            media is LocalMedia ||
                playerViewState.value.remoteSourceArtUrl == null
            ? await media.artUri
            : Uri.tryParse(playerViewState.value.remoteSourceArtUrl!);

        mediaItem.add(
          MediaItem(
            id: media.id,
            title: media.title ?? media.uri.toString(),
            artist: media.artist,
            album: media.collectionName,
            duration: media.duration ?? duration,
            artUri: artUri,
          ),
        );

        if (media is LocalMedia) {
          await _setLocalColor(media);
        }

        return media;
      }).distinct();

  UniqueMedia? get currentMedia => _player.state.playlist.medias.isEmpty
      ? null
      : _player.state.playlist.medias[_player.state.playlist.index]
            as UniqueMedia;

  PlaylistMode get playlistMode => _player.state.playlistMode;

  Stream<PlaylistMode> get playlistModeStream =>
      _player.stream.playlistMode.distinct();

  Stream<bool> get shuffleStream => _player.stream.shuffle;

  bool get shuffle => _player.state.shuffle;

  Stream<bool> get isVideoStream => _player.stream.tracks
      .map(
        (tracks) =>
            tracks.video.isNotEmpty &&
            tracks.video.any((e) => e.fps != null && e.fps! > 1),
      )
      .distinct();

  bool get isVideo =>
      _player.state.tracks.video.isNotEmpty &&
      _player.state.tracks.video.any((e) => e.fps != null && e.fps! > 1);

  Future<void> setPlaylist(List<UniqueMedia> mediaList, {int index = 0}) async {
    if (mediaList.isEmpty) return;
    updateState(
      remoteSourceArtUrl:
          mediaList.elementAtOrNull(index)?.artUrl?.endsWith('.ico') == true
          ? null
          : mediaList.elementAtOrNull(index)?.artUrl,
      remoteSourceTitle: mediaList.elementAtOrNull(index)?.title,
    );
    await _player.open(Playlist(mediaList, index: index));
  }

  Future<void> addToPlaylist(UniqueMedia media) async => _player.add(media);

  Future<void> removeFromPlaylist(int index) async {
    if (playlist.medias.length < 2) return;
    await _player.remove(index);
  }

  Future<void> jump(int index) => _player.jump(index);

  Future<void> move(int from, int to) => _player.move(from, to);

  @override
  Future<void> play() async => _player.play();

  @override
  Future<void> pause() async => _player.pause();

  Future<void> playOrPause() => _player.playOrPause();

  @override
  Future<void> stop() async => _player.stop();

  @override
  Future<void> seek(Duration position) async => _player.seek(position);

  Future<void> setVolume(double volume) async => _player.setVolume(volume);

  Stream<double> get volumeStream => _player.stream.volume;

  double get volume => _player.state.volume;

  @override
  Future<void> skipToNext() async => _player.next();

  @override
  Future<void> skipToPrevious() async => _player.previous();

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

  Future<void> _setLocalColor(LocalMedia media) async {
    try {
      final art = media.artData;

      if (art != null) {
        final colorScheme = await ColorScheme.fromImageProvider(
          provider: MemoryImage(art),
        );
        updateState(color: colorScheme.primary);
      }
    } on Exception catch (e) {
      printMessageInDebugMode(e);
    }
  }

  Future<void> setRemoteColorFromImageProvider(ImageProvider provider) async {
    try {
      final colorScheme = await ColorScheme.fromImageProvider(
        provider: provider,
      );
      updateState(color: colorScheme.primary.scale(saturation: 1));
    } on Exception catch (e) {
      printMessageInDebugMode(e);
    }
  }
}
