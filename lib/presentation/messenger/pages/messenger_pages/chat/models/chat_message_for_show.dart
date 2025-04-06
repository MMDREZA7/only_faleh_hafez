enum MessageStatus { not_sent, sent, not_view, viewed }

class ChatMessageForShow {
  final int id;
  final String text;
  final MessageStatus? messageStatus;
  final bool? isSender;
  final MessageMode? messageMode;
  final String? replyToMessage;

  ChatMessageForShow({
    required this.id,
    this.text = '',
    this.messageStatus,
    this.isSender,
    this.messageMode,
    this.replyToMessage,
  });
}

enum MessageMode {
  text,
  file,
}
