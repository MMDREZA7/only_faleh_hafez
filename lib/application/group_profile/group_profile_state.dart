part of 'group_profile_bloc.dart';

@immutable
sealed class GroupProfileState {}

final class GroupProfileInitial extends GroupProfileState {}

final class GroupProfileLoading extends GroupProfileState {}

final class GroupProfileLoaded extends GroupProfileState {
  GroupChatItemDTO group;

  GroupProfileLoaded({
    required this.group,
  });
}

final class GroupProfileError extends GroupProfileState {
  String errorMessage;

  GroupProfileError({
    required this.errorMessage,
  });
}
