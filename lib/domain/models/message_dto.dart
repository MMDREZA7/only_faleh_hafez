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
  final String? dateCreate;
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
    this.dateCreate,
    this.isRead,
    this.attachFile,
    this.replyToMessageID,
    this.replyToMessageText,
    this.isEdited,
    this.isForwarded,
    this.forwardedFromID,
    this.forwardedFromDisplayName,
  });

  MessageDTO copyWith({
    String? messageID,
    String? senderID,
    String? text,
    String? chatID,
    String? groupID,
    String? senderMobileNumber,
    String? senderDisplayName,
    String? receiverID,
    String? receiverMobileNumber,
    String? receiverDisplayName,
    String? sentDateTime,
    String? dateCreate,
    bool? isRead,
    AttachmentFile? attachFile,
    String? replyToMessageID,
    String? replyToMessageText,
    bool? isEdited,
    bool? isForwarded,
    String? forwardedFromID,
    String? forwardedFromDisplayName,
  }) {
    return MessageDTO(
      messageID: messageID ?? this.messageID,
      senderID: senderID ?? this.senderID,
      text: text ?? this.text,
      chatID: chatID ?? this.chatID,
      groupID: groupID ?? this.groupID,
      senderMobileNumber: senderMobileNumber ?? this.senderMobileNumber,
      senderDisplayName: senderDisplayName ?? this.senderDisplayName,
      receiverID: receiverID ?? this.receiverID,
      receiverMobileNumber: receiverMobileNumber ?? this.receiverMobileNumber,
      receiverDisplayName: receiverDisplayName ?? this.receiverDisplayName,
      sentDateTime: sentDateTime ?? this.sentDateTime,
      dateCreate: dateCreate ?? this.dateCreate,
      isRead: isRead ?? this.isRead,
      attachFile: attachFile ?? this.attachFile,
      replyToMessageID: replyToMessageID ?? this.replyToMessageID,
      replyToMessageText: replyToMessageText ?? this.replyToMessageText,
      isEdited: isEdited ?? this.isEdited,
      isForwarded: isForwarded ?? this.isForwarded,
      forwardedFromID: forwardedFromID ?? this.forwardedFromID,
      forwardedFromDisplayName:
          forwardedFromDisplayName ?? this.forwardedFromDisplayName,
    );
  }

  factory MessageDTO.fromJson(Map<String, dynamic> json) {
    return MessageDTO(
      messageID: json['messageID'],
      senderID: json['senderID'],
      text: json['text'],
      chatID: json['chatID'],
      groupID: json['groupID'],
      senderMobileNumber: json['senderMobileNumber'],
      senderDisplayName: json['senderDisplayName'],
      receiverID: json['receiverID'],
      receiverMobileNumber: json['receiverMobileNumber'],
      receiverDisplayName: json['receiverDisplayName'],
      sentDateTime: json['sentDateTime'],
      dateCreate: json['dateCreate'],
      isRead: json['isRead'],
      attachFile: json['fileAttachment'] != null
          ? AttachmentFile.fromJson(json['fileAttachment'])
          : null,
      replyToMessageID: json['replyToMessageID'],
      replyToMessageText: json['replyToMessageText'],
      isEdited: json['isEdited'],
      isForwarded: json['isForwarded'],
      forwardedFromID: json['isForwardedFromID'],
      forwardedFromDisplayName: json['forwardedFromDisplayName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageID': messageID,
      'senderID': senderID,
      'text': text,
      'chatID': chatID,
      'groupID': groupID,
      'senderMobileNumber': senderMobileNumber,
      'senderDisplayName': senderDisplayName,
      'receiverID': receiverID,
      'receiverMobileNumber': receiverMobileNumber,
      'receiverDisplayName': receiverDisplayName,
      'sentDateTime': sentDateTime,
      'dateCreate': dateCreate,
      'isRead': isRead,
      'fileAttachment': attachFile?.toJson(),
      'replyToMessageID': replyToMessageID,
      'replyToMessageText': replyToMessageText,
      'isEdited': isEdited,
      'isForwarded': isForwarded,
      'isForwardedFromID': forwardedFromID,
      'forwardedFromDisplayName': forwardedFromDisplayName,
    };
  }
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

  AttachmentFile copyWith({
    String? fileAttachmentID,
    String? fileName,
    int? fileSize,
    String? fileType,
  }) {
    return AttachmentFile(
      fileAttachmentID: fileAttachmentID ?? this.fileAttachmentID,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      fileType: fileType ?? this.fileType,
    );
  }

  factory AttachmentFile.fromJson(Map<String, dynamic> json) {
    return AttachmentFile(
      fileAttachmentID: json['fileAttachmentID'],
      fileName: json['fileName'],
      fileSize: json['fileSize'],
      fileType: json['fileType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileAttachmentID': fileAttachmentID,
      'fileName': fileName,
      'fileSize': fileSize,
      'fileType': fileType,
    };
  }
}
