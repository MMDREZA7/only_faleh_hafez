// import 'dart:io';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:record/record.dart';
// import 'package:path_provider/path_provider.dart';

// class VoiceRecorderPage extends StatefulWidget {
//   @override
//   _VoiceRecorderPageState createState() => _VoiceRecorderPageState();
// }

// class _VoiceRecorderPageState extends State<VoiceRecorderPage> {
//   final AudioRecorder _recorder = AudioRecorder();
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   List<String> _recordings = [];
//   bool _isRecording = false;

//   Future<void> _startRecording() async {
//     if (await _recorder.hasPermission()) {
//       Directory tempDir = await getApplicationDocumentsDirectory();
//       String filePath =
//           '${tempDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

//       await _recorder.start(RecordConfig(), path: filePath);
//       setState(() => _isRecording = true);
//     }
//   }

//   Future<void> _stopRecording() async {
//     String? filePath = await _recorder.stop();
//     if (filePath != null) {
//       setState(() {
//         _recordings.add(filePath);
//         _isRecording = false;
//       });
//     }
//   }

//   Future<void> _playRecording(String filePath) async {
//     await _audioPlayer.play(DeviceFileSource(filePath));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Voice Recorder")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: _isRecording ? _stopRecording : _startRecording,
//               child: Text(_isRecording ? "Stop Recording" : "Start Recording"),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _recordings.length,
//                 itemBuilder: (context, index) {
//                   return Card(
//                     child: ListTile(
//                       title: Text("Recording ${index + 1}"),
//                       trailing: IconButton(
//                         icon: Icon(Icons.play_arrow),
//                         onPressed: () => _playRecording(_recordings[index]),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
