// // ignore_for_file: file_names

// import 'package:signalr_core/signalr_core.dart';

// class SignalRService {
//   late HubConnection _connection;

//   Future<void> initConnection() async {
//     _connection =
//         HubConnectionBuilder().withUrl('http://185.231.115.133/hub').build();

//     _connection.on('ReceiveMessage', (message) {
//       print('Message received: $message');
//     });

//     await _connection.start();
//   }

//   Future<void> sendMessage(String user, String message) async {
//     await _connection.invoke('SendMessage', args: [user, message]);
//   }

//   Stream<dynamic> get onMessageReceived => _connection.stream('ReceiveMessage');

//   Future<void> stop() async {
//     await _connection.stop();
//   }
// }
