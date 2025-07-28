import 'package:just_audio/just_audio.dart';

class VoiceMessagePlayerController {
  static final VoiceMessagePlayerController _instance =
      VoiceMessagePlayerController._internal();
  factory VoiceMessagePlayerController() => _instance;

  VoiceMessagePlayerController._internal();

  AudioPlayer? _currentPlayer;

  void stopCurrentPlayer() {
    _currentPlayer?.pause();
    _currentPlayer?.seek(Duration.zero);
    _currentPlayer?.setLoopMode(LoopMode.off);
  }

  void setCurrentPlayer(AudioPlayer player) {
    if (_currentPlayer != null && _currentPlayer != player) {
      stopCurrentPlayer();
    }
    _currentPlayer = player;
  }
}
