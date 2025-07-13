part of 'group_profile_bloc.dart';

@immutable
sealed class GroupProfileState {}

final class GroupProfileInitial extends GroupProfileState {}

final class GroupProfileLoading extends GroupProfileState {}

final class GroupProfileLoaded extends GroupProfileState {
  final List<GroupMember> groupMembers;

  GroupProfileLoaded({
    required this.groupMembers,
  });
}

final class GroupProfileError extends GroupProfileState {
  final String errorMessage;

  GroupProfileError({
    required this.errorMessage,
  });
}
