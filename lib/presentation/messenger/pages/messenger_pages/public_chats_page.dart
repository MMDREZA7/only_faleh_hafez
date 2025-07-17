// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'dart:io';
import 'dart:typed_data';

import 'package:Faleh_Hafez/Service/APIService.dart';
import 'package:Faleh_Hafez/Service/signal_r/SignalR_Service.dart';
import 'package:Faleh_Hafez/application/chat_items/chat_items_bloc.dart';
import 'package:Faleh_Hafez/application/group_profile/group_profile_bloc.dart';
import 'package:Faleh_Hafez/application/messaging/bloc/messaging_bloc.dart';
import 'package:Faleh_Hafez/domain/models/message_dto.dart';
import 'package:Faleh_Hafez/domain/models/user.dart';
import 'package:Faleh_Hafez/domain/models/user_chat_dto.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/chat_page.dart';
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
                  print("hello Loading ______________");
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
                  print("hello Loading ______________");

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

                      final chatItem = state.groupChatItem[index];
                      // ignore: unused_local_variable
                      final isHost = userProfile.id == chatItem.id;
                      final hostID = userProfile.id;
                      final guestID = chatItem.id;

                      return GestureDetector(
                        onTap: () {
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
                                    groupID: chatItem.id,
                                    senderMobileNumber: '',
                                    receiverID: chatItem.id,
                                    receiverMobileNumber: '',
                                    sentDateTime: '',
                                    isRead: true,
                                  ),
                                  chatID: chatItem.id,
                                  token: userProfile.token!,
                                  hostPublicID: hostID!,
                                  guestPublicID: guestID,
                                  isGuest: true,
                                  name: chatItem.groupName,
                                  myID: userProfile.id!,
                                  groupChatItemDTO: chatItem,
                                  userChatItemDTO: UserChatItemDTO(
                                    id: chatItem.id,
                                    participant1ID: userProfile.id!,
                                    participant1DisplayName:
                                        userProfile.displayName!,
                                    participant1MobileNumber: '',
                                    participant2ID: chatItem.id,
                                    participant2MobileNumber: '',
                                    lastMessageTime: '',
                                    participant2DisplayName: '',
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            color: themeState.theme.colorScheme.primary,
                          ),
                          margin: const EdgeInsets.symmetric(
                            vertical: 7.5,
                            horizontal: 15,
                          ),
                          child: ListTile(
                            title: Text(
                              chatItem.groupName,
                              style: TextStyle(
                                color: themeState.theme.colorScheme.onPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            leading: FutureBuilder<Uint8List?>(
                              future: _loadUserImage(),
                              builder: (context, snapshot) {
                                Widget imageWidget;

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  imageWidget =
                                      const CircularProgressIndicator();
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
                                    backgroundColor: themeState
                                        .theme.colorScheme.onSecondary,
                                    radius: 25,
                                    child: Icon(
                                      Icons.group,
                                      color:
                                          themeState.theme.colorScheme.primary,
                                      size: 35,
                                    ),
                                  );
                                }
                                return imageWidget;
                              },
                            ),
                          ),
                        ),
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
                              fontSize: 25,
                              color: themeState.theme.colorScheme.onPrimary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Enter Group Name',
                              labelStyle: TextStyle(
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
