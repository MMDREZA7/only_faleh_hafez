part of 'messaging_bloc.dart';

abstract class MessagingEvent extends Equatable {
  const MessagingEvent();

  @override
  List<Object> get props => [];
}

class MessagingGetMessages extends MessagingEvent {
  final String chatID;
  final String token;

  const MessagingGetMessages({
    required this.chatID,
    required this.token,
  });
}

class MessagingSendMessage extends MessagingEvent {
  final MessageDTO message;
  final String? chatID;
  final bool isNewChat;
  final String token;
  final String mobileNumber;

  const MessagingSendMessage({
    required this.message,
    required this.chatID,
    required this.isNewChat,
    required this.token,
    required this.mobileNumber,
  });

  @override
  List<Object> get props => [
        message,
      ];
}

class MessagingSendFileMessage extends MessagingEvent {
  final MessageDTO message;
  final bool isNewChat;
  final String token;

  const MessagingSendFileMessage({
    required this.message,
    required this.token,
    required this.isNewChat,
  });

  @override
  List<Object> get props => [
        message,
      ];
}

class MessagingDownloadFileMessage extends MessagingEvent {
  final String fileID;
  final String fileName;
  final int fileSize;
  final String fileType;
  final String token;

  const MessagingDownloadFileMessage({
    required this.fileID,
    required this.fileName,
    required this.fileSize,
    required this.fileType,
    required this.token,
  });

  @override
  List<Object> get props => [
        fileID,
        token,
      ];
}

class MessagingReplyMessageEvent extends MessagingEvent {
  final MessageDTO message;
  // final String token;

  const MessagingReplyMessageEvent({
    required this.message,
    // required this.token,
  });
}

class MessagingEditMessageEvent extends MessagingEvent {
  final MessageDTO message;
  final String token;

  const MessagingEditMessageEvent({
    required this.message,
    required this.token,
  });
}

class MessagingEnterEditMode extends MessagingEvent {
  final MessageDTO message;

  MessagingEnterEditMode({
    required this.message,
  });
}

class MessagingCancelEditMode extends MessagingEvent {}

// class MessagingSeenMessage extends MessagingEvent {
//   final MessageDTO message;

//   const MessagingSeenMessage({
//     required this.message,
//   });

//   @override
//   List<Object> get props => [message];
// }

// class MessagingDeleteMessage extends MessagingEvent {
//   final int messageID;

//   const MessagingDeleteMessage({
//     required this.messageID,
//   });

//   @override
//   List<Object> get props => [messageID];
// }

// class MessagingDownloadFile extends MessagingEvent {
//   final FileInfo fileInfo;

//   MessagingDownloadFile({
//     required this.fileInfo,
//   });

//   @override
//   List<Object> get props => [
//         fileInfo,
//       ];
// }
