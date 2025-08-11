import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:encrypt/encrypt.dart';
import 'package:Faleh_Hafez/Service/APIService.dart';
import 'package:Faleh_Hafez/Service/commons.dart';
import 'package:Faleh_Hafez/Service/signal_r/SignalR_Service.dart';
import 'package:Faleh_Hafez/domain/models/message_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';

import '../../../domain/file_handler/file_handler.dart';
part 'messaging_event.dart';
part 'messaging_state.dart';

class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {
  late List<MessageDTO?> allMessagesList = [];
  final fileHandler = FileHandler();
  var isEdit = false;
  String? currentChatID;
  // final SignalRService _signalRService;

  // late MessageDTO replyMessage;
  // late MessageDTO editMessage;

  // MessagingBloc() : super(MessagingInitial()) {
  MessagingBloc() : super(MessagingInitial()) {
    on<MessagingGetMessages>(_fetchMessages);
    on<MessagingSendMessage>(_sendMessage);
    on<MessagingSendFileMessage>(_uploadFile);
    on<MessagingDownloadFileMessage>(_downloadFile);
    on<MessagingReplyMessageEvent>(_replyMessage);
    on<MessagingEditMessageEvent>(_editingMessage);
    on<MessagingAddMessageSignalR>(_addMessageSignalR);
    on<MessagingEditMessageSignalR>(_editMessageSignalR);
    on<MessagingDeleteMessageSignalR>(_deleteMessageSignalR);
    on<MessagingForwardMessageSignalR>(_forwardMessageSignalR);
    // on<SendMessage>(_signalRSendMessage);
    // on<_InternalMessageReceived>(_signalRInternalMessageReceived);
    // on<ConnectToSignalR>(_signalRConnectToSignalR);
  }

  FutureOr<void> _fetchMessages(
    MessagingGetMessages event,
    Emitter<MessagingState> emit,
  ) async {
    // emit(MessagingLoading());

    try {
      final response = await APIService().getChatMessages(
        chatID: event.chatID,
        token: event.token,
      );

      allMessagesList = response;

      emit(
        MessagingLoaded(
          messages: allMessagesList,
        ),
      );
      print("EmitedMessagingLoaded");
    } catch (e) {
      print("EmitedMessagingError");

      emit(
        MessagingError(errorMessage: e.toString()),
      );
    }
  }

  FutureOr<void> _sendMessage(
    MessagingSendMessage event,
    Emitter<MessagingState> emit,
  ) async {
    // emit(MessagingLoading());

    try {
      String? otherID;
      var message;

      if (event.isNewChat && event.message.groupID == null) {
        var convertedID = await APIService().getUserID(
          token: event.token,
          mobileNumber: event.mobileNumber,
        );

        otherID = convertedID;
      } else {
        otherID = event.message.receiverID;
      }

      await APIService()
          .sendMessage(
            token: event.token,
            mobileNumber: event.message.receiverMobileNumber!,
            receiverID: otherID!,
            text: event.message.text!,
            fileAttachmentID:
                event.message.attachFile?.fileAttachmentID == "" &&
                        event.message.attachFile?.fileAttachmentID == null
                    ? null
                    : event.message.attachFile?.fileAttachmentID,
            replyToMessageID: event.message.replyToMessageID,
          )
          .then(
            (value) => {
              message = MessageDTO(
                messageID: value["messageID"],
                senderID: value["senderID"],
                text: value["text"],
                chatID: value["chatID"],
                groupID: value["groupID"],
                senderMobileNumber: value["senderMobileNumber"],
                senderDisplayName: value["senderDisplayName"],
                receiverID: value["receiverID"],
                receiverMobileNumber: value["receiverMobileNumber"],
                receiverDisplayName: value["receiverDisplayName"],
                sentDateTime: value["sentDateTime"],
                dateCreate: value["dateCreate"],
                isRead: value["isRead"],
                replyToMessageID: value["replyToMessageID"],
                replyToMessageText: value["replyToMessageID"],
                isEdited: value["isEdited"],
                isForwarded: value["isForwarded"],
                forwardedFromID: value["isForwardedFromID"],
                forwardedFromDisplayName: value["forwardedFromDisplayName"],
                attachFile: value["fileAttachmentID"] != null
                    ? AttachmentFile(
                        fileAttachmentID: value["fileAttachment"]
                            ?['fileAttachmentID'],
                        fileName: value["fileAttachment"]?['fileName'],
                        fileSize: value["fileAttachment"]?['fileSize'],
                        fileType: value["fileAttachment"]?['fileType'],
                      )
                    : null,
              ),
            },
          );

      // add(
      //   MessagingAddMessageSignalR(
      //     // chatID: event.message.chatID == ''
      //     //     ? event.message.groupID!
      //     //     : event.message.chatID!,
      //     message: message,
      //     token: event.token,
      //   ),
      // );
    } catch (e) {
      emit(
        MessagingError(
          errorMessage: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _uploadFile(
    MessagingSendFileMessage event,
    Emitter<MessagingState> emit,
  ) async {
    try {
      if (event.message.attachFile?.fileType == 'aac') {
        print("File is VoiceFile");
      }
      final result = await FilePicker.platform.pickFiles();

      if (result == null) return;

      var file = result.files.first;

      final response = await APIService().uploadFile(
        filePath: file.path!,
        description: 'Default Description',
        token: event.token,
        name: file.name,
      )
          //     .then(
          //   (value) async {
          //     await APIService().downladFile(
          //       token: event.token,
          //       id: value.id!,
          //     );
          //   },
          // )
          ;

      add(
        MessagingSendMessage(
          message: MessageDTO(
            messageID: event.message.messageID,
            senderID: event.message.senderID,
            text: file.name,
            chatID: event.message.chatID,
            groupID: event.message.groupID,
            senderMobileNumber: event.message.senderMobileNumber,
            receiverID: event.message.receiverID,
            receiverMobileNumber: event.message.receiverMobileNumber,
            sentDateTime: event.message.sentDateTime,
            isRead: event.message.isRead,
            attachFile: AttachmentFile(
              fileAttachmentID: response.id,
              fileName: file.name,
              fileSize: file.size,
              fileType: file.extension ?? 'NotFound Type',
            ),
            receiverDisplayName: event.message.receiverDisplayName,
            senderDisplayName: event.message.senderDisplayName,
            forwardedFromID: event.message.forwardedFromID,
            forwardedFromDisplayName: event.message.forwardedFromDisplayName,
            isEdited: event.message.isEdited,
            isForwarded: event.message.isForwarded,
            replyToMessageID: event.message.replyToMessageID,
            replyToMessageText: event.message.replyToMessageText,
          ),
          chatID: event.message.chatID ?? event.message.groupID!,
          isNewChat: event.isNewChat,
          token: event.token,
          mobileNumber: event.message.senderMobileNumber!,
        ),
      );
    } catch (e) {
      if (event.message.chatID != '') {
        add(
          MessagingGetMessages(
            chatID: event.message.chatID!,
            token: event.token,
          ),
        );
      } else {
        add(
          MessagingGetMessages(
            chatID: event.message.groupID!,
            token: event.token,
          ),
        );
      }

      emit(
        MessagingError(
          errorMessage: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _downloadFile(
    MessagingDownloadFileMessage event,
    Emitter<MessagingState> emit,
  ) async {
    // emit(MessagingFileLoading());

    try {
      File? existingFile = await fileHandler.getFile(
        fileID: event.fileID,
        fileType: event.fileType,
      );

      if (existingFile != null) {
        await OpenFile.open(existingFile.path);
      }

      final response = await APIService().downloadFile(
        id: event.fileID,
        token: event.token,
      );

      File? createdFile = await fileHandler.attachFileCaching(
        data: response,
        fileID: event.fileID,
        fileName: event.fileName,
        fileSize: event.fileSize,
        fileType: event.fileType,
      );

      // emit(MessagingUploadFileLoaded(file: existingFile ?? createdFile!));

      await OpenFile.open(createdFile!.path);
    } catch (e) {
      emit(
        MessagingError(
          errorMessage: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _replyMessage(
    MessagingReplyMessageEvent event,
    Emitter<MessagingState> emit,
  ) async {
    emit(MessagingLoading());

    emit(
      MessagingLoaded(
        messages: allMessagesList,
        replyMessage: event.message,
      ),
    );
  }

  Future<void> _editingMessage(
    MessagingEditMessageEvent event,
    Emitter<MessagingState> emit,
  ) async {
    try {
      emit(MessagingLoading());

      emit(
        MessagingLoaded(
          messages: allMessagesList,
          editMessage: event.message,
        ),
      );
    } catch (e) {
      emit(
        MessagingError(
          errorMessage: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _addMessageSignalR(
    MessagingAddMessageSignalR event,
    Emitter<MessagingState> emit,
  ) async {
    try {
      // var mainText = "";

      String mainText = '';
      String mainReplyText = '';

      try {
        final key = Key.fromUtf8(completeKey);

        final encrypter = Encrypter(AES(key));
        // print(Commons.iv.base64);

        mainText = encrypter.decrypt(
          Encrypted.fromBase64(event.message.text!),
          iv: Commons.iv,
        );

        if (event.message.replyToMessageID != null &&
            event.message.replyToMessageID != '' &&
            event.message.replyToMessageText != null &&
            event.message.replyToMessageText != '') {
          mainReplyText = encrypter.decrypt(
              Encrypted.fromBase64(event.message.replyToMessageText!),
              iv: Commons.iv);
        }
      } catch (ex) {
        print("ECEPTION");
        print(ex);
        print(event.message.text!);
        // mainText = event.message.text!;
      }
      // var chatID = event.message.receiverID == userProfile.id
      //     ? event.message.senderID
      //     : event.message.receiverID;

      if (event.message.chatID == currentChatID ||
          event.message.groupID == currentChatID) {
        allMessagesList.add(
          MessageDTO(
            messageID: event.message.messageID,
            senderID: event.message.senderID,
            text: mainText,
            chatID: event.message.chatID,
            groupID: event.message.groupID,
            senderMobileNumber: event.message.senderMobileNumber,
            receiverID: event.message.receiverID,
            receiverMobileNumber: event.message.receiverMobileNumber,
            sentDateTime: event.message.sentDateTime,
            senderDisplayName: event.message.senderDisplayName,
            receiverDisplayName: event.message.receiverDisplayName,
            isRead: event.message.isRead,
            replyToMessageID: event.message.replyToMessageID,
            replyToMessageText: mainReplyText,
            isEdited: event.message.isEdited,
            forwardedFromDisplayName: event.message.forwardedFromDisplayName,
            isForwarded: event.message.isForwarded,
            forwardedFromID: event.message.forwardedFromID,
            attachFile: event.message.attachFile?.fileAttachmentID == null
                ? null
                : AttachmentFile(
                    fileAttachmentID:
                        event.message.attachFile?.fileAttachmentID,
                    fileName: event.message.attachFile?.fileName,
                    fileSize: event.message.attachFile?.fileSize,
                    fileType: event.message.attachFile?.fileType,
                  ),
          ),
        );
      }
      emit(
        MessagingLoaded(messages: allMessagesList),
      );
    } catch (e) {
      print("Can't add new message");

      emit(
        MessagingError(errorMessage: e.toString()),
      );
    }
  }

  FutureOr<void> _editMessageSignalR(
    MessagingEditMessageSignalR event,
    Emitter<MessagingState> emit,
  ) async {
    try {
      final index = allMessagesList.indexWhere(
        (element) => element?.messageID == event.message.messageID,
      );

      if (index != -1) {
        allMessagesList[index] = event.message;

        emit(
          MessagingLoaded(messages: List.from(allMessagesList)),
        );
      } else {
        print("Edited message not found in the list");
      }
    } catch (e) {
      print("Can't edit message: $e");
      emit(
        MessagingError(errorMessage: e.toString()),
      );
    }
  }

  FutureOr<void> _deleteMessageSignalR(
    MessagingDeleteMessageSignalR event,
    Emitter<MessagingState> emit,
  ) async {
    try {
      final index = allMessagesList.indexWhere(
        (element) => element?.messageID == event.message.messageID,
      );

      if (index != -1) {
        // allMessagesList[index] = event.message;
        allMessagesList.removeAt(index);

        emit(
          MessagingLoaded(messages: List.from(allMessagesList)),
        );
      } else {
        print("Edited message not found in the list");
      }
    } catch (e) {
      print("Can't edit message: $e");
      emit(
        MessagingError(errorMessage: e.toString()),
      );
    }
  }

  FutureOr<void> _forwardMessageSignalR(
    MessagingForwardMessageSignalR event,
    Emitter<MessagingState> emit,
  ) async {
    try {
      final index = allMessagesList.indexWhere(
        (element) => element?.messageID == event.message.messageID,
      );

      if (index != -1) {
        allMessagesList[index] = event.message;
        // allMessagesList.removeAt(index);

        emit(
          MessagingLoaded(messages: List.from(allMessagesList)),
        );
      } else {
        print("Edited message not found in the list");
      }
    } catch (e) {
      print("Can't edit message: $e");
      emit(
        MessagingError(errorMessage: e.toString()),
      );
    }
  }
}
