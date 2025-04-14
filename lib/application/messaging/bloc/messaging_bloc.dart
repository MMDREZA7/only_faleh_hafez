import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:faleh_hafez/Service/APIService.dart';
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

  MessagingBloc() : super(MessagingInitial()) {
    on<MessagingGetMessages>(_fetchMessages);
    on<MessagingSendMessage>(_sendMessage);
    on<MessagingSendFileMessage>(_uploadFile);
    on<MessagingDownloadFileMessage>(_downloadFile);
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

      emit(
        MessagingLoaded(messages: response),
      );
    } catch (e) {
      emit(
        MessagingError(errorMessage: e.toString()),
      );
    }
  }

  FutureOr<void> _sendMessage(
    MessagingSendMessage event,
    Emitter<MessagingState> emit,
  ) async {
    emit(MessagingLoading());

    try {
      String? otherID = null;

      if (event.isNewChat) {
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
            receiverID: otherID!,
            text: event.message.text!,
            fileAttachmentID: event.message.attachFile?.fileAttachmentID,
          )
          .then(
            (value) => add(
              MessagingGetMessages(
                chatID: value["chatID"] ?? value["groupID"]
                //  : value["chatID"]
                ,
                token: event.token,
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
            text: event.message.attachFile != null
                ? event.message.attachFile?.fileName
                : '',
            chatID: event.message.chatID,
            groupID: event.message.groupID,
            senderMobileNumber: event.message.senderMobileNumber,
            receiverID: event.message.receiverID,
            receiverMobileNumber: event.message.receiverMobileNumber,
            sentDateTime: event.message.sentDateTime,
            isRead: event.message.isRead,
            attachFile: AttachmentFile(
              fileAttachmentID: response.id,
              fileName: event.message.attachFile?.fileName ?? 'NotFound Name',
              fileSize: event.message.attachFile?.fileSize ?? 0,
              fileType: event.message.attachFile?.fileType ?? 'NotFound Type',
            ),
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
    emit(MessagingFileLoading());

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

      await OpenFile.open(createdFile!.path);

      emit(MessagingUploadFileLoaded(file: existingFile ?? createdFile));
    } catch (e) {
      emit(
        MessagingError(
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
