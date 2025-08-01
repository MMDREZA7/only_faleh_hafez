import 'dart:async';
import 'package:Faleh_Hafez/application/chat_items/chat_items_bloc.dart';
import 'package:Faleh_Hafez/chat_constants.dart';
import 'package:encrypt/encrypt.dart';
import 'package:Faleh_Hafez/Service/commons.dart';
import 'package:Faleh_Hafez/application/authentiction/authentication_bloc.dart';
import 'package:Faleh_Hafez/application/messaging/bloc/messaging_bloc.dart';
import 'package:Faleh_Hafez/domain/models/message_dto.dart';
import 'package:signalr_core/signalr_core.dart';
import '../../domain/models/user.dart';

User userProfile = User(
  id: box.get('userID'),
  token: box.get('userToken'),
  mobileNumber: box.get("userMobile"),
  displayName: box.get("userName"),
  profileImage: box.get("userImage"),
  type: userTypeConvertToEnum[box.get("userType")],
);

String completeKey = '8fBzT7wqLxLuKKaA0HsRgLuKKaA0HsRg';

class SignalRService {
  MessagingBloc? messagingBloc;
  ChatItemsBloc? chatItemsBloc;

  SignalRService({
    this.messagingBloc,
    this.chatItemsBloc,
  });

  late HubConnection _hubConnection;

  final String _hubUrl = "${ChatConstants.BASE_URL}/MessageHub";
  // final String _hubUrl = "http://192.168.1.107:6060/MessageHub";
  // final String _hubUrl = "http://185.231.115.133:2966/MessageHub";
  final _messageStreamController = StreamController<dynamic>.broadcast();

  Stream<dynamic> get onMessageReceived => _messageStreamController.stream;

  Future<void> initConnection() async {
    try {
      print("Connecting to SignalR..➰");
      _hubConnection = HubConnectionBuilder()
          .withUrl(
            _hubUrl,
            HttpConnectionOptions(
              accessTokenFactory: () async => userProfile.token,
              transport: HttpTransportType.webSockets,
            ),
          )
          .build();

      print("Connected to SignalR... ✔");

      _hubConnection.onclose(
        (error) async {
          // print("Disconnected. Reconnecting...");
          await Future.delayed(const Duration(seconds: 2));
          await initConnection();
        },
      );

      _hubConnection.on('AddNewMessage', (args) {
        // print("📥 AddNewMessage: $args");
        _messageStreamController.add(args?.first);
        print(args?.first["text"]);

        MessageDTO message = MessageDTO.fromJson(args?.first);

        // messagingBloc.allMessagesList.add(message);
        // var mainText = "";
        if (messagingBloc != null) {
          messagingBloc!.add(
            MessagingAddMessageSignalR(
              message: MessageDTO(
                messageID: message.messageID,
                senderID: message.senderID,
                text: message.text,
                chatID: message.chatID,
                groupID: message.groupID,
                senderMobileNumber: message.senderMobileNumber,
                receiverID: message.receiverID,
                receiverMobileNumber: message.receiverMobileNumber,
                sentDateTime: message.sentDateTime,
                senderDisplayName: message.senderDisplayName,
                receiverDisplayName: message.receiverDisplayName,
                isRead: message.isRead,
                replyToMessageID: message.replyToMessageText,
                replyToMessageText: message.replyToMessageText,
                isEdited: message.isEdited,
                forwardedFromDisplayName: message.forwardedFromDisplayName,
                isForwarded: message.isForwarded,
                forwardedFromID: message.forwardedFromID,
                attachFile: message.attachFile?.fileAttachmentID == null
                    ? null
                    : AttachmentFile(
                        fileAttachmentID: message.attachFile?.fileAttachmentID,
                        fileName: message.attachFile?.fileName,
                        fileSize: message.attachFile?.fileSize,
                        fileType: message.attachFile?.fileType,
                      ),
              ),
              token: userProfile.token!,
            ),
          );
        }
        if (chatItemsBloc != null) {
          if (message.senderID == userProfile.id) {
            chatItemsBloc!.add(
              ChatItemsMoveChatToTopEvent(
                userChatID: message.chatID,
                groupChatID: message.groupID,
                isSentByMe: true,
              ),
            );
          } else {
            chatItemsBloc!.add(
              ChatItemsMoveChatToTopEvent(
                userChatID: message.chatID,
                groupChatID: message.groupID,
                isSentByMe: false,
              ),
            );
          }
        }
      });

      _hubConnection.on(
        'EditedMessage',
        (args) {
          // print("📥 EditedMessage: $args");
          _messageStreamController.add(args?.first);

          MessageDTO message = MessageDTO.fromJson(args?.first);

          // messagingBloc.allMessagesList.add(message);
          // var mainText = "";

          // String mainText = '';

          // final key = Key.fromUtf8(completeKey);

          // final encrypter = Encrypter(AES(key));
          print(Commons.iv.base64);

          // mainText = encrypter.decrypt(
          //   Encrypted.fromBase64(message.text!),
          //   iv: Commons.iv,
          // );
          if (messagingBloc != null) {
            messagingBloc!.add(
              MessagingEditMessageSignalR(
                message: MessageDTO(
                  messageID: message.messageID,
                  senderID: message.senderID,
                  text: message.text,
                  // text: mainText,
                  chatID: message.chatID,
                  groupID: message.groupID,
                  senderMobileNumber: message.senderMobileNumber,
                  receiverID: message.receiverID,
                  receiverMobileNumber: message.receiverMobileNumber,
                  sentDateTime: message.sentDateTime,
                  senderDisplayName: message.senderDisplayName,
                  receiverDisplayName: message.receiverDisplayName,
                  isRead: message.isRead,
                  replyToMessageID: message.replyToMessageID,
                  replyToMessageText: message.replyToMessageText,
                  isEdited: message.isEdited,
                  forwardedFromDisplayName: message.forwardedFromDisplayName,
                  isForwarded: message.isForwarded,
                  forwardedFromID: message.forwardedFromID,
                  attachFile: message.attachFile == null
                      ? null
                      : AttachmentFile(
                          fileAttachmentID:
                              message.attachFile?.fileAttachmentID,
                          fileName: message.attachFile?.fileName,
                          fileSize: message.attachFile?.fileSize,
                          fileType: message.attachFile?.fileType,
                        ),
                ),
                token: userProfile.token!,
              ),
            );
          }
        },
      );

      _hubConnection.on(
        'DeletedMessage',
        (args) {
          // print("📥 DeletedMessage: $args");
          _messageStreamController.add(args?.first);

          MessageDTO message = MessageDTO.fromJson(args?.first);

          // messagingBloc.allMessagesList.add(message);
          // var mainText = "";

          // String mainText = '';

          // final key = Key.fromUtf8(completeKey);

          // final encrypter = Encrypter(AES(key));
          print(Commons.iv.base64);

          // mainText = encrypter.decrypt(
          //   Encrypted.fromBase64(message.text!),
          //   iv: Commons.iv,
          // );
          if (messagingBloc != null) {
            messagingBloc!.add(
              MessagingDeleteMessageSignalR(
                message: MessageDTO(
                  messageID: message.messageID,
                  senderID: message.senderID,
                  text: message.text,
                  // text: mainText,
                  chatID: message.chatID,
                  groupID: message.groupID,
                  senderMobileNumber: message.senderMobileNumber,
                  receiverID: message.receiverID,
                  receiverMobileNumber: message.receiverMobileNumber,
                  sentDateTime: message.sentDateTime,
                  senderDisplayName: message.senderDisplayName,
                  receiverDisplayName: message.receiverDisplayName,
                  isRead: message.isRead,
                  replyToMessageID: message.replyToMessageID,
                  replyToMessageText: message.replyToMessageText,
                  isEdited: message.isEdited,
                  forwardedFromDisplayName: message.forwardedFromDisplayName,
                  isForwarded: message.isForwarded,
                  forwardedFromID: message.forwardedFromID,
                  attachFile: message.attachFile == null
                      ? null
                      : AttachmentFile(
                          fileAttachmentID:
                              message.attachFile?.fileAttachmentID,
                          fileName: message.attachFile?.fileName,
                          fileSize: message.attachFile?.fileSize,
                          fileType: message.attachFile?.fileType,
                        ),
                ),
                token: userProfile.token!,
              ),
            );
          }
        },
      );

      _hubConnection.on(
        'ForwardedMessage',
        (args) {
          // print("📥 ForwardedMessage: $args");
          _messageStreamController.add(args?.first);

          MessageDTO message = MessageDTO.fromJson(args?.first);

          // messagingBloc.allMessagesList.add(message);
          // var mainText = "";

          // String mainText = '';

          // final key = Key.fromUtf8(completeKey);

          // final encrypter = Encrypter(AES(key));
          print(Commons.iv.base64);

          // mainText = encrypter.decrypt(
          //   Encrypted.fromBase64(message.text!),
          //   iv: Commons.iv,
          // );
          if (messagingBloc != null) {
            messagingBloc!.add(
              MessagingForwardMessageSignalR(
                message: MessageDTO(
                  messageID: message.messageID,
                  senderID: message.senderID,
                  text: message.text,
                  // text: mainText,
                  chatID: message.chatID,
                  groupID: message.groupID,
                  senderMobileNumber: message.senderMobileNumber,
                  receiverID: message.receiverID,
                  receiverMobileNumber: message.receiverMobileNumber,
                  sentDateTime: message.sentDateTime,
                  senderDisplayName: message.senderDisplayName,
                  receiverDisplayName: message.receiverDisplayName,
                  isRead: message.isRead,
                  replyToMessageID: message.replyToMessageID,
                  replyToMessageText: message.replyToMessageText,
                  isEdited: message.isEdited,
                  forwardedFromDisplayName: message.forwardedFromDisplayName,
                  isForwarded: message.isForwarded,
                  forwardedFromID: message.forwardedFromID,
                  attachFile: message.attachFile == null
                      ? null
                      : AttachmentFile(
                          fileAttachmentID:
                              message.attachFile?.fileAttachmentID,
                          fileName: message.attachFile?.fileName,
                          fileSize: message.attachFile?.fileSize,
                          fileType: message.attachFile?.fileType,
                        ),
                ),
                token: userProfile.token!,
              ),
            );
          }
        },
      );

      await _hubConnection.start();
      // print("✅ SignalR connected.");

      await invokeMessage("InitializeConnection", null);
    } catch (e) {
      // print("SignalR Error: $e");
    }
  }

  Future<void> sendMessage({
    required String receiverID,
    required String text,
    String? fileAttachmentID,
    String? replyToMessageID,
  }) async {
    final key = Key.fromUtf8(completeKey);

    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(text, iv: Commons.iv);
    // ENC

    var messagePayload = {
      "receiverID": receiverID,
      "text": encrypted.base64,
      "fileAttachmentID": fileAttachmentID != '' ? fileAttachmentID : null,
      "replyToMessageID": replyToMessageID,
    };

    // invokeMessage('InitializeConnection', null);
    if (_hubConnection.state == "connected") {
      throw Exception("SignalR connection not initialized");
    }
    try {
      invokeMessage("SendMessage", [messagePayload]);
      // print("SendMessage SignalR Successfully ✔");
      await initConnection();

      // messagingBloc.add(
      //   MessagingAddMessageToEnd(
      //     message: messagePayload as MessageDTO,
      //     token: userProfile.token!,
      //   ),
      // );
      if (messagingBloc != null) {
        messagingBloc!.add(
          MessagingGetMessages(
            chatID: receiverID,
            token: userProfile.token!,
          ),
        );
      }
    } catch (e) {
      // print("SendMessage Error ❌: $e");
    }
  }

  Future<void> invokeMessage(String target, List<Object>? args) async {
    await _hubConnection.invoke(target, args: [userProfile.token, ...?args]);
    print("📤 Message sent via SignalR");
  }

  Future<void> stopConnection() async {
    await _hubConnection.stop();
    await _messageStreamController.close();
    // print("SignalR stopped.");
  }
}
