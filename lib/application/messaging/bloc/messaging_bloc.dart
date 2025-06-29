import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:faleh_hafez/Service/APIService.dart';
import 'package:faleh_hafez/Service/signal_r/SignalR_Service.dart';
import 'package:faleh_hafez/domain/models/message_dto.dart';
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
  // final SignalRService _signalRService;
  // late MessageDTO replyMessage;
  // late MessageDTO editMessage;

  MessagingBloc() : super(MessagingInitial()) {
    // MessagingBloc(this._signalRService) : super(MessagingInitial()) {
    on<MessagingGetMessages>(_fetchMessages);
    on<MessagingSendMessage>(_sendMessage);
    on<MessagingSendFileMessage>(_uploadFile);
    on<MessagingDownloadFileMessage>(_downloadFile);
    on<MessagingReplyMessageEvent>(_replyMessage);
    on<MessagingEditMessageEvent>(_editingMessage);
    // on<ConnectToSignalR>(_signalRConnectToSignalR);
    on<SendMessage>(_signalRSendMessage);
    on<_InternalMessageReceived>(_signalRInternalMessageReceived);
  }

  FutureOr<void> _fetchMessages(
    MessagingGetMessages event,
    Emitter<MessagingState> emit,
  ) async {
    emit(MessagingLoading());

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
      String? otherID = null;

      if (event.isNewChat && event.message.groupID == null) {
        var convertedID = await APIService().getUserID(
          token: event.token,
          mobileNumber: event.mobileNumber,
        );

        otherID = convertedID;
      } else {
        otherID = event.message.receiverID;
      }

      await APIService().sendMessage(
        token: event.token,
        mobileNumber: event.mobileNumber,
        receiverID: otherID!,
        text: event.message.text!,
        fileAttachmentID: event.message.attachFile?.fileAttachmentID,
        replyToMessageID: event.message.replyToMessageID,
      );

      // final updatedMessages = await APIService().getChatMessages(
      //   chatID: event.message.chatID ?? event.message.groupID!,
      //   token: event.token,
      // );

      // allMessagesList = updatedMessages;

      add(
        MessagingGetMessages(
          chatID: event.message.chatID == ''
              ? event.message.groupID!
              : event.message.chatID!,
          token: event.token,
        ),
      );

      // emit(
      //   MessagingLoaded(messages: allMessagesList),
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
              fileName: file.name ?? 'NotFound Name',
              fileSize: file.size ?? 0,
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
        replyMessage: MessageDTO(
          messageID: event.message.messageID,
          text: event.message.text,
          chatID: event.message.chatID,
          groupID: event.message.groupID,
        ),
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
          editMessage: MessageDTO(
            messageID: event.message.messageID,
            text: event.message.text,
            chatID: event.message.chatID,
            groupID: event.message.groupID,
          ),
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

  // Future<void> _signalRConnectToSignalR(
  //   ConnectToSignalR event,
  //   Emitter<MessagingState> emit,
  // ) async {
  //   await _signalRService.initConnection();

  //   _signalRService.onMessageReceived.listen((message) {
  //     add(_InternalMessageReceived(message: message));
  //   });

  //   emit(SignalRConnected());
  // }

  Future<void> _signalRSendMessage(
    SendMessage event,
    Emitter<MessagingState> emit,
  ) async {}

  Future<void> _signalRInternalMessageReceived(
    _InternalMessageReceived event,
    Emitter<MessagingState> emit,
  ) async {}

  // Future<void> _enterEditMode(
  //   MessagingEnterEditMode event,
  //   Emitter<MessagingState> emit,
  // ) async {
  //   emit(MessagingLoading());

  //   emit(MessagingLoaded(
  //     messages: allMessagesList,
  //     editMessage: event.message,
  //   ));
  // }

  // Future<void> _cancelEditMode(
  //   MessagingCancelEditMode event,
  //   Emitter<MessagingState> emit,
  // ) async {
  //   emit(MessagingLoading());

  //   emit(MessagingLoaded(
  //     messages: allMessagesList,
  //     editMessage: null,
  //   ));
  // }
}
