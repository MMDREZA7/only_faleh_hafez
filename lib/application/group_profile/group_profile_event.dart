part of 'group_profile_bloc.dart';

@immutable
sealed class GroupProfileEvent {}

class EditGroupProfileEvent extends GroupProfileEvent {
  String token;
  String groupID;
  String groupName;
  String groupImage;

  EditGroupProfileEvent({
    required this.token,
    required this.groupID,
    required this.groupName,
    required this.groupImage,
  });
}
