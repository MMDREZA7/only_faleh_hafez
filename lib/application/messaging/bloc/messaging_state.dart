part of 'messaging_bloc.dart';

abstract class MessagingState {
  const MessagingState();
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

  MessagingLoaded copyWith({
    List<MessageDTO?>? messages,
    MessageDTO? replyMessage,
    MessageDTO? editMessage,
  }) {
    return MessagingLoaded(
      messages: messages ?? this.messages,
      replyMessage: replyMessage ?? this.replyMessage,
      editMessage: editMessage ?? this.editMessage,
    );
  }
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

class SignalRInitial extends MessagingState {}

class SignalRConnected extends MessagingState {}

class SignalRMessageReceived extends MessagingState {
  final dynamic message;
  SignalRMessageReceived({
    required this.message,
  });
}
