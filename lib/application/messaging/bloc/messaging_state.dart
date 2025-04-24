part of 'messaging_bloc.dart';

abstract class MessagingState extends Equatable {
  const MessagingState();

  @override
  List<Object> get props => [];
}

class MessagingInitial extends MessagingState {}

class MessagingLoading extends MessagingState {}

class MessagingLoadEmpty extends MessagingState {}

class MessagingLoaded extends MessagingState {
  final List<MessageDTO?> messages;
  final MessageDTO? replyMessage;
  final MessageDTO? editMessage;

  const MessagingLoaded({
    required this.messages,
    this.replyMessage,
    this.editMessage,
  });

  @override
  List<Object> get props => [messages];
}

class MessagingError extends MessagingState {
  final String errorMessage;

  const MessagingError({required this.errorMessage});
}

class MessagingFileLoading extends MessagingState {}

class MessagingUploadFileLoaded extends MessagingState {
  final File file;

  const MessagingUploadFileLoaded({
    required this.file,
  });
}

class MessagingUploadFileLoading extends MessagingState {
  final String fileName;

  const MessagingUploadFileLoading({
    required this.fileName,
  });
}

class MessagingUploadFileError extends MessagingState {
  final String errorMessage;

  const MessagingUploadFileError({required this.errorMessage});
}

// class MessagingEiditingMessageLoaded extends MessagingState {
//   final String messageText;

//   const MessagingEiditingMessageLoaded({
//     required this.messageText,
//   });
// }

// class MessagingEditMessageLoaded extends MessagingState {
//   final MessageDTO message;

//   const MessagingEditMessageLoaded({
//     required this.message,
//   });
// }

// class MessagingLoadFail extends MessagingState {
//   final HttpFail fail;

//   const MessagingLoadFail({
//     required this.fail,
//   });

//   @override
//   List<Object> get props => [fail];
// }

// class MessagingUploadFileCanceled extends MessagingState {
//   const MessagingUploadFileCanceled();

//   @override
//   List<Object> get props => [];
// }

// class MessagingUploadFileFiled extends MessagingState {
//   final HttpFail fail;

//   const MessagingUploadFileFiled({
//     required this.fail,
//   });

//   @override
//   List<Object> get props => [fail];
// }


// class MessagingSendMessageFailed extends MessagingState {
//   final HttpFail fail;

//   const MessagingSendMessageFailed(this.fail);
// }

// class MessagingSendMessageSuccess extends MessagingState {
//   final List<ChatMessage?> messages;

//   const MessagingSendMessageSuccess({
//     required this.messages,
//   });

//   @override
//   List<Object> get props => [messages];
// }

// class MessagingDownloadingFile extends MessagingState {}
