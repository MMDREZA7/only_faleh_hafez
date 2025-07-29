import 'package:just_audio/just_audio.dart';

class VoiceMessagePlayerController {
  static final VoiceMessagePlayerController _instance =
      VoiceMessagePlayerController._internal();
  factory VoiceMessagePlayerController() => _instance;

  VoiceMessagePlayerController._internal();

  AudioPlayer? _currentPlayer;

  Future<void> stopCurrentPlayer() async {
    if (_currentPlayer != null) {
      await _currentPlayer!.pause();
      await _currentPlayer!.seek(Duration.zero);
      await _currentPlayer!.setLoopMode(LoopMode.off);
    }
  }

  Future<void> setCurrentPlayer(AudioPlayer player) async {
    if (_currentPlayer != null && _currentPlayer != player) {
      await stopCurrentPlayer();
    }
    _currentPlayer = player;
  }
}
