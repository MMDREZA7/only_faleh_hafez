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
    on<RegisterUser>((event, emit) async {
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
    });

    on<LoginUser>((event, emit) async {
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
    });
  }
}
