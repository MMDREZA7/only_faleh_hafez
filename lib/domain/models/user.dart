class User {
  final String id;
  final String? userName;
  final String mobileNumber;
  final String token;
  final UserType type;

  User({
    required this.id,
    this.userName,
    required this.mobileNumber,
    required this.token,
    required this.type,
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
