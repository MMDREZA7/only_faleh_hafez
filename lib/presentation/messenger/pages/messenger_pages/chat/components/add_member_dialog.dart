import 'package:Faleh_Hafez/Service/APIService.dart';
import 'package:Faleh_Hafez/Service/signal_r/SignalR_Service.dart';
import 'package:Faleh_Hafez/application/chat_items/chat_items_bloc.dart';
import 'package:Faleh_Hafez/application/chat_theme_changer/chat_theme_changer_bloc.dart';
import 'package:Faleh_Hafez/application/group_members/group_members_bloc.dart';
import 'package:Faleh_Hafez/domain/models/group_member.dart';
import 'package:Faleh_Hafez/domain/models/user.dart' as user_model;
import 'package:Faleh_Hafez/domain/models/user.dart';
import 'package:Faleh_Hafez/domain/models/user_chat_dto.dart';
import 'package:Faleh_Hafez/domain/models/user_reginster_login_dto.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/components/chatButton.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/models/group_role.dart';
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

  final FocusNode _mobileNumberFocusNode = FocusNode();
  final FocusNode _roleFocusNode = FocusNode();

  List<GroupRole> rolesList = [
    GroupRole(
        name: 'Member', userType: user_model.UserType.Regular, userTypeInt: 1),
    GroupRole(
        name: 'Admin', userType: user_model.UserType.Admin, userTypeInt: 2),
    GroupRole(
        name: 'Guest', userType: user_model.UserType.Guest, userTypeInt: 0),
  ];
  GroupRole? _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = rolesList[0];
  }

  @override
  Widget build(BuildContext context) {
    List<GroupMember> groupMember = [];

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
                              fontFamily: 'iranSans',
                              fontSize: 14,
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
                            fontFamily: 'iranSans',
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
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: _mobileNumberController,
                                autofocus: true,
                                style: TextStyle(
                                  fontFamily: 'iranSans',
                                  color: themeState.theme.colorScheme.onPrimary,
                                ),
                                focusNode: _mobileNumberFocusNode,
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(_roleFocusNode),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  label: Text(
                                    "Enter Mobile Number of New Member",
                                    style: TextStyle(
                                      fontFamily: 'iranSans',
                                      color: themeState
                                          .theme.colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                List<UserChatItemDTO> usersList = [];
                                try {
                                  usersList = await APIService().getUserChats(
                                    token: userProfile.token!,
                                  );
                                  groupMember = await APIService()
                                      .getGroupMembers(
                                          token: userProfile.token!,
                                          groupID: widget.groupID);
                                } catch (e) {
                                  context.showErrorBar(
                                    content: const Text(
                                      "Can't give your user chats",
                                    ),
                                  );

                                  return;
                                }

                                final List<String> groupMemberIDs = groupMember
                                    .map((e) =>
                                        e.id == userProfile.id ? '' : e.id)
                                    .toList();

                                usersList = usersList.where((user) {
                                  return !groupMemberIDs
                                          .contains(user.participant1ID) &&
                                      !groupMemberIDs
                                          .contains(user.participant2ID);
                                }).toList();

                                // ignore: use_build_context_synchronously
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => BottomSheet(
                                    backgroundColor:
                                        themeState.theme.colorScheme.primary,
                                    onClosing: () {},
                                    builder: (context) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 10,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Select some user to get number',
                                              style: TextStyle(
                                                fontFamily: 'iranSans',
                                                fontSize: 18,
                                                color: themeState.theme
                                                    .colorScheme.onBackground,
                                              ),
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                itemCount: usersList.length,
                                                itemBuilder: (context, index) {
                                                  // ignore: unused_local_variable
                                                  User guestUser = User(
                                                    id: usersList[index]
                                                                .participant1ID ==
                                                            userProfile.id
                                                        ? usersList[index]
                                                            .participant2ID
                                                        : usersList[index]
                                                            .participant1ID,
                                                    displayName: usersList[
                                                                    index]
                                                                .participant1ID ==
                                                            userProfile.id
                                                        ? usersList[index]
                                                            .participant2DisplayName
                                                        : usersList[index]
                                                            .participant1DisplayName,
                                                    mobileNumber: usersList[
                                                                    index]
                                                                .participant1ID ==
                                                            userProfile.id
                                                        ? usersList[index]
                                                            .participant2MobileNumber
                                                        : usersList[index]
                                                            .participant1MobileNumber,
                                                    // profileImage: usersList[index]
                                                    //             .participant1ID ==
                                                    //         userProfile.id
                                                    //     ? usersList[index]
                                                    //         .participant2ProfileImage
                                                    //     : usersList[index]
                                                    //         .participant1ProfileImage,
                                                  );

                                                  return Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            _mobileNumberController
                                                                    .text =
                                                                guestUser
                                                                    .mobileNumber!;
                                                          });

                                                          context
                                                              .showSuccessBar(
                                                            content: Text(
                                                              "${guestUser.displayName} Selected! ",
                                                            ),
                                                          );

                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        // child: Container(
                                                        // decoration:
                                                        //     const BoxDecoration(
                                                        //   border: Border
                                                        //       .fromBorderSide(
                                                        //     BorderSide(
                                                        //       width: 1,
                                                        //       strokeAlign:
                                                        //           BorderSide
                                                        //               .strokeAlignCenter,
                                                        //     ),
                                                        //   ),
                                                        // ),
                                                        child: ListTile(
                                                          leading: CircleAvatar(
                                                            backgroundColor:
                                                                themeState
                                                                    .theme
                                                                    .colorScheme
                                                                    .onPrimary,
                                                            child: Icon(
                                                              Icons.person,
                                                              color: themeState
                                                                  .theme
                                                                  .colorScheme
                                                                  .primary,
                                                            ),
                                                          ),
                                                          title: Text(
                                                            guestUser
                                                                .displayName!,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'iranSans',
                                                              color: themeState
                                                                  .theme
                                                                  .colorScheme
                                                                  .onPrimary,
                                                            ),
                                                          ),
                                                          subtitle: Text(
                                                            guestUser
                                                                .mobileNumber!,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'iranSans',
                                                              color: themeState
                                                                  .theme
                                                                  .colorScheme
                                                                  .onPrimary,
                                                            ),
                                                          ),
                                                        ),
                                                        // ),
                                                      ),
                                                      Divider(
                                                        height: 1,
                                                        indent: 45,
                                                        endIndent: 45,
                                                        color: themeState
                                                            .theme
                                                            .colorScheme
                                                            .secondary,
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                            ChatButton(
                                              text: "Cancel",
                                              color: themeState
                                                  .theme.colorScheme.error,
                                              textColor: themeState
                                                  .theme.colorScheme.onError,
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.contacts_outlined,
                                color: themeState.theme.colorScheme.onPrimary,
                              ),
                            ),
                          ],
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
                            fontFamily: 'iranSans',
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
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<GroupRole>(
                            focusColor: themeState.theme.colorScheme.secondary,
                            dropdownColor: themeState.theme.colorScheme.primary,
                            value: _selectedRole,
                            isExpanded: true,
                            hint: Text(
                              'Select Role',
                              style: TextStyle(
                                fontFamily: 'iranSans',
                                color: themeState.theme.colorScheme.onPrimary,
                              ),
                            ),
                            onChanged: (GroupRole? newValue) {
                              setState(() {
                                _selectedRole = newValue;
                                // Here you can access everything:
                                debugPrint('Selected: ${newValue!.name}');
                                debugPrint('userType: ${newValue.userType}');
                                debugPrint(
                                    'userTypeInt: ${newValue.userTypeInt}');
                              });
                            },
                            items: rolesList.map((GroupRole role) {
                              return DropdownMenuItem<GroupRole>(
                                value: role,
                                child: Text(
                                  role.name,
                                  style: TextStyle(
                                    fontFamily: 'iranSans',
                                    color:
                                        themeState.theme.colorScheme.onPrimary,
                                  ),
                                ),
                              );
                            }).toList(),
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
                            child: ChatButton(
                              onTap: () => Navigator.pop(context),
                              color: themeState.theme.colorScheme.error,
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontFamily: 'iranSans',
                                  fontSize: 16,
                                  color: themeState.theme.colorScheme.onError,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: 2,
                            child: ChatButton(
                              onTap: () {
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
                                if (_mobileNumberController.text.length != 11) {
                                  context.showErrorBar(
                                    content: const Text(
                                      'شماره موبایل باید 11 رقمی باشد',
                                    ),
                                  );
                                  return;
                                }
                                if (_selectedRole!.userTypeInt == null) {
                                  context.showErrorBar(
                                    content: const Text(
                                      'فیلد رول الزامی است',
                                    ),
                                  );
                                  return;
                                }
                                if (_selectedRole!.userTypeInt > 2 ||
                                    _selectedRole!.userTypeInt < 0) {
                                  context.showErrorBar(
                                    content: const Text(
                                      ' (از 0 تا 2 انتخاب کنید)برای رول از شماره های راهنما استفاده کنید',
                                    ),
                                  );
                                  // _selectedRole.clear();
                                  return;
                                } else {
                                  try {
                                    context.read<GroupMembersBloc>().add(
                                          GroupMembersAddNewMemberEvent(
                                            groupID: widget.groupID,
                                            mobileNumber:
                                                _mobileNumberController.text,
                                            userRole:
                                                _selectedRole!.userTypeInt,
                                            token: widget.token,
                                          ),
                                        );

                                    _mobileNumberController.clear();
                                    // _selectedRole.clear();

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
                              color: themeState.theme.colorScheme.tertiary,
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                  fontFamily: 'iranSans',
                                  fontSize: 16,
                                  color:
                                      themeState.theme.colorScheme.onTertiary,
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
