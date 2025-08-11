part of 'group_members_bloc.dart';

@immutable
sealed class GroupMembersState {
  final List<GroupMember> groupMembers;

  GroupMembersState({
    required this.groupMembers,
  });
}

final class GroupMembersInitial extends GroupMembersState {
  GroupMembersInitial({required super.groupMembers});
}

final class GroupMembersLoading extends GroupMembersState {
  GroupMembersLoading({required super.groupMembers});
}

final class GroupMembersLoaded extends GroupMembersState {
  GroupMembersLoaded({required super.groupMembers});
}

final class GroupMembersError extends GroupMembersState {
  final String errorMessage;

  GroupMembersError({
    required this.errorMessage,
    required super.groupMembers,
  });
}
