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
      );
}
