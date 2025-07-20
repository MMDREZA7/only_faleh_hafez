import 'package:Faleh_Hafez/application/chat_items/chat_items_bloc.dart';
import 'package:Faleh_Hafez/application/chat_theme_changer/chat_theme_changer_bloc.dart';
import 'package:Faleh_Hafez/application/group_members/group_members_bloc.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddMemberDialog extends StatefulWidget {
  final String groupID;
  final String groupName;
  final String token;

  AddMemberDialog({
    super.key,
    required this.groupID,
    required this.groupName,
    required this.token,
  });

  @override
  State<AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  final TextEditingController _mobileNumberController =
      TextEditingController(text: "09");
  final TextEditingController _roleController = TextEditingController();

  final FocusNode _mobileNumberFocusNode = FocusNode();
  final FocusNode _roleFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatThemeChangerBloc, ChatThemeChangerState>(
      builder: (context, themeState) {
        if (themeState is ChatThemeChangerLoaded) {
          return SingleChildScrollView(
            child: Builder(builder: (context) {
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
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        margin: const EdgeInsets.only(bottom: 25),
                        decoration: BoxDecoration(
                          color: themeState.theme.colorScheme.background,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            "Add New Member to '${widget.groupName}' Group",
                            style: TextStyle(
                              fontSize: 18,
                              color: themeState.theme.colorScheme.onBackground,
                            ),
                          ),
                        ),
                      ),

                      // MobileNumber TextFeild
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Mobile Number:",
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
                          controller: _mobileNumberController,
                          autofocus: true,
                          focusNode: _mobileNumberFocusNode,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_roleFocusNode),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            label: Text(
                              "Enter Mobile Number of New Member",
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

                      // Role TextFeild
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Role of user:",
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
                          controller: _roleController,
                          focusNode: _roleFocusNode,
                          maxLength: 1,
                          decoration: InputDecoration(
                            hintText: "0:Guest - 1:Regular - 2:Admin",
                            border: InputBorder.none,
                            label: Text(
                              "Enter Role Number",
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
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 3,
                                  color:
                                      themeState.theme.colorScheme.onSecondary,
                                ),
                              ),
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: themeState
                                        .theme.colorScheme.onSecondary,
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
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 3,
                                  color: themeState.theme.colorScheme.onPrimary,
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  if (_mobileNumberController.text.isEmpty) {
                                    context.showErrorBar(
                                      content: const Text(
                                        'لطفا شماره موبایل ممبر جدید را اضافه کنید',
                                      ),
                                    );
                                    return;
                                  } else if (!_mobileNumberController.text
                                      .startsWith("09")) {
                                    context.showErrorBar(
                                      content: const Text(
                                        'شماره موبایل باید با 09 شروع شود',
                                      ),
                                    );
                                    return;
                                  }
                                  if (_mobileNumberController.text.length !=
                                      11) {
                                    context.showErrorBar(
                                      content: const Text(
                                        'شماره موبایل باید 11 رقمی باشد',
                                      ),
                                    );
                                    return;
                                  }
                                  if (_roleController.text == '') {
                                    context.showErrorBar(
                                      content: const Text(
                                        'فیلد رول الزامی است',
                                      ),
                                    );
                                    return;
                                  }
                                  if (int.parse(_roleController.text) > 2 ||
                                      int.parse(_roleController.text) < 0) {
                                    context.showErrorBar(
                                      content: const Text(
                                        ' (از 0 تا 2 انتخاب کنید)برای رول از شماره های راهنما استفاده کنید',
                                      ),
                                    );
                                    _roleController.clear();
                                    return;
                                  } else {
                                    try {
                                      context.read<GroupMembersBloc>().add(
                                            GroupMembersAddNewMemberEvent(
                                              groupID: widget.groupID,
                                              mobileNumber:
                                                  _mobileNumberController.text,
                                              userRole: int.parse(
                                                _roleController.text,
                                              ),
                                              token: widget.token,
                                            ),
                                          );

                                      _mobileNumberController.clear();
                                      _roleController.clear();

                                      context.showSuccessBar(
                                        content: const Text(
                                          'User Successfully added!',
                                        ),
                                      );

                                      Navigator.pop(context);
                                    } catch (e) {
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
                                    color:
                                        themeState.theme.colorScheme.onPrimary,
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
            }),
          );
        }
        return const Center();
      },
    );
  }
}
