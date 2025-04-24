class MessageDTO {
  final String messageID;
  final String? senderID;
  String? text;
  final String? chatID;
  final String? groupID;
  final String? senderMobileNumber;
  final String? senderDisplayName;
  final String? receiverID;
  final String? receiverMobileNumber;
  final String? receiverDisplayName;
  final String? sentDateTime;
  final bool? isRead;
  final AttachmentFile? attachFile;
  final String? replyToMessageID;
  final String? replyToMessageText;
  final bool? isEdited;
  final bool? isForwarded;
  final String? forwardedFromID;
  final String? forwardedFromDisplayName;

  MessageDTO({
    required this.messageID,
    this.senderID,
    this.text,
    this.chatID,
    this.groupID,
    this.senderMobileNumber,
    this.senderDisplayName,
    this.receiverID,
    this.receiverMobileNumber,
    this.receiverDisplayName,
    this.sentDateTime,
    this.isRead,
    this.attachFile,
    this.replyToMessageID,
    this.replyToMessageText,
    this.isEdited,
    this.isForwarded,
    this.forwardedFromID,
    this.forwardedFromDisplayName,
  });
}

class AttachmentFile {
  String? fileAttachmentID;
  String? fileName;
  int? fileSize;
  String? fileType;

  AttachmentFile({
    this.fileAttachmentID,
    this.fileName,
    this.fileSize,
    this.fileType,
  });
}
