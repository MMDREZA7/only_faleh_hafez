class UserChatItemDTO {
  final String id;
  final String participant1ID;
  final String participant1MobileNumber;
  final String participant1DisplayName;
  final String? participant1ProfileImage;
  final String participant2ID;
  final String participant2MobileNumber;
  final String participant2DisplayName;
  final String? participant2ProfileImage;
  final String lastMessageTime;
  bool? hasNewMessage;

  UserChatItemDTO({
    required this.id,
    required this.participant1ID,
    required this.participant1MobileNumber,
    required this.participant1DisplayName,
    this.participant1ProfileImage,
    required this.participant2ID,
    required this.participant2MobileNumber,
    required this.participant2DisplayName,
    this.participant2ProfileImage,
    required this.lastMessageTime,
    this.hasNewMessage,
  });

  static UserChatItemDTO empty() => UserChatItemDTO(
        id: "",
        participant1ID: "",
        participant1MobileNumber: "",
        participant1DisplayName: "",
        participant2ID: "",
        participant2MobileNumber: "",
        participant2DisplayName: "",
        lastMessageTime: "",
        hasNewMessage: false,
      );

  UserChatItemDTO copyWith({
    String? id,
    String? participant1ID,
    String? participant1MobileNumber,
    String? participant1DisplayName,
    String? participant1ProfileImage,
    String? participant2ID,
    String? participant2MobileNumber,
    String? participant2DisplayName,
    String? participant2ProfileImage,
    String? lastMessageTime,
    bool? hasNewMessage,
  }) {
    return UserChatItemDTO(
      id: id ?? this.id,
      participant1ID: participant1ID ?? this.participant1ID,
      participant1MobileNumber:
          participant1MobileNumber ?? this.participant1MobileNumber,
      participant1DisplayName:
          participant1DisplayName ?? this.participant1DisplayName,
      participant1ProfileImage:
          participant1ProfileImage ?? this.participant1ProfileImage,
      participant2ID: participant2ID ?? this.participant2ID,
      participant2MobileNumber:
          participant2MobileNumber ?? this.participant2MobileNumber,
      participant2DisplayName:
          participant2DisplayName ?? this.participant2DisplayName,
      participant2ProfileImage:
          participant2ProfileImage ?? this.participant2ProfileImage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      hasNewMessage: hasNewMessage ?? this.hasNewMessage,
    );
  }
}
