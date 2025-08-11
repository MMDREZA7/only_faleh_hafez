part of 'group_members_bloc.dart';

@immutable
class GroupMembersEvent {}

class GroupMembersGetGroupMembersEvent extends GroupMembersEvent {
  final String token;
  final String groupID;

  GroupMembersGetGroupMembersEvent({
    required this.token,
    required this.groupID,
  });
}

class GroupMembersEditProfilesEvent extends GroupMembersEvent {
  final String token;
  final String groupID;
  final String groupName;
  final String groupImage;

  GroupMembersEditProfilesEvent({
    required this.token,
    required this.groupID,
    required this.groupName,
    required this.groupImage,
  });
}

class GroupMembersAddNewMemberEvent extends GroupMembersEvent {
  final String token;
  final String groupID;
  final String mobileNumber;
  final int userRole;

  GroupMembersAddNewMemberEvent({
    required this.token,
    required this.groupID,
    required this.mobileNumber,
    required this.userRole,
  });
}

class GroupMembersLeaveGroupEvent extends GroupMembersEvent {
  final String token;
  final String groupID;

  GroupMembersLeaveGroupEvent({
    required this.token,
    required this.groupID,
  });
}

class GroupMembersKickMember extends GroupMembersEvent {
  final String token;
  final String groupID;
  final String userID;

  GroupMembersKickMember({
    required this.token,
    required this.groupID,
    required this.userID,
  });
}
