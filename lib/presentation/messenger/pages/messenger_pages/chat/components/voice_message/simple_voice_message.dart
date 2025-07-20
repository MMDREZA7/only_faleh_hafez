// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:intl/intl.dart';

// class VoiceMessageBubble extends StatefulWidget {
//   final String audioPath;
//   final Color backgroundColor;
//   final Color foregroundColor;

//   const VoiceMessageBubble({
//     super.key,
//     required this.audioPath,
//     this.backgroundColor = const Color(0xFFE0F7FA),
//     this.foregroundColor = const Color(0xFF006064),
//   });

//   @override
//   State<VoiceMessageBubble> createState() => _VoiceMessageBubbleState();
// }

// class _VoiceMessageBubbleState extends State<VoiceMessageBubble> {
//   late AudioPlayer _player;
//   Duration _duration = Duration.zero;
//   Duration _position = Duration.zero;
//   bool _isPlaying = false;

//   @override
//   void initState() {
//     super.initState();
//     _player = AudioPlayer();
//     _initAudio();
//   }

//   Future<void> _initAudio() async {
//     await _player.setFilePath(widget.audioPath);
//     _duration = _player.duration ?? Duration.zero;

//     _player.positionStream.listen((pos) {
//       setState(() {
//         _position = pos;
//       });
//     });

//     _player.playerStateStream.listen((state) {
//       if (state.processingState == ProcessingState.completed) {
//         setState(() {
//           _isPlaying = false;
//           _position = Duration.zero;
//         });
//         _player.seek(Duration.zero);
//       }
//     });
//   }

//   void _togglePlayback() async {
//     if (_isPlaying) {
//       await _player.pause();
//     } else {
//       await _player.play();
//     }
//     setState(() => _isPlaying = !_isPlaying);
//   }

//   String _formatDuration(Duration duration) {
//     final minutes = duration.inMinutes.toString().padLeft(1, '0');
//     final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
//     return '$minutes:$seconds';
//   }

//   @override
//   void dispose() {
//     _player.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final progress = _duration.inMilliseconds == 0
//         ? 0.0
//         : _position.inMilliseconds / _duration.inMilliseconds;

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       margin: const EdgeInsets.all(6),
//       decoration: BoxDecoration(
//         color: widget.backgroundColor,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           IconButton(
//             icon: Icon(
//               _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
//               size: 36,
//               color: widget.foregroundColor,
//             ),
//             onPressed: _togglePlayback,
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: LinearProgressIndicator(
//               value: progress,
//               backgroundColor: widget.foregroundColor.withOpacity(0.2),
//               valueColor: AlwaysStoppedAnimation<Color>(widget.foregroundColor),
//               minHeight: 4,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Text(
//             _formatDuration(_position),
//             style: TextStyle(
//               fontSize: 14,
//               color: widget.foregroundColor,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
