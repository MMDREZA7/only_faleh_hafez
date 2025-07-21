class GroupChatItemDTO {
  final String id;
  final String groupName;
  final String lastMessageTime;
  final String createdByID;
  final String profileImage;
  final int myRole;

  GroupChatItemDTO({
    required this.id,
    required this.groupName,
    required this.lastMessageTime,
    required this.createdByID,
    required this.profileImage,
    required this.myRole,
  });

  static GroupChatItemDTO empty() => GroupChatItemDTO(
        id: "",
        groupName: "",
        lastMessageTime: "",
        createdByID: "",
        profileImage: "",
        myRole: 0,
      );
}
