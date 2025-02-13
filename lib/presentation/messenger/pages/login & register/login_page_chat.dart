import 'package:faleh_hafez/application/authentiction/authentication_bloc.dart';
import 'package:faleh_hafez/application/save_get_delete_userPass/secure_storage.dart';
import 'package:faleh_hafez/domain/models/user_reginster_login_dto.dart';
import 'package:faleh_hafez/presentation/messenger/pages/login%20&%20register/register_page_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_auth/local_auth.dart';
import '../../../../application/chat_theme_changer/chat_theme_changer_bloc.dart';
import '../../../../domain/models/user.dart';
import '../messenger_pages/home_page_chats.dart';
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

    // loginMobileNumber
    // loginPassword

    if (box.get('loginMobileNumber') == null) {
      return;
    }

    final storageHasfingerPrint = box.get('fingerprint');

    _hasfingerPrint = storageHasfingerPrint;

    print(
      "_hasfingerPrint ${_hasfingerPrint.runtimeType}",
    );

    if (storageHasfingerPrint == true) {
      _authenticate().then((_) {
        if (_authFingerPrintCount == 1) {
          final user = UserRegisterLoginDTO(
            mobileNumber: box.get("loginMobileNumber"),
            password: box.get('loginPassword'),
          );
          context.read<AuthenticationBloc>().add(LoginUser(user: user));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Finger Print is not correct")),
          );
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Authentication Successful!")),
        );

        setState(
          () {
            _hasfingerPrint = true;
            _authFingerPrintCount = 1;

            box.put('fingerprint', _hasfingerPrint);
          },
        );
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("Authentication Error!")),
      // );
      print("Error during authentication: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ورود به اکانت',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
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
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.only(bottom: 25),
                      child: Center(
                        child: ListTile(
                          leading: Icon(
                            Icons.person,
                            size: 40,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          title: TextFormField(
                            focusNode: _mobileNumberFocusNode,
                            controller: _mobileNumberController,
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            cursorColor: Colors.white,
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(_passwordFocusNode);
                            },
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'شماره تلفن',
                              hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
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
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.only(bottom: 25),
                      child: Center(
                        child: ListTile(
                          leading: Icon(
                            Icons.person,
                            size: 40,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          title: TextFormField(
                            cursorColor: Colors.white,
                            keyboardType: TextInputType.text,
                            focusNode: _passwordFocusNode,
                            controller: _passwordController,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'رمز عبور',
                              hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            onEditingComplete: () {
                              if (_mobileNumberController.text.length != 11) {
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
                                    "فیلدهای موبایل و پسورد الزامی هستند.",
                                  ),
                                );

                                return;
                              }

                              context.read<AuthenticationBloc>().add(
                                    LoginUser(
                                      user: UserRegisterLoginDTO(
                                        password: _passwordController.text,
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
                        color: _hasfingerPrint ? Colors.white : Colors.white12,
                      ),
                    ),

                    const SizedBox(height: 25),
                    BlocConsumer<AuthenticationBloc, AuthenticationState>(
                      listener: (context, state) async {
                        if (state is AuthenticationLoginSuccess) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocBuilder<
                                  ChatThemeChangerBloc, ChatThemeChangerState>(
                                builder: (context, themeChanger) {
                                  if (themeChanger is ChatThemeChangerLoaded) {
                                    return MaterialApp(
                                      theme: themeChanger.theme,
                                      home: const HomePageChats(),
                                    );
                                  }
                                  return MaterialApp(
                                    theme: themeChanger.theme,
                                    home: const HomePageChats(),
                                  );
                                },
                              ),
                            ),
                          );

                          context.showSuccessBar(
                            content: const Text("خوش آمدید"),
                          );
                        }
                        if (state is AuthenticationError) {
                          context.showErrorBar(content: Text(state.errorText));
                        }
                      },
                      builder: (context, state) {
                        if (state is AuthenticationLoading) {
                          return MaterialButton(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 100,
                              vertical: 25,
                            ),
                            color: Theme.of(context).colorScheme.secondary,
                            onPressed: () {},
                            child: const CircularProgressIndicator(),
                          );
                        }
                        return MaterialButton(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 100,
                            vertical: 25,
                          ),
                          color: Theme.of(context).colorScheme.secondary,
                          onPressed: () async {
                            if (_mobileNumberController.text.length != 11) {
                              context.showErrorBar(
                                content: const Text("شماره باید 11 رقم باشد."),
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
                            if (_hasfingerPrint) {
                              box.put("loginMobileNumber",
                                  _mobileNumberController.text);
                              box.put(
                                  'loginPassword', _passwordController.text);
                            }

                            context.read<AuthenticationBloc>().add(
                                  LoginUser(
                                    user: UserRegisterLoginDTO(
                                      password: _passwordController.text,
                                      mobileNumber:
                                          _mobileNumberController.text,
                                    ),
                                  ),
                                );
                          },
                          child: Text(
                            'ورود',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 25),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPageMessenger(),
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
}
