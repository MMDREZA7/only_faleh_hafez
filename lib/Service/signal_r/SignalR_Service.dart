import 'dart:async';
import 'dart:convert';

import 'package:faleh_hafez/application/authentiction/authentication_bloc.dart';
import 'package:faleh_hafez/domain/models/user.dart';
import 'package:signalr_core/signalr_core.dart';

User userProfile = User(
  id: box.get('userID'),
  token: box.get('userToken'),
);
String token = userProfile.token!;

class SignalRService {
  late HubConnection _connection;

  final _hubUrl = "http://192.168.2.11:6060/MessageHub";

  Future<void> initConnection() async {
    try {
      print("HUB : Connecting....");
      _connection = await HubConnectionBuilder()
          .withUrl(
            _hubUrl,
            HttpConnectionOptions(
              accessTokenFactory: () async => userProfile.token,
            ),
          )
          .build();
      print("HUB : Connected ✅");

      print("HUB : Initialing....");
    } catch (e) {
      print("HUB Error : $e");
    }
    _connection.onclose((error) => print("Connection Closed: $error"));
    await _connection.start();

    invokeMessage('InitializeConnection', null);

    print("HUB : Initialed ✅");
    print("✅ SignalR Connected");
  }

  Future<void> sendMessage({
    required String receiverID,
    required String text,
    String? fileAttachmentID,
    String? replyToMessageID,
  }) async {
    final messagePayload = {
      "receiverID": receiverID,
      "text": text,
      "fileAttachmentID": fileAttachmentID,
      "replyToMessageID": replyToMessageID,
    };

    // invokeMessage('InitializeConnection', null);
    if (_connection.state == "connected") {
      throw Exception("SignalR connection not initialized");
    }
    try {
      invokeMessage("SendMessage", [messagePayload]);
      print("SendMessage SignalR Successfully ✔");
    } catch (e) {
      print("SendMessage Error ❌: $e");
    }
  }

  Future<void> invokeMessage(String target, List<Object>? args) async {
    await _connection.invoke(target, args: [token, ...?args]);
    // print("📤 Message sent via SignalR");
  }

  Stream<String> get onMessageReceived {
    final controller = StreamController<String>();

    _connection.on("ReceiveMessage", (args) {
      print("📥 Message received: $args");
      controller.add(args?.first);
    });

    return controller.stream;
  }
}
