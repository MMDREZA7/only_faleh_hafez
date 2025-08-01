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

  ChatItemsPrivateChatsLoaded copyWith({
    List<UserChatItemDTO>? userChatItems,
  }) {
    return ChatItemsPrivateChatsLoaded(
      userChatItems: userChatItems ?? this.userChatItems,
    );
  }
}

final class ChatItemsPublicChatsLoaded extends ChatItemsState {
  final List<GroupChatItemDTO> groupChatItem;

  ChatItemsPublicChatsLoaded({
    required this.groupChatItem,
  });

  ChatItemsPublicChatsLoaded copyWith({
    List<GroupChatItemDTO>? groupChatItem,
  }) {
    return ChatItemsPublicChatsLoaded(
      groupChatItem: groupChatItem ?? this.groupChatItem,
    );
  }
}

final class ChatItemsError extends ChatItemsState {
  final String errorMessage;

  ChatItemsError({
    required this.errorMessage,
  });

  ChatItemsError copyWith({
    String? errorMessage,
  }) {
    return ChatItemsError(
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final class ChatItemsGroupMembersLoading extends ChatItemsState {}

final class ChatItemsGroupMembersLoaded extends ChatItemsState {
  final List<GroupMember> groupMembers;

  ChatItemsGroupMembersLoaded({
    required this.groupMembers,
  });

  ChatItemsGroupMembersLoaded copyWith({
    List<GroupMember>? groupMembers,
  }) {
    return ChatItemsGroupMembersLoaded(
      groupMembers: groupMembers ?? this.groupMembers,
    );
  }
}

final class ChatItemsGroupMembersError extends ChatItemsState {
  final String errorMessage;

  ChatItemsGroupMembersError({
    required this.errorMessage,
  });

  ChatItemsGroupMembersError copyWith({
    String? errorMessage,
  }) {
    return ChatItemsGroupMembersError(
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final class ChatItemsEditProfileLoaded extends ChatItemsState {
  final User? user;
  final GroupChatItemDTO? group;

  ChatItemsEditProfileLoaded({
    this.user,
    this.group,
  });

  ChatItemsEditProfileLoaded copyWith({
    User? user,
    GroupChatItemDTO? group,
  }) {
    return ChatItemsEditProfileLoaded(
      user: user ?? this.user,
      group: group ?? this.group,
    );
  }
}

final class ChatItemsEditProfileGroupLoaded extends ChatItemsState {
  final GroupChatItemDTO group;

  ChatItemsEditProfileGroupLoaded({
    required this.group,
  });

  ChatItemsEditProfileGroupLoaded copyWith({
    GroupChatItemDTO? group,
  }) {
    return ChatItemsEditProfileGroupLoaded(
      group: group ?? this.group,
    );
  }
}
