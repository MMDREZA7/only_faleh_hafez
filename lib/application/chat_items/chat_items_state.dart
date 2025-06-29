part of 'chat_items_bloc.dart';

@immutable
sealed class ChatItemsState {}

final class ChatItemsInitial extends ChatItemsState {}

final class ChatItemsLoading extends ChatItemsState {}

final class ChatItemsEmpty extends ChatItemsState {}

final class ChatItemsPrivateChatsLoaded extends ChatItemsState {
  final List<UserChatItemDTO> userChatItems;

  ChatItemsPrivateChatsLoaded({
    required this.userChatItems,
  });
}

final class ChatItemsPublicChatsLoaded extends ChatItemsState {
  final List<GroupChatItemDTO> groupChatItem;

  ChatItemsPublicChatsLoaded({
    required this.groupChatItem,
  });
}

final class ChatItemsError extends ChatItemsState {
  final String errorMessage;

  ChatItemsError({
    required this.errorMessage,
  });
}

final class ChatItemsGroupMembersLoading extends ChatItemsState {}

final class ChatItemsGroupMembersLoaded extends ChatItemsState {
  final List<GroupMember> groupMembers;

  ChatItemsGroupMembersLoaded({
    required this.groupMembers,
  });
}

final class ChatItemsGroupMembersError extends ChatItemsState {
  final String errorMessage;

  ChatItemsGroupMembersError({
    required this.errorMessage,
  });
}

final class ChatItemsEditProfileLoaded extends ChatItemsState {
  final User? user;
  final GroupChatItemDTO? group;

  ChatItemsEditProfileLoaded({
    this.user,
    this.group,
  });
}

final class ChatItemsEditProfileGroupLoaded extends ChatItemsState {
  final GroupChatItemDTO group;

  ChatItemsEditProfileGroupLoaded({
    required this.group,
  });
}
