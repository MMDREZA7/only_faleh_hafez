class GroupMember {
  final String id;
  final String mobileNumber;
  final String? displayName;
  final UserType type;

  GroupMember({
    required this.id,
    required this.mobileNumber,
    required this.displayName,
    required this.type,
  });
}

enum UserType {
  Guest,
  Regular,
  Admin,
}

var groupMemberConvertToEnum = {
  0: UserType.Guest,
  1: UserType.Regular,
  2: UserType.Admin,
};

var groupMemberConvertToJson = {
  UserType.Guest: 0,
  UserType.Regular: 1,
  UserType.Admin: 2,
};
