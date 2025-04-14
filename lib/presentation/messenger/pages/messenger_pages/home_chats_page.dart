import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:faleh_hafez/application/chat_items/chat_items_bloc.dart';
import 'package:faleh_hafez/domain/models/group_chat_dto.dart';
import 'package:faleh_hafez/domain/models/message_dto.dart';
import 'package:faleh_hafez/domain/models/user.dart';
import 'package:faleh_hafez/domain/models/user_chat_dto.dart';
import 'package:faleh_hafez/presentation/messenger/pages/messenger_pages/chat/chat_page.dart';

class HomeChatsPage extends StatefulWidget {
  const HomeChatsPage({
    super.key,
  });

  @override
  _HomeChatsPageState createState() => _HomeChatsPageState();
}

class _HomeChatsPageState extends State<HomeChatsPage> {
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

    // box.put("userID", '77a16c07-2bba-4706-d059-08dd2cc521d1');
    // box.put("userMobile", '09000000001');
    // box.put(
    //   "userToken",
    //   "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiI3N2ExNmMwNy0yYmJhLTQ3MDYtZDA1OS0wOGRkMmNjNTIxZDEiLCJ1bmlxdWVfbmFtZSI6IjA5MDAwMDAwMDAxIiwibmJmIjoxNzQyMjAzNTc2LCJleHAiOjE3NDIyMTEzNzYsImlhdCI6MTc0MjIwMzU3NiwiaXNzIjoiWW91ckFQSSIsImF1ZCI6IllvdXJBUElVc2VycyJ9.WUmNou6qKBTxMbElVJUBHNsKz2h3TL_1i_AWocwLric",
    // );
    // box.put("userType", 2);

    userProfile = User(
      id: box.get("userID"),
      displayName: box.get("userName"),
      mobileNumber: box.get("userMobile"),
      token: box.get("userToken"),
      type: userTypeConvertToEnum[box.get('userType')]!,

      // !!!!!
      profileImage: null,
      // !!!!!
    );
  }

  handleSendMessageToNewUser() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Message To New User',
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Reciver Phone Number',
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                keyboardType: TextInputType.number,
                controller: _receiverMobileNumberController,
                autofocus: true,
                onEditingComplete: () {
                  if (!_receiverMobileNumberController.text.startsWith("09")) {
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
                  if (_receiverMobileNumberController.text.length < 11) {
                    context.showErrorBar(
                      content: const Text(
                        'شماره موبایل باید 11 رقمی باشد و با 09 شروع شود',
                      ),
                    );
                    return;
                  } else {
                    // TODO: Testing this section to check when go back on chat message
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          groupChatItemDTO: GroupChatItemDTO(
                            id: '',
                            groupName: '',
                            lastMessageTime: '',
                            createdByID: '',
                            prifileImage: '',
                          ),
                          message: MessageDTO(
                            attachFile: AttachmentFile(
                              fileAttachmentID: '',
                              fileName: '',
                              fileSize: 0,
                              fileType: '',
                            ),
                            senderID: userProfile.id,
                            text: '',
                            chatID: '',
                            groupID: '',
                            senderMobileNumber: userProfile.mobileNumber,
                            receiverID: '',
                            receiverMobileNumber: '',
                            sentDateTime: '',
                            isRead: true,
                            messageID: '',
                          ),
                          token: userProfile.token!,
                          chatID: '',
                          hostPublicID: userProfile.id!,
                          guestPublicID: '',
                          name: '',
                          isGuest: true,
                          myID: userProfile.id!,
                          userChatItemDTO: UserChatItemDTO(
                            id: '',
                            participant1ID: userProfile.id!,
                            participant1MobileNumber: userProfile.mobileNumber!,
                            participant1DisplayName:
                                userProfile.displayName ?? "Default UserName",
                            participant2ID: '',
                            participant2MobileNumber:
                                _receiverMobileNumberController.text,
                            participant2DisplayName: '',
                            lastMessageTime: "",
                          ),
                          isNewChat: true,
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: () {
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
                    if (_receiverMobileNumberController.text.length < 11) {
                      context.showErrorBar(
                        content: const Text(
                          'شماره موبایل باید 11 رقمی باشد و با 09 شروع شود',
                        ),
                      );
                      return;
                    } else {
                      // TODO: Testing this section to check when go back on chat message
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            groupChatItemDTO: GroupChatItemDTO(
                              id: '',
                              groupName: '',
                              lastMessageTime: '',
                              createdByID: '',
                              prifileImage: '',
                            ),
                            message: MessageDTO(
                              attachFile: null,
                              senderID: userProfile.id,
                              text: '',
                              chatID: '',
                              groupID: '',
                              senderMobileNumber: userProfile.mobileNumber,
                              receiverID: '',
                              receiverMobileNumber: '',
                              sentDateTime: '',
                              isRead: true,
                              messageID: '',
                            ),
                            token: userProfile.token!,
                            chatID: '',
                            hostPublicID: userProfile.id!,
                            guestPublicID: '',
                            name: '',
                            isGuest: true,
                            myID: userProfile.id!,
                            userChatItemDTO: UserChatItemDTO(
                              id: "",
                              participant1ID: userProfile.id!,
                              participant1MobileNumber:
                                  userProfile.mobileNumber!,
                              participant1DisplayName:
                                  userProfile.displayName ?? "Default UserName",
                              participant2ID: '',
                              participant2MobileNumber:
                                  _receiverMobileNumberController.text,
                              participant2DisplayName: '',
                              lastMessageTime: "",
                            ),
                            isNewChat: true,
                          ),
                        ),
                      );
                    }
                  },
                  // _receiverUserIDController.clear();
                  child: Center(
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
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
    return BlocProvider(
      create: (context) => ChatItemsBloc()
        ..add(
          ChatItemsGetPrivateChatsEvent(
            token: userProfile.token!,
          ),
        ),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
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
              return ListView.builder(
                itemCount: state.userChatItems.length,
                itemBuilder: (context, index) {
                  var hostDisplayName = userProfile.displayName;
                  var hostMobileNumber = userProfile.mobileNumber;

                  var guestDisplayName =
                      state.userChatItems[index].participant2DisplayName ==
                              userProfile.displayName
                          ? state.userChatItems[index].participant1DisplayName
                          : state.userChatItems[index].participant2DisplayName;
                  var guestMobileNumber =
                      state.userChatItems[index].participant2MobileNumber ==
                              userProfile.mobileNumber
                          ? state.userChatItems[index].participant1MobileNumber
                          : state.userChatItems[index].participant2MobileNumber;

                  final chatItem = state.userChatItems[index];
                  final isHost = userProfile.id == chatItem.participant1ID;
                  final hostID = isHost
                      ? chatItem.participant2ID
                      : chatItem.participant1ID;
                  final guestID = isHost
                      ? chatItem.participant1ID
                      : chatItem.participant2ID;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            groupChatItemDTO: GroupChatItemDTO(
                              id: '',
                              groupName: '',
                              lastMessageTime: '',
                              createdByID: '',
                              prifileImage: '',
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
                              senderMobileNumber: userProfile.mobileNumber,
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
                        color: Theme.of(context).primaryColor,
                      ),
                      margin: const EdgeInsets.symmetric(
                        vertical: 7.5,
                        horizontal: 15,
                      ),
                      child: ListTile(
                        title: Text(
                          guestDisplayName ?? guestMobileNumber,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          child: Icon(
                            Icons.person,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
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
            handleSendMessageToNewUser();
          },
          backgroundColor: Theme.of(context).colorScheme.secondary,
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}
