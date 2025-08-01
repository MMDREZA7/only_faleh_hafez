part of 'chat_items_bloc.dart';

@immutable
class ChatItemsEvent {}

class ChatItemsGetPrivateChatsEvent extends ChatItemsEvent {
  final String token;

  ChatItemsGetPrivateChatsEvent({
    required this.token,
  });
}

class ChatItemsGetPublicChatsEvent extends ChatItemsEvent {
  final String token;

  ChatItemsGetPublicChatsEvent({
    required this.token,
  });
}

class ChatItemsAddGroupEvent extends ChatItemsEvent {
  final String token;
  final String groupID;
  final String mobileNumber;
  final int role;

  ChatItemsAddGroupEvent({
    required this.token,
    required this.groupID,
    required this.mobileNumber,
    required this.role,
  });
}

class ChatItemsleaveGroupEvent extends ChatItemsEvent {
  final String token;
  final String groupID;

  ChatItemsleaveGroupEvent({
    required this.token,
    required this.groupID,
  });
}

class ChatItemsGetGroupMembersEvent extends ChatItemsEvent {
  final String token;
  final String groupID;

  ChatItemsGetGroupMembersEvent({
    required this.token,
    required this.groupID,
  });
}

class ChatItemsAddNewMemberToGroupEvent extends ChatItemsEvent {
  final String token;
  final String groupID;
  final String mobileNumber;
  final int role;

  ChatItemsAddNewMemberToGroupEvent({
    required this.token,
    required this.groupID,
    required this.mobileNumber,
    required this.role,
  });
}

class ChatItemsDeletePrivateChatEvent extends ChatItemsEvent {
  final String token;
  final String chatID;

  ChatItemsDeletePrivateChatEvent({
    required this.token,
    required this.chatID,
  });
}

class ChatItemsEditProfileUserEvent extends ChatItemsEvent {
  final String token;
  final String displayName;
  final String? profileImage;

  ChatItemsEditProfileUserEvent({
    required this.token,
    required this.displayName,
    this.profileImage,
  });
}

class ChatItemsEditProfileGroup extends ChatItemsEvent {
  final String token;
  final String groupID;
  final String groupName;
  final String? profileImage;

  ChatItemsEditProfileGroup({
    required this.token,
    required this.groupID,
    required this.groupName,
    this.profileImage,
  });
}

class ChatItemsMoveChatToTopEvent extends ChatItemsEvent {
  final String? userChatID;
  final String? groupChatID;
  bool? isSentByMe = false;

  ChatItemsMoveChatToTopEvent({
    this.userChatID,
    this.groupChatID,
    this.isSentByMe,
  });
}

class ChatItemsReadMessageEvent extends ChatItemsEvent {
  final UserChatItemDTO? userChatItem;
  final GroupChatItemDTO? groupChatItem;

  ChatItemsReadMessageEvent({
    this.userChatItem,
    this.groupChatItem,
  });
}
