// ignore_for_file: use_build_context_synchronously

import 'package:Faleh_Hafez/application/authentiction/authentication_bloc.dart';
import 'package:Faleh_Hafez/application/chat_items/chat_items_bloc.dart';
import 'package:Faleh_Hafez/domain/models/user_reginster_login_dto.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/login%20&%20register/register_page_chat.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/router_navbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_auth/local_auth.dart';
import '../../../../application/chat_theme_changer/chat_theme_changer_bloc.dart';
import '../messenger_pages/private_chats_page.dart';
import 'package:flash/flash_helper.dart';

class LoginPageMessenger extends StatefulWidget {
  const LoginPageMessenger({super.key});

  @override
  State<LoginPageMessenger> createState() => _LoginPageMessengerState();
}

class _LoginPageMessengerState extends State<LoginPageMessenger> {
  final TextEditingController _mobileNumberController =
      TextEditingController(text: "09");
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _mobileNumberFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isAuthenticated = false;
  bool _hasfingerPrint = false;
  int _authFingerPrintCount = 0;

  @override
  void initState() {
    super.initState();
    var box = Hive.box('mybox');

    final storageHasfingerPrint = box.get('fingerprint', defaultValue: false);
    _hasfingerPrint = storageHasfingerPrint;

    if (_hasfingerPrint) {
      _authenticate().then((_) {
        if (_isAuthenticated) {
          try {
            final user = UserLoginDTO(
              mobileNumber: box.get("loginMobileNumber"),
              password: box.get('loginPassword'),
            );

            context.read<AuthenticationBloc>().add(LoginUser(user: user));
          } catch (e) {
            context.showErrorBar(content: Text("$e"));
          }
        }
      });
    }
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate using your fingerprint',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      setState(() {
        _isAuthenticated = authenticated;
      });

      if (authenticated) {
        setState(() {
          // _authFingerPrintCount = 1;
          _hasfingerPrint = authenticated;

          box.put('fingerprint', _hasfingerPrint);
        });
      }
    } catch (e) {
      print("Error during authentication: $e");
      // context.showErrorBar(
      //   content: const Text(
      //     "Authentication Error! please check your finger print is set or not or Have you Finger print feature?",
      //     style: TextStyle(
      //       color: Colors.white,
      //       fontSize: 20,
      //       fontWeight: FontWeight.w500,
      //     ),
      //   ),
      // );
    }
    return;
  }

  void authFingerPrintCountToOne() {
    _authFingerPrintCount = 1;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatThemeChangerBloc, ChatThemeChangerState>(
      builder: (context, themeState) {
        if (themeState is ChatThemeChangerLoaded) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            backgroundColor: themeState.theme.colorScheme.background,
            body: Padding(
              padding: const EdgeInsets.all(25),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ورود به اکانت',
                      style: TextStyle(
                        color: themeState.theme.colorScheme.onBackground,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(height: 25),
                    const SizedBox(height: 25),
                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // mobileNumber feild
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: themeState.theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            margin: const EdgeInsets.only(bottom: 25),
                            child: Center(
                              child: ListTile(
                                leading: Icon(
                                  Icons.person,
                                  size: 40,
                                  color: themeState.theme.colorScheme.onPrimary,
                                ),
                                title: TextFormField(
                                  focusNode: _mobileNumberFocusNode,
                                  controller: _mobileNumberController,
                                  autofocus: true,
                                  keyboardType: TextInputType.phone,
                                  cursorColor: Colors.white,
                                  onFieldSubmitted: (value) {
                                    FocusScope.of(context)
                                        .requestFocus(_passwordFocusNode);
                                  },
                                  style: TextStyle(
                                    color:
                                        themeState.theme.colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'شماره تلفن',
                                    hintStyle: TextStyle(
                                      color: themeState
                                          .theme.colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // password feild
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: themeState.theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            margin: const EdgeInsets.only(bottom: 25),
                            child: Center(
                              child: ListTile(
                                leading: Icon(
                                  Icons.person,
                                  size: 40,
                                  color: themeState.theme.colorScheme.onPrimary,
                                ),
                                title: TextFormField(
                                  cursorColor: Colors.white,
                                  keyboardType: TextInputType.text,
                                  focusNode: _passwordFocusNode,
                                  controller: _passwordController,
                                  style: TextStyle(
                                    color:
                                        themeState.theme.colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'رمز عبور',
                                    hintStyle: TextStyle(
                                      color: themeState
                                          .theme.colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                  onEditingComplete: () {
                                    if (_mobileNumberController.text.length !=
                                        11) {
                                      context.showErrorBar(
                                        content: const Text(
                                            "شماره باید 11 رقم باشد."),
                                      );

                                      return;
                                    }
                                    if (!_mobileNumberController.text
                                        .startsWith("09")) {
                                      context.showErrorBar(
                                        content: const Text(
                                          'شماره موبایل باید با 09 شروع شود',
                                        ),
                                      );
                                      return;
                                    }

                                    if (_mobileNumberController.text == "" ||
                                        _passwordController.text == "") {
                                      context.showErrorBar(
                                        content: const Text(
                                          "فیلدهای موبایل و پسورد الزامی هستند.",
                                        ),
                                      );

                                      return;
                                    }
                                    print("Hello");

                                    context.read<AuthenticationBloc>().add(
                                          LoginUser(
                                            user: UserLoginDTO(
                                              password:
                                                  _passwordController.text,
                                              mobileNumber:
                                                  _mobileNumberController.text,
                                            ),
                                          ),
                                        );
                                  },
                                ),
                              ),
                            ),
                          ),

                          IconButton(
                            onPressed: () {
                              _authenticate();
                            },
                            icon: Icon(
                              Icons.fingerprint,
                              size: 100,
                              color: _hasfingerPrint
                                  ? Colors.white
                                  : Colors.white12,
                            ),
                          ),

                          const SizedBox(height: 25),
                          BlocConsumer<AuthenticationBloc, AuthenticationState>(
                            listener: (context, state) async {
                              print(state);
                              if (state is AuthenticationLoginSuccess) {
                                context
                                    .read<ChatThemeChangerBloc>()
                                    .add(FirstTimeOpenChat());

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BlocProvider(
                                      create: (context) =>
                                          ChatThemeChangerBloc()
                                            ..add(FirstTimeOpenChat()),
                                      child: const RouterNavbarPage(),
                                    ),
                                  ),
                                );
                                _mobileNumberController.clear();
                                _passwordController.clear();

                                context.showSuccessBar(
                                  content: const Text("خوش آمدید"),
                                );

                                authFingerPrintCountToOne();
                              }
                              if (state is AuthenticationError) {
                                context.showErrorBar(
                                    content: Text(state.errorText));
                              }
                            },
                            builder: (context, state) {
                              if (state is AuthenticationLoading) {
                                return MaterialButton(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 100,
                                    vertical: 25,
                                  ),
                                  color: themeState.theme.colorScheme.secondary,
                                  onPressed: () {},
                                  child: const CircularProgressIndicator(),
                                );
                              }
                              return MaterialButton(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 100,
                                  vertical: 25,
                                ),
                                color: themeState.theme.colorScheme.secondary,
                                onPressed: () async {
                                  if (_mobileNumberController.text.length !=
                                      11) {
                                    context.showErrorBar(
                                      content:
                                          const Text("شماره باید 11 رقم باشد."),
                                    );

                                    return;
                                  }
                                  if (!_mobileNumberController.text
                                      .startsWith("09")) {
                                    context.showErrorBar(
                                      content: const Text(
                                        'شماره موبایل باید با 09 شروع شود',
                                      ),
                                    );
                                    return;
                                  }

                                  if (_mobileNumberController.text == "" ||
                                      _passwordController.text == "") {
                                    context.showErrorBar(
                                      content: const Text(
                                          "فیلدهای موبایل و پسورد الزامی هستند."),
                                    );

                                    return;
                                  }

                                  if (_hasfingerPrint &&
                                      _mobileNumberController.text.isNotEmpty &&
                                      _passwordController.text.isNotEmpty) {
                                    box.put(
                                      "loginMobileNumber",
                                      _mobileNumberController.text,
                                    );

                                    box.put(
                                      'loginPassword',
                                      _passwordController.text,
                                    );
                                  }

                                  context.read<AuthenticationBloc>().add(
                                        LoginUser(
                                          user: UserLoginDTO(
                                            password: _passwordController.text,
                                            mobileNumber:
                                                _mobileNumberController.text,
                                          ),
                                        ),
                                      );

                                  _mobileNumberController.clear();
                                  _passwordController.clear();
                                },
                                child: Text(
                                  'ورود',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: themeState
                                        .theme.colorScheme.onSecondary,
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 25),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const RegisterPageMessenger(),
                                ),
                              );
                            },
                            child: const Text(
                              "تا به حال اکانت نداشته اید؟ / ثبت نام کنید",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const Center();
      },
    );
  }
}
