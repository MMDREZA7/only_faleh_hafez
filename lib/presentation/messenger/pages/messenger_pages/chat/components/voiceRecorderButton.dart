// import 'dart:io';
// import 'package:flash/flash_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:path_provider/path_provider.dart';

// class VoiceRecordButton extends StatefulWidget {
//   final Future<void> Function(File recordedFile)? onSend;
//   final Color? backgroundColor;
//   final Color? iconColor;

//   const VoiceRecordButton({
//     Key? key,
//     this.onSend,
//     this.backgroundColor = Colors.redAccent,
//     this.iconColor = Colors.white,
//   }) : super(key: key);

//   @override
//   State<VoiceRecordButton> createState() => _VoiceRecordButtonState();
// }

// class _VoiceRecordButtonState extends State<VoiceRecordButton> {
//   final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
//   bool _isRecorderInitialized = false;
//   bool _isRecording = false;
//   String? _filePath;

//   @override
//   void initState() {
//     super.initState();
//     _initRecorder();
//   }

//   Future<void> _initRecorder() async {
//     final status = await Permission.microphone.request();
//     if (status != PermissionStatus.granted) {
//       return;
//     }
//     await _recorder.openRecorder();
//     _isRecorderInitialized = true;
//   }

//   @override
//   void dispose() {
//     _recorder.closeRecorder();
//     super.dispose();
//   }

//   Future<String> _getFilePath() async {
//     final dir = await getApplicationDocumentsDirectory();
//     return '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.aac';
//   }

//   Future<void> _handlePress() async {
//     PermissionStatus status = await Permission.microphone.request();

//     if (!status.isGranted) {
//       context.showErrorBar(
//         content: Text('Microphone permission not granted.'),
//       );
//       openAppSettings();
//       return;
//     }

//     if (!_isRecorderInitialized) return;

//     if (_isRecording) {
//       await _recorder.stopRecorder();
//       setState(() {
//         _isRecording = false;
//       });

//       if (_filePath != null && widget.onSend != null) {
//         await widget.onSend!(File(_filePath!));
//         _filePath = null;
//       }
//     } else {
//       _filePath = await _getFilePath();
//       await _recorder.startRecorder(
//         toFile: _filePath,
//         codec: Codec.aacMP4,
//       );
//       setState(() {
//         _isRecording = true;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     IconData icon = Icons.mic;
//     if (_isRecording) icon = Icons.stop;

//     return IconButton(
//       onPressed: _handlePress,
//       icon: Icon(icon, color: widget.iconColor),
//       color: widget.backgroundColor,
//       iconSize: 30,
//     );
//   }
// }
