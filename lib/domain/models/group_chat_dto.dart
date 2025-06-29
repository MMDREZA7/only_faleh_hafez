class GroupChatItemDTO {
  final String id;
  final String groupName;
  final String lastMessageTime;
  final String createdByID;
  final String profileImage;

  GroupChatItemDTO({
    required this.id,
    required this.groupName,
    required this.lastMessageTime,
    required this.createdByID,
    required this.profileImage,
  });

  static GroupChatItemDTO empty() => GroupChatItemDTO(
        id: "",
        groupName: "",
        lastMessageTime: "",
        createdByID: "",
        profileImage: "",
      );
}
