import 'package:Faleh_Hafez/Service/APIService.dart';
import 'package:Faleh_Hafez/application/chat_items/chat_items_bloc.dart';
import 'package:Faleh_Hafez/application/chat_theme_changer/chat_theme_changer_bloc.dart';
import 'package:Faleh_Hafez/domain/models/user.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordDialog extends StatefulWidget {
  final User userProfile;

  const ChangePasswordDialog({
    super.key,
    required this.userProfile,
  });

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPasswordConfirmController =
      TextEditingController();

  final FocusNode _newPasswordFocusNode = FocusNode();
  final FocusNode _newPasswordConfirmFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatThemeChangerBloc, ChatThemeChangerState>(
      builder: (context, themeState) {
        if (themeState is ChatThemeChangerLoaded) {
          return Builder(builder: (context) {
            return Dialog(
              backgroundColor: themeState.theme.colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 80,
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: themeState.theme.colorScheme.background,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          "Change Password",
                          style: TextStyle(
                            fontSize: 18,
                            color: themeState.theme.colorScheme.onBackground,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Your new password:",
                        style: TextStyle(
                          fontSize: 15,
                          color: themeState.theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          width: 1,
                          color: themeState.theme.colorScheme.onPrimary,
                        ),
                      ),
                      child: TextField(
                        controller: _newPasswordController,
                        autofocus: true,
                        focusNode: _newPasswordFocusNode,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_newPasswordConfirmFocusNode),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          label: Text(
                            "Enter new password",
                            style: TextStyle(
                              color: themeState.theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Your confirm new password:",
                        style: TextStyle(
                          fontSize: 15,
                          color: themeState.theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          width: 1,
                          color: themeState.theme.colorScheme.onPrimary,
                        ),
                      ),
                      child: TextField(
                        controller: _newPasswordConfirmController,
                        focusNode: _newPasswordConfirmFocusNode,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          label: Text(
                            "Enter your new password again",
                            style: TextStyle(
                              color: themeState.theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                width: 3,
                                color: themeState.theme.colorScheme.onSecondary,
                              ),
                            ),
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 20,
                                  color:
                                      themeState.theme.colorScheme.onSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                width: 3,
                                color: themeState.theme.colorScheme.onPrimary,
                              ),
                            ),
                            child: TextButton(
                              onPressed: () async {
                                if (_newPasswordController.text.isEmpty ||
                                    _newPasswordController == '') {
                                  context.showErrorBar(
                                    content: const Text(
                                      "Enter your new password!",
                                    ),
                                  );
                                  return;
                                }
                                if (_newPasswordConfirmController.text == '' ||
                                    _newPasswordConfirmController
                                        .text.isEmpty) {
                                  context.showErrorBar(
                                    content: const Text(
                                      'Confirm password is required!',
                                    ),
                                  );
                                  return;
                                }
                                if (_newPasswordController.text !=
                                    _newPasswordConfirmController.text) {
                                  context.showErrorBar(
                                    content: const Text(
                                      'Password and Confirm Password do not match!',
                                    ),
                                  );
                                  return;
                                } else {
                                  try {
                                    await APIService().changePassword(
                                      token: widget.userProfile.token!,
                                      newPassword: _newPasswordController.text,
                                      confirmNewPassword:
                                          _newPasswordConfirmController.text,
                                    );

                                    context.showSuccessBar(
                                      content: const Text(
                                        'Password Successfully changed!',
                                      ),
                                    );

                                    _newPasswordController.clear();
                                    _newPasswordConfirmController.clear();

                                    Navigator.pop(context);
                                  } catch (e) {
                                    _newPasswordController.clear();
                                    _newPasswordConfirmController.clear();

                                    context.showErrorBar(
                                      content: Text(
                                        e.toString(),
                                      ),
                                    );
                                  }
                                }
                              },
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: themeState.theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
        }
        return const Center();
      },
    );
  }
}
