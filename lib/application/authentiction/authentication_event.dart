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
