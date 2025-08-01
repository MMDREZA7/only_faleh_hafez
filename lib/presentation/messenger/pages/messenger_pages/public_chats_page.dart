// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:Faleh_Hafez/Service/APIService.dart';
import 'package:Faleh_Hafez/Service/signal_r/SignalR_Service.dart';
import 'package:Faleh_Hafez/application/chat_items/chat_items_bloc.dart';
import 'package:Faleh_Hafez/application/group_members/group_members_bloc.dart';
import 'package:Faleh_Hafez/application/messaging/bloc/messaging_bloc.dart';
import 'package:Faleh_Hafez/domain/models/message_dto.dart';
import 'package:Faleh_Hafez/domain/models/user.dart';
import 'package:Faleh_Hafez/domain/models/user_chat_dto.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/chat_page.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/components/user_group_tile.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../application/chat_theme_changer/chat_theme_changer_bloc.dart';

class PublicChatsPage extends StatefulWidget {
  const PublicChatsPage({
    super.key,
  });

  @override
  _PublicChatsPageState createState() => _PublicChatsPageState();
}

class _PublicChatsPageState extends State<PublicChatsPage> {
  final TextEditingController _groupNameController = TextEditingController();
  final box = Hive.box('mybox');
  var userProfile = User(
    id: 'id',
    displayName: 'userName',
    mobileNumber: 'mobileNumber',
    token: 'token',
    type: UserType.Guest,
  );

  @override
  void initState() {
    super.initState();

    // final UserType type = userTypeConvertToEnum[box.get('userType')]!;

    userProfile = User(
      id: box.get('userID'),
      displayName: box.get('userName'),
      mobileNumber: box.get('userMobile'),
      profileImage: box.get('userImage'),
      token: box.get('userToken'),
      type: userTypeConvertToEnum[box.get('userType')],
    );

    // Future.microtask(() {
    //   context.read<ChatItemsBloc>().add(
    //         ChatItemsGetPublicChatsEvent(token: userProfile.token!),
    //       );
    // });
    // context.read<ChatItemsBloc>().add(
    //       ChatItemsGetPublicChatsEvent(
    //         token: userProfile.token!,
    //       ),
    //     );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatThemeChangerBloc, ChatThemeChangerState>(
      builder: (context, themeState) {
        if (themeState is ChatThemeChangerLoaded) {
          return Scaffold(
            backgroundColor: themeState.theme.colorScheme.background,
            body: BlocBuilder<ChatItemsBloc, ChatItemsState>(
              builder: (context, state) {
                if (state is ChatItemsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is ChatItemsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.errorMessage),
                        ElevatedButton(
                          onPressed: () => context.read<ChatItemsBloc>().add(
                                ChatItemsGetPublicChatsEvent(
                                  token: userProfile.token!,
                                ),
                              ),
                          child: const Text("Try Again"),
                        ),
                      ],
                    ),
                  );
                }
                if (state is ChatItemsPublicChatsLoaded) {
                  for (int i = 0; i < state.groupChatItem.length; i++) {
                    print(state.groupChatItem[i].groupName);
                  }

                  print(state.groupChatItem);

                  return ListView.builder(
                    itemCount: state.groupChatItem.length,
                    itemBuilder: (context, index) {
                      Future<Uint8List?> _loadUserImage() async {
                        final imageId = state.groupChatItem[index].profileImage;

                        if (imageId != null && imageId != '') {
                          try {
                            List<int> imageData =
                                await APIService().downloadFile(
                              token: userProfile.token!,
                              id: imageId,
                            );
                            return Uint8List.fromList(imageData);
                          } catch (e) {
                            debugPrint("Error loading profile image: $e");
                          }
                        }
                        return null;
                      }

                      final groupItem = state.groupChatItem[index];
                      // ignore: unused_local_variable
                      final isHost = userProfile.id == groupItem.id;
                      final hostID = userProfile.id;
                      final guestID = groupItem.id;

                      String date = state.groupChatItem[index].lastMessageTime
                          .split(".")[0]
                          .split("T")[0]
                          .replaceAll('-', " / ");
                      String time = state.groupChatItem[index].lastMessageTime
                          .split(".")[0]
                          .split("T")[1];

                      return UsersGroupsTile(
                        groupChatItemDTO: groupItem,
                        title: groupItem.groupName,
                        subTitle: '',
                        themeState: themeState.theme,
                        leading: FutureBuilder<Uint8List?>(
                          future: _loadUserImage(),
                          builder: (context, snapshot) {
                            Widget imageWidget;

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              imageWidget = const CircularProgressIndicator();
                            } else if (snapshot.hasData &&
                                snapshot.data != null) {
                              imageWidget = CircleAvatar(
                                radius: 25,
                                backgroundImage: MemoryImage(
                                  snapshot.data!,
                                ),
                              );
                            } else {
                              imageWidget = CircleAvatar(
                                backgroundColor:
                                    themeState.theme.colorScheme.onSecondary,
                                radius: 23,
                                child: Text(
                                  groupItem.groupName
                                      .toUpperCase()
                                      .substring(0, 1),
                                  style: TextStyle(
                                    fontFamily: 'iranSans',
                                    color: themeState.theme.colorScheme.primary,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              );
                            }
                            return imageWidget;
                          },
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (state.groupChatItem[index].hasNewMessage ==
                                true)
                              CircleAvatar(
                                backgroundColor:
                                    themeState.theme.colorScheme.onPrimary,
                                radius: 13,
                                child: Icon(
                                  Icons.message_rounded,
                                  color: themeState.theme.colorScheme.primary,
                                  size: 14,
                                ),
                              ),
                            // CircleAvatar(
                            //   backgroundColor:
                            //       themeState.theme.colorScheme.onPrimary,
                            //   radius: 10,
                            //   child: Text(
                            //     Random().nextInt(10).toString(),
                            //     style: TextStyle(
                            //       fontFamily: 'iranSans',
                            //       color: themeState.theme.colorScheme.primary,
                            //       fontSize: 13,
                            //     ),
                            //   ),
                            // ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              time,
                              style: TextStyle(
                                fontFamily: 'iranSans',
                                fontSize: 9,
                                fontWeight: FontWeight.w300,
                                color:
                                    themeState.theme.colorScheme.onBackground,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          if (groupItem.hasNewMessage == true) {
                            context.read<ChatItemsBloc>().add(
                                  ChatItemsReadMessageEvent(
                                    groupChatItem: groupItem,
                                  ),
                                );
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                // create: (context) => MessagingBloc(SignalRService())
                                // ..add(ConnectToSignalR())
                                create: (context) => MessagingBloc()
                                  ..add(
                                    MessagingGetMessages(
                                      chatID: state.groupChatItem[index].id,
                                      token: userProfile.token!,
                                    ),
                                  ),

                                child: ChatPage(
                                  icon: Icons.group,
                                  // onPressedGroupButton: () {
                                  //   Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) => GroupMemberspage(
                                  //         userProfile: userProfile,
                                  //         groupID:
                                  //             state.groupChatItem[index].id,
                                  //         token: userProfile.token!,
                                  //         adminID: state
                                  //             .groupChatItem[index].createdByID,
                                  //         groupName: state
                                  //             .groupChatItem[index].groupName,
                                  //       ),
                                  //     ),
                                  //   );
                                  // },
                                  isNewChat: false,
                                  message: MessageDTO(
                                    messageID: '',
                                    attachFile: null,
                                    senderID: hostID,
                                    text: '',
                                    chatID: '',
                                    groupID: groupItem.id,
                                    senderMobileNumber: '',
                                    receiverID: groupItem.id,
                                    receiverMobileNumber: '',
                                    sentDateTime: '',
                                    isRead: true,
                                  ),
                                  chatID: groupItem.id,
                                  token: userProfile.token!,
                                  hostPublicID: hostID!,
                                  guestPublicID: guestID,
                                  isGuest: true,
                                  name: groupItem.groupName,
                                  myID: userProfile.id!,
                                  groupChatItemDTO: groupItem,
                                  userChatItemDTO: UserChatItemDTO(
                                    id: groupItem.id,
                                    participant1ID: userProfile.id!,
                                    participant1DisplayName:
                                        userProfile.displayName!,
                                    participant1MobileNumber: '',
                                    participant2ID: groupItem.id,
                                    participant2MobileNumber: '',
                                    lastMessageTime: '',
                                    participant2DisplayName: '',
                                    hasNewMessage: false,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
                return const Center(child: Text("No Chats available"));
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _groupNameController.clear();

                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    backgroundColor: themeState.theme.colorScheme.primary,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create New Group',
                            style: TextStyle(
                              fontFamily: 'iranSans',
                              fontSize: 25,
                              color: themeState.theme.colorScheme.onPrimary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Enter Group Name',
                              labelStyle: TextStyle(
                                fontFamily: 'iranSans',
                                color: themeState.theme.colorScheme.onSecondary,
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            controller: _groupNameController,
                            onEditingComplete: () async {
                              if (_groupNameController.text == '') {
                                context.showErrorBar(
                                  content: const Text(
                                    'لطفا برای گروه خود نام انتخاب کنید',
                                  ),
                                );
                                return;
                              } else {
                                await APIService().createGroup(
                                  groupName: _groupNameController.text,
                                  token: userProfile.token!,
                                );

                                context.read<ChatItemsBloc>().add(
                                      ChatItemsGetPublicChatsEvent(
                                        token: userProfile.token!,
                                      ),
                                    );

                                Navigator.pop(context);

                                // context.showSuccessBar(
                                //   content: const Text(
                                //     'برای مشاهده گروه های اضافه شده، صفحه را ریفرش کنید',
                                //   ),
                                // );
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () async {
                              if (_groupNameController.text == '') {
                                context.showErrorBar(
                                  content: const Text(
                                    'نام گروه را وارد کنید',
                                  ),
                                );
                                return;
                              } else {
                                if (_groupNameController.text == null &&
                                    _groupNameController.text.isEmpty) {
                                  context.showErrorBar(
                                    content: Text(
                                      "Please enter a valid group name!",
                                    ),
                                  );
                                }
                                if (_groupNameController.text.length > 20) {
                                  context.showErrorBar(
                                    content: Text(
                                      "Please enter a group name less of 20 word",
                                    ),
                                  );
                                }
                                await APIService().createGroup(
                                  groupName: _groupNameController.text,
                                  token: userProfile.token!,
                                );
                                await APIService().getGroupsChat(
                                  token: userProfile.token!,
                                );

                                context.showSuccessBar(
                                  content: Text(
                                    "Group Added With Name: ${_groupNameController.text}",
                                  ),
                                );

                                Navigator.pop(context);
                              }
                            },
                            child: Center(
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                  fontFamily: 'iranSans',
                                  color: themeState.theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              backgroundColor: themeState.theme.colorScheme.secondary,
              foregroundColor: themeState.theme.colorScheme.onSecondary,
              child: const Icon(Icons.add),
            ),
          );
        }

        return const Center();
      },
    );
  }
}
