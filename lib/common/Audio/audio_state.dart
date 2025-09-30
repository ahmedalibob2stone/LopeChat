import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
class AudioState {
  final bool isPlaying;
  final double progress; // 0.0 - 1.0

  AudioState({this.isPlaying = false, this.progress = 0});
}

class AudioController extends StateNotifier<AudioState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _totalDuration = Duration.zero;

  AudioController() : super(AudioState()) {
    _audioPlayer.onPlayerComplete.listen((_) {
      state = AudioState(isPlaying: false, progress: 0);
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      _totalDuration = duration;
    });

    _audioPlayer.onPositionChanged.listen((position) {
      if (_totalDuration.inMilliseconds > 0) {
        state = AudioState(
          isPlaying: state.isPlaying,
          progress: position.inMilliseconds / _totalDuration.inMilliseconds,
        );
      }
    });
  }

  Future<void> playFile(String path) async {
    await _audioPlayer.play(DeviceFileSource(path));
    state = AudioState(isPlaying: true, progress: 0);
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    state = AudioState(isPlaying: false, progress: state.progress);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
