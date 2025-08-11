part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationEvent {}

class RegisterUser extends AuthenticationEvent {
  final UserRegisterDTO user;

  RegisterUser({
    required this.user,
  });
}

class LoginUser extends AuthenticationEvent {
  final UserLoginDTO user;

  LoginUser({
    required this.user,
  });
}

class EditUser extends AuthenticationEvent {
  final String token;
  final String displayName;
  final String profileImage;

  EditUser({
    required this.token,
    required this.displayName,
    required this.profileImage,
  });
}
