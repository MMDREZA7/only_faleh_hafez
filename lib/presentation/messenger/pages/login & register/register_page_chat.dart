import 'package:faleh_hafez/application/authentiction/authentication_bloc.dart';
import 'package:faleh_hafez/domain/models/user_reginster_login_dto.dart';
import 'package:faleh_hafez/presentation/messenger/pages/login%20&%20register/login_page_chat.dart';
import 'package:faleh_hafez/presentation/messenger/pages/messenger_pages/router_navbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../application/chat_theme_changer/chat_theme_changer_bloc.dart';
import "package:flash/flash_helper.dart";

class RegisterPageMessenger extends StatefulWidget {
  const RegisterPageMessenger({super.key});

  @override
  State<RegisterPageMessenger> createState() => _RegisterPageMessengerState();
}

class _RegisterPageMessengerState extends State<RegisterPageMessenger> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _mobileNumberController =
      TextEditingController(text: "09");
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode __userNameFocusNode = FocusNode();
  final FocusNode _mobileNumberFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    String? errorText;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'ساخت اکانت جدید',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 35),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // userName feild
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
                            focusNode: __userNameFocusNode,
                            controller: _userNameController,
                            keyboardType: TextInputType.text,
                            autofocus: true,
                            cursorColor: Colors.white,
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(_mobileNumberFocusNode);
                            },
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'نام مستعار',
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
                            keyboardType: TextInputType.text,
                            autofocus: true,
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
                            Icons.password,
                            size: 40,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          title: TextFormField(
                            cursorColor: Colors.white,
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(_confirmPasswordFocusNode);
                            },
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
                          ),
                        ),
                      ),
                    ),

                    // confirm password feild
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
                            Icons.password,
                            size: 40,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          title: TextFormField(
                            cursorColor: Colors.white,
                            showCursor: true,
                            focusNode: _confirmPasswordFocusNode,
                            controller: _confirmPasswordController,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            onEditingComplete: () {
                              if (_mobileNumberController.text.length != 11) {
                                context.showErrorBar(
                                  content: const Text(
                                    'شماره موبایل باید 11 رقمی باشد',
                                  ),
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
                              if (_mobileNumberController.text == "") {
                                context.showErrorBar(
                                  content: const Text(
                                    'فیلد موبایل الزامی است',
                                  ),
                                );
                                return;
                              }
                              if (_passwordController.text == "") {
                                context.showErrorBar(
                                  content: const Text(
                                    'فیلد پسورد الزامی است',
                                  ),
                                );
                                return;
                              }
                              if (_confirmPasswordController.text == "") {
                                context.showErrorBar(
                                  content: const Text(
                                    'فیلد تایید پسورد الزامی است',
                                  ),
                                );
                                return;
                              }
                              if (_confirmPasswordController.text !=
                                  _passwordController.text) {
                                context.showErrorBar(
                                  content: const Text(
                                    'پسورد و تایید پسورد باید مساوی باشند',
                                  ),
                                );
                                return;
                              }
                              if (_confirmPasswordController.text !=
                                  _passwordController.text) {
                                context.showErrorBar(
                                  content: const Text(
                                    'فیلد نام مستعار الزامی است',
                                  ),
                                );
                                return;
                              }
                              context.read<AuthenticationBloc>().add(
                                    RegisterUser(
                                      user: UserRegisterDTO(
                                        userName: _userNameController.text,
                                        password: _passwordController.text,
                                        mobileNumber:
                                            _mobileNumberController.text,
                                      ),
                                    ),
                                  );
                            },
                            decoration: InputDecoration(
                              errorText: errorText,
                              errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              border: InputBorder.none,
                              hintText: 'تایید رمز عبور',
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

                    const SizedBox(height: 15),
                    BlocConsumer<AuthenticationBloc, AuthenticationState>(
                      listener: (context, state) {
                        if (state is AuthenticationLoginSuccess) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocBuilder<
                                  ChatThemeChangerBloc, ChatThemeChangerState>(
                                builder: (context, themeChangerState) {
                                  if (themeChangerState
                                      is ChatThemeChangerLoaded) {
                                    return MaterialApp(
                                      theme: themeChangerState.theme,
                                      home: const RouterNavbarPage(),
                                    );
                                  }
                                  return MaterialApp(
                                    theme: themeChangerState.theme,
                                    home: const RouterNavbarPage(),
                                  );
                                },
                              ),
                            ),
                          );

                          context.showSuccessBar(
                            content: const Text(
                              "با موفقیت ثبت نام شدید",
                            ),
                          );
                        }

                        if (state is AuthenticationRegisterSuccess) {
                          context.showSuccessBar(
                            content: const Text(
                              "با موفقیت ثبت نام شدید",
                            ),
                          );
                        }

                        if (state is AuthenticationError) {
                          context.showErrorBar(
                            content: Text(state.errorText),
                          );
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
                          onPressed: () {
                            if (_userNameController.text == '') {
                              context.showErrorBar(
                                content: const Text(
                                  'نام مستعار الزامیست',
                                ),
                              );
                              return;
                            }
                            if (_mobileNumberController.text.length != 11) {
                              context.showErrorBar(
                                content: const Text(
                                  'شماره موبایل باید 11 رقمی باشد',
                                ),
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
                            if (_mobileNumberController.text == "") {
                              context.showErrorBar(
                                content: const Text(
                                  'فیلد موبایل الزامی است',
                                ),
                              );
                              return;
                            }
                            if (_passwordController.text == "") {
                              context.showErrorBar(
                                content: const Text(
                                  'فیلد پسورد الزامی است',
                                ),
                              );
                              return;
                            }
                            if (_confirmPasswordController.text == "") {
                              context.showErrorBar(
                                content: const Text(
                                  'فیلد تایید پسورد الزامی است',
                                ),
                              );
                              return;
                            }
                            if (_confirmPasswordController.text !=
                                _passwordController.text) {
                              context.showErrorBar(
                                content: const Text(
                                  'پسورد و تایید پسورد باید مساوی باشند',
                                ),
                              );
                              return;
                            }
                            context.read<AuthenticationBloc>().add(
                                  RegisterUser(
                                    user: UserRegisterDTO(
                                      userName: _userNameController.text,
                                      password: _passwordController.text,
                                      mobileNumber:
                                          _mobileNumberController.text,
                                    ),
                                  ),
                                );
                            print(
                              "  userName: ${_userNameController.text} password: ${_passwordController.text} mobileNumber: ${_mobileNumberController.text}",
                            );
                          },
                          child: Text(
                            'ثبت نام',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => AuthenticationBloc(),
                              child: const LoginPageMessenger(),
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "اکانت داشته اید؟ / وارد شوید",
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
