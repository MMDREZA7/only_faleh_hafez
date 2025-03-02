class UserRegisterDTO {
  final String? userName;
  final String mobileNumber;
  final String password;

  UserRegisterDTO({
    required this.userName,
    required this.mobileNumber,
    required this.password,
  });
}

class UserLoginDTO {
  final String mobileNumber;
  final String password;

  UserLoginDTO({
    required this.mobileNumber,
    required this.password,
  });
}
