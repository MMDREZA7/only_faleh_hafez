import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:Faleh_Hafez/Service/APIService.dart';
import 'package:Faleh_Hafez/domain/models/user.dart';
import 'package:Faleh_Hafez/domain/models/user_reginster_login_dto.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

late final String? errorText;

final box = Hive.box('mybox');

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  // ignore: unused_field
  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<LoginUser>(_loginUser);
    on<RegisterUser>(_RegisterUser);
    on<EditUser>(_editProfile);
  }
  FutureOr<void> _loginUser(
    LoginUser event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());

    try {
      final response = await APIService().loginUser(
        event.user.mobileNumber.toString(),
        event.user.password.toString(),
      );

      // box.put('userID', response.id);
      // box.put('userMobile', response.displayName);
      // box.put('userMobile', response.mobileNumber);
      // box.put('userToken', response.token);
      // box.put('userType', response.type);

      emit(
        AuthenticationLoginSuccess(user: response),
      );
    } catch (e) {
      emit(
        AuthenticationError(errorText: e.toString()),
      );
    }
  }

  FutureOr<void> _RegisterUser(
    RegisterUser event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());

    try {
      await APIService().registerUser(
        event.user.mobileNumber,
        event.user.userName!,
        event.user.password,
      );

      add(
        LoginUser(
          user: UserLoginDTO(
            password: event.user.password,
            mobileNumber: event.user.mobileNumber,
          ),
        ),
      );

      // emit(
      //   AuthenticationRegisterSuccess(responseMessage: "RsgisterSuccse"),
      // );
    } catch (e) {
      emit(
        AuthenticationError(errorText: e.toString()),
      );
    }
  }

  FutureOr<void> _editProfile(
    EditUser event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());

    try {
      User response = await APIService().editUser(
        token: event.token,
        displayName: event.displayName,
        profileImage: event.profileImage,
      );

      emit(
        AuthenticationLoginSuccess(user: response),
      );

      box.delete('userName');
      box.delete('userID');
      box.delete('userMobile');
      box.delete('profileImage');
      box.delete('userType');

      box.put('userName', response.displayName);
      box.put('userID', response.id);
      box.put('userMobile', response.mobileNumber);
      // box.put(response.profileImage ?? '', 'profileImage');
      box.put("userType", userTypeConvertToJson[response.type]);
    } catch (e) {
      emit(
        AuthenticationError(
          errorText: e.toString().contains(':')
              ? e.toString().split(':')[1]
              : e.toString(),
        ),
      );
    }
  }
}
