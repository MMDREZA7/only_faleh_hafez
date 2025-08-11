class GroupChatItemDTO {
  final String id;
  final String groupName;
  final String lastMessageTime;
  final String createdByID;
  final String profileImage;
  final int myRole;
  bool? hasNewMessage;

  GroupChatItemDTO({
    required this.id,
    required this.groupName,
    required this.lastMessageTime,
    required this.createdByID,
    required this.profileImage,
    required this.myRole,
    this.hasNewMessage,
  });

  static GroupChatItemDTO empty() => GroupChatItemDTO(
        id: "",
        groupName: "",
        lastMessageTime: "",
        createdByID: "",
        profileImage: "",
        myRole: 0,
        hasNewMessage: false,
      );

  GroupChatItemDTO copyWith({
    String? id,
    String? groupName,
    String? lastMessageTime,
    String? createdByID,
    String? profileImage,
    int? myRole,
    bool? hasNewMessage,
  }) {
    return GroupChatItemDTO(
      id: id ?? this.id,
      groupName: groupName ?? this.groupName,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      createdByID: createdByID ?? this.createdByID,
      profileImage: profileImage ?? this.profileImage,
      myRole: myRole ?? this.myRole,
      hasNewMessage: hasNewMessage ?? this.hasNewMessage,
    );
  }
}
