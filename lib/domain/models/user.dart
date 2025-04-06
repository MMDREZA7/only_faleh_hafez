class User {
  final String? id;
  final String? displayName;
  final dynamic profileImage;
  final String? mobileNumber;
  final String? token;
  final UserType? type;

  User({
    required this.id,
    this.displayName,
    this.profileImage,
    this.mobileNumber,
    this.token,
    this.type,
  });
}

enum UserType {
  Guest,
  Regular,
  Admin,
}

var userTypeConvertToEnum = {
  0: UserType.Guest,
  1: UserType.Regular,
  2: UserType.Admin,
};

var userTypeConvertToJson = {
  UserType.Guest: 0,
  UserType.Regular: 1,
  UserType.Admin: 2,
};
