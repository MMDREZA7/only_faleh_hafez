import 'dart:typed_data';
import 'package:Faleh_Hafez/Service/APIService.dart';
import 'package:Faleh_Hafez/application/chat_theme_changer/chat_theme_changer_bloc.dart';
import 'package:Faleh_Hafez/application/messaging/bloc/messaging_bloc.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/components/user_group_tile.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:Faleh_Hafez/application/chat_items/chat_items_bloc.dart';
import 'package:Faleh_Hafez/domain/models/group_chat_dto.dart';
import 'package:Faleh_Hafez/domain/models/message_dto.dart';
import 'package:Faleh_Hafez/domain/models/user.dart';
import 'package:Faleh_Hafez/domain/models/user_chat_dto.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/chat_page.dart';

class PrivateChatsPage extends StatefulWidget {
  const PrivateChatsPage({
    super.key,
  });

  @override
  _PrivateChatsPageState createState() => _PrivateChatsPageState();
}

class _PrivateChatsPageState extends State<PrivateChatsPage> {
  int currentIndexPage = 0;

  final TextEditingController _receiverMobileNumberController =
      TextEditingController(text: "09");

  final box = Hive.box('mybox');
  var userProfile = User(
    id: 'id',
    displayName: 'userName',
    mobileNumber: 'mobileNumber',
    token: 'token',
    type: UserType.Guest,

    // !!!!!
    profileImage: null,
    // !!!!!
  );
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      userProfile = User(
        id: box.get("userID"),
        displayName: box.get("userName"),
        mobileNumber: box.get("userMobile"),
        token: box.get("userToken"),
        type: userTypeConvertToEnum[box.get('userType')!],
        profileImage: box.get('userImage'),
      );
      context.read<ChatItemsBloc>().add(
            ChatItemsGetPrivateChatsEvent(token: userProfile.token!),
          );
    });
  }

  handleSendMessageToNewUser(ThemeData themeState) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          decoration: BoxDecoration(
            color: themeState.colorScheme.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Message To New User',
                style: TextStyle(fontFamily: 'iranSans', fontSize: 25),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Reciver Phone Number',
                  labelStyle: TextStyle(
                    fontFamily: 'iranSans',
                    color: themeState.colorScheme.onBackground,
                  ),
                ),
                keyboardType: TextInputType.number,
                controller: _receiverMobileNumberController,
                autofocus: true,
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: themeState.colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: () async {
                    if (!_receiverMobileNumberController.text
                        .startsWith("09")) {
                      context.showErrorBar(
                        content: const Text(
                          'شماره موبایل باید با 09 شروع شود',
                        ),
                      );
                      return;
                    }
                    if (_receiverMobileNumberController.text == '') {
                      context.showErrorBar(
                        content: const Text(
                          'فیلد شماره تماس الزامیست لطفا آن را پر کنید',
                        ),
                      );
                      return;
                    }
                    if (_receiverMobileNumberController.text.length < 11 ||
                        _receiverMobileNumberController.text.length > 11) {
                      context.showErrorBar(
                        content: const Text(
                          'شماره موبایل باید 11 رقمی باشد و با 09 شروع شود',
                        ),
                      );
                      return;
                    } else {
                      try {
                        var recieverID = '';
                        recieverID = await APIService().getUserID(
                          token: userProfile.token!,
                          mobileNumber: _receiverMobileNumberController.text,
                        );
                        List<UserChatItemDTO> chats =
                            await APIService().getUserChats(
                          token: userProfile.token!,
                        );
                        var existUser = chats.firstWhere(
                          (element) =>
                              element.participant1ID == recieverID ||
                              element.participant2ID == recieverID,
                          orElse: () => UserChatItemDTO(
                            id: '',
                            participant1ID: '',
                            participant1MobileNumber: '',
                            participant2ID: '',
                            participant2MobileNumber: '',
                            participant1DisplayName: userProfile.displayName!,
                            participant2DisplayName: '',
                            lastMessageTime: '',
                          ),
                        );

                        if (existUser.id == '') {
                          var message = await APIService().sendMessage(
                            token: userProfile.token!,
                            mobileNumber: userProfile.mobileNumber!,
                            receiverID: recieverID,
                            text: 'Chat Started!',
                          );

                          APIService().deleteMessage(
                            token: userProfile.token!,
                            messageID: message['messageID'],
                          );

                          // context.read<ChatItemsBloc>().add(
                          //       ChatItemsGetPrivateChatsEvent(
                          //         token: userProfile.token!,
                          //       ),
                          //     );

                          context.read<ChatItemsBloc>().add(
                                ChatItemsGetPrivateChatsEvent(
                                  token: userProfile.token!,
                                ),
                              );
                        }
                        if (existUser.id != '') {
                          context.showErrorBar(
                            content: const Text(
                              "You have this contact!",
                            ),
                          );
                        }
                      } catch (e) {
                        context.showErrorBar(
                          content: Text(
                            e.toString(),
                          ),
                        );
                      }
                    }

                    Navigator.pop(context);
                    _receiverMobileNumberController.text = '09';
                  },
                  child: Center(
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontFamily: 'iranSans',
                        color: themeState.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      context.read<ChatItemsBloc>().currentChatListPage = "PrivateChatsPage";
    });

    context.read<ChatItemsBloc>().add(
          ChatItemsGetPrivateChatsEvent(token: userProfile.token!),
        );
    return BlocBuilder<ChatThemeChangerBloc, ChatThemeChangerState>(
      builder: (context, themeState) {
        if (themeState is ChatThemeChangerLoaded) {
          return ThemeSwitcher(
            clipper: const ThemeSwitcherCircleClipper(),
            builder: (p0) => Scaffold(
              backgroundColor: themeState.theme.colorScheme.background,
              // drawer: DrawerHomeChat(user: userProfile),
              body: BlocBuilder<ChatItemsBloc, ChatItemsState>(
                builder: (context, state) {
                  if (state is ChatItemsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ChatItemsError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(state.errorMessage),
                          ElevatedButton(
                            onPressed: () => context.read<ChatItemsBloc>().add(
                                  ChatItemsGetPrivateChatsEvent(
                                    token: userProfile.token!,
                                  ),
                                ),
                            child: const Text("Try Again"),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is ChatItemsPrivateChatsLoaded) {
                    print("Hello");
                    return ListView.builder(
                      itemCount: state.userChatItems.length,
                      itemBuilder: (context, index) {
                        Future<Uint8List?> _loadUserImage() async {
                          var imageId =
                              state.userChatItems[index].participant1ID ==
                                      userProfile.id
                                  ? state.userChatItems[index]
                                      .participant2ProfileImage
                                  : state.userChatItems[index]
                                      .participant1ProfileImage;

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

                        var hostDisplayName = userProfile.displayName;
                        var hostMobileNumber = userProfile.mobileNumber;

                        var guestDisplayName = state.userChatItems[index]
                                    .participant2DisplayName ==
                                userProfile.displayName
                            ? state.userChatItems[index].participant1DisplayName
                            : state
                                .userChatItems[index].participant2DisplayName;
                        var guestMobileNumber = state.userChatItems[index]
                                    .participant2MobileNumber ==
                                userProfile.mobileNumber
                            ? state
                                .userChatItems[index].participant1MobileNumber
                            : state
                                .userChatItems[index].participant2MobileNumber;

                        final chatItem = state.userChatItems[index];

                        final isHost =
                            userProfile.id == chatItem.participant1ID;
                        final hostID = isHost
                            ? chatItem.participant2ID
                            : chatItem.participant1ID;
                        final guestID = isHost
                            ? chatItem.participant1ID
                            : chatItem.participant2ID;

                        String date = state.userChatItems[index].lastMessageTime
                            .split(".")[0]
                            .split("T")[0]
                            .replaceAll('-', " / ");
                        String time = state.userChatItems[index].lastMessageTime
                            .split(".")[0]
                            .split("T")[1]
                            .replaceFirst(":00", '');
                        return UsersGroupsTile(
                          userChatItemDTO: chatItem,
                          title: guestDisplayName,
                          subTitle: '',
                          onTap: () {
                            if (chatItem.hasNewMessage == true) {
                              context.read<ChatItemsBloc>().add(
                                    ChatItemsReadMessageEvent(
                                      userChatItem: chatItem,
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
                                        chatID: state.userChatItems[index].id,
                                        token: userProfile.token!,
                                      ),
                                    ),
                                  child: ChatPage(
                                    groupChatItemDTO: GroupChatItemDTO(
                                      id: '',
                                      groupName: '',
                                      lastMessageTime: '',
                                      createdByID: '',
                                      profileImage: '',
                                      myRole: 0,
                                    ),
                                    message: MessageDTO(
                                      attachFile: AttachmentFile(
                                        fileAttachmentID: '',
                                        fileName: '',
                                        fileSize: 0,
                                        fileType: '',
                                      ),
                                      senderID: hostID,
                                      text: '',
                                      chatID: chatItem.id,
                                      groupID: '',
                                      senderMobileNumber:
                                          userProfile.mobileNumber,
                                      // senderMobileNumber:
                                      //     chatItem.participant2MobileNumber,
                                      receiverID: chatItem.participant2ID,
                                      receiverMobileNumber:
                                          chatItem.participant2MobileNumber,
                                      // receiverMobileNumber:
                                      //     chatItem.participant1MobileNumber,
                                      sentDateTime: '',
                                      isRead: true,
                                      messageID: '',
                                    ),
                                    chatID: chatItem.id,
                                    token: userProfile.token!,
                                    hostPublicID: hostID,
                                    guestPublicID: guestID,
                                    isGuest: true,
                                    name: '',
                                    myID: userProfile.id!,
                                    userChatItemDTO: chatItem,
                                  ),
                                ),
                              ),
                            );
                          },
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (state.userChatItems[index].hasNewMessage ==
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
                                    guestDisplayName
                                        .toUpperCase()
                                        .substring(0, 1),
                                    style: TextStyle(
                                      fontFamily: 'iranSans',
                                      color:
                                          themeState.theme.colorScheme.primary,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                );
                              }
                              return imageWidget;
                            },
                          ),
                          themeState: themeState.theme,
                        );
                      },
                    );
                  }
                  return const Center(child: Text("No Chats available"));
                },
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  handleSendMessageToNewUser(themeState.theme);
                },
                backgroundColor: themeState.theme.colorScheme.secondary,
                foregroundColor: themeState.theme.colorScheme.onSecondary,
                child: const Icon(
                  Icons.add,
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
