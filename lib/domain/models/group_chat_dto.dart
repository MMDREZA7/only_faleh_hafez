class GroupChatItemDTO {
  final String id;
  final String groupName;
  final String lastMessageTime;
  final String createdByID;
  final String prifileImage;

  GroupChatItemDTO({
    required this.id,
    required this.groupName,
    required this.lastMessageTime,
    required this.createdByID,
    required this.prifileImage,
  });

  static GroupChatItemDTO empty() => GroupChatItemDTO(
        id: "",
        groupName: "",
        lastMessageTime: "",
        createdByID: "",
        prifileImage: "",
      );
}
