import 'dart:io';
import 'package:Faleh_Hafez/domain/models/message_dto.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/components/voice_message/voice_message_controller.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class ReplyVoiceMessageBubble extends StatefulWidget {
  final List<int> audioBytes;
  final Color backgroundColor;
  final Color foregroundColor;
  final MessageDTO message;
  final ThemeData themeState;

  const ReplyVoiceMessageBubble({
    super.key,
    required this.audioBytes,
    required this.message,
    required this.themeState,
    this.backgroundColor = const Color(0xFFE0F7FA),
    this.foregroundColor = const Color(0xFF006064),
  });

  @override
  State<ReplyVoiceMessageBubble> createState() =>
      _ReplyVoiceMessageBubbleState();
}

class _ReplyVoiceMessageBubbleState extends State<ReplyVoiceMessageBubble> {
  late AudioPlayer _player;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;
  String? _tempFilePath;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _prepareAudio();
  }

  Future<void> _prepareAudio() async {
    final dir = await getTemporaryDirectory();
    final file =
        File('${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.aac');

    await file.writeAsBytes(widget.audioBytes);
    _tempFilePath = file.path;

    await _player.setFilePath(_tempFilePath!);
    _duration = _player.duration ?? Duration.zero;

    print('Audio file path: $_tempFilePath');
    print('Audio file size: ${await File(_tempFilePath!).length()} bytes');

    _player.positionStream.listen((pos) {
      setState(() {
        _position = pos;
      });
    });

    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  void _togglePlayback() async {
    VoiceMessagePlayerController().setCurrentPlayer(_player);

    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(1, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _player.dispose();

    if (_tempFilePath != null) {
      final file = File(_tempFilePath!);
      if (file.existsSync()) {
        file.deleteSync();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_tempFilePath == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final progress = _duration.inMilliseconds == 0
        ? 0.0
        : _position.inMilliseconds / _duration.inMilliseconds;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 12, bottom: 5, top: 3),
          child: Text(
            widget.message.senderDisplayName ??
                widget.message.senderMobileNumber!,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: widget.themeState.colorScheme.background,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  _isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill,
                  size: 36,
                  color: widget.foregroundColor,
                ),
                onPressed: _togglePlayback,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: widget.foregroundColor.withOpacity(0.2),
                  valueColor:
                      AlwaysStoppedAnimation<Color>(widget.foregroundColor),
                  minHeight: 4,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatDuration(_position),
                style: TextStyle(
                  fontSize: 14,
                  color: widget.foregroundColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
