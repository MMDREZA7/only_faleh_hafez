part of 'group_profile_bloc.dart';

@immutable
class GroupProfileEvent {}

class GroupProfileGetGroupMembersEvent extends GroupProfileEvent {
  final String token;
  final String groupID;

  GroupProfileGetGroupMembersEvent({
    required this.token,
    required this.groupID,
  });
}

class GroupProfileAddNewMemberEvent extends GroupProfileEvent {
  final String token;
  final String groupID;
  final String mobileNumber;
  final int userRole;

  GroupProfileAddNewMemberEvent({
    required this.token,
    required this.groupID,
    required this.mobileNumber,
    required this.userRole,
  });
}

class GroupProfileLeaveGroupEvent extends GroupProfileEvent {
  final String token;
  final String groupID;

  GroupProfileLeaveGroupEvent({
    required this.token,
    required this.groupID,
  });
}

class GroupProfileKickMember extends GroupProfileEvent {
  final String token;
  final String groupID;
  final String userID;

  GroupProfileKickMember({
    required this.token,
    required this.groupID,
    required this.userID,
  });
}
