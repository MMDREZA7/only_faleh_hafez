import 'package:faleh_hafez/application/chat_items/chat_items_bloc.dart';
import 'package:faleh_hafez/domain/models/group_chat_dto.dart';
import 'package:faleh_hafez/domain/models/massage_dto.dart';
import 'package:faleh_hafez/domain/models/user.dart';
import 'package:faleh_hafez/domain/models/user_chat_dto.dart';
import 'package:faleh_hafez/presentation/messenger/components/drawer_chat.dart';
import 'package:faleh_hafez/presentation/messenger/pages/messenger_pages/chat/chat_page.dart';
import 'package:faleh_hafez/presentation/messenger/pages/messenger_pages/public_chats_page.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePageChats extends StatefulWidget {
  const HomePageChats({
    super.key,
  });

  @override
  _HomePageChatsState createState() => _HomePageChatsState();
}

class _HomePageChatsState extends State<HomePageChats> {
  int currentIndexPage = 0;

  final TextEditingController _receiverMobileNumberController =
      TextEditingController(text: "09");

  final box = Hive.box('mybox');
  var userProfile = User(
    id: 'id',
    userName: 'userName',
    mobileNumber: 'mobileNumber',
    token: 'token',
    type: UserType.Guest,
  );
  @override
  void initState() {
    super.initState();

    // box.put("userID", '77a16c07-2bba-4706-d059-08dd2cc521d1');
    // box.put("userMobile", '09000000001');
    // box.put("userToken",
    //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiI3N2ExNmMwNy0yYmJhLTQ3MDYtZDA1OS0wOGRkMmNjNTIxZDEiLCJ1bmlxdWVfbmFtZSI6IjA5MDAwMDAwMDAxIiwibmJmIjoxNzM2MzI3NDc4LCJleHAiOjE3MzYzMzUyNzgsImlhdCI6MTczNjMyNzQ3OCwiaXNzIjoiWW91ckFQSSIsImF1ZCI6IllvdXJBUElVc2VycyJ9.CteBrJDJg60YiNxGY-JUfBk3uQqptmADEQ24ei92QCo"
    //     // 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiIwMTg5NmQxMC1lYjQ1LTQwMDctZDA1OC0wOGRkMmNjNTIxZDEiLCJ1bmlxdWVfbmFtZSI6IjA5MDAwMDAwMDAwIiwibmJmIjoxNzM2MzI0ODY0LCJleHAiOjE3MzYzMzI2NjQsImlhdCI6MTczNjMyNDg2NCwiaXNzIjoiWW91ckFQSSIsImF1ZCI6IllvdXJBUElVc2VycyJ9._GlnchzZLLlyzyJNMwv2gpfz1ukk4g37cCL_9VbKgoE',
    //     );
    // box.put("userType", '2');

    final String id = box.get('userID');
    final String userName = box.get('userName');
    final String mobileNumber = box.get('userMobile');
    final String token = box.get('userToken');
    final String type = box.get('userType');

    var userType = int.parse(type);

    userProfile = User(
      id: id,
      userName: userName,
      mobileNumber: mobileNumber,
      token: token,
      type: userTypeConvertToEnum[userType]!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatItemsBloc()
        ..add(
          ChatItemsGetPrivateChatsEvent(
            token: userProfile.token,
          ),
        ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            'Messenger',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PublicChatsPage(),
                  ),
                );
              },
              icon: Icon(
                Icons.group_rounded,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            Builder(builder: (context) {
              return IconButton(
                onPressed: () => context.read<ChatItemsBloc>().add(
                      ChatItemsGetPrivateChatsEvent(
                        token: userProfile.token,
                      ),
                    ),
                icon: Icon(
                  Icons.refresh,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              );
            }),
          ],
        ),
        drawer: DrawerHomeChat(user: userProfile),
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
                              token: userProfile.token,
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
                            ),
                            chatID: chatItem.id,
                            token: userProfile.token,
                            hostPublicID: hostID,
                            guestPublicID: guestID,
                            isGuest: true,
                            name: '',
                            myID: userProfile.id,
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
                          isHost
                              ? chatItem.participant2MobileNumber
                              : chatItem.participant1MobileNumber,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
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
            showDialog(
              context: context,
              builder: (context) => Dialog(
                child: Padding(
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
                        decoration: const InputDecoration(
                          labelText: 'Reciver Phone Number',
                        ),
                        keyboardType: TextInputType.number,
                        controller: _receiverMobileNumberController,
                        autofocus: true,
                        onEditingComplete: () {
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
                          if (_receiverMobileNumberController.text.length <
                              11) {
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
                                    senderMobileNumber:
                                        userProfile.mobileNumber,
                                    receiverID: '',
                                    receiverMobileNumber: '',
                                    sentDateTime: '',
                                    isRead: true,
                                  ),
                                  token: userProfile.token,
                                  chatID: '',
                                  hostPublicID: userProfile.id,
                                  guestPublicID: '',
                                  name: '',
                                  isGuest: true,
                                  myID: userProfile.id,
                                  userChatItemDTO: UserChatItemDTO(
                                    id: '',
                                    participant1ID: userProfile.id,
                                    participant1MobileNumber:
                                        userProfile.mobileNumber,
                                    participant2ID: '',
                                    participant2MobileNumber:
                                        _receiverMobileNumberController.text,
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
                      TextButton(
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
                          if (_receiverMobileNumberController.text.length <
                              11) {
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
                                    senderMobileNumber:
                                        userProfile.mobileNumber,
                                    receiverID: '',
                                    receiverMobileNumber: '',
                                    sentDateTime: '',
                                    isRead: true,
                                  ),
                                  token: userProfile.token,
                                  chatID: '',
                                  hostPublicID: userProfile.id,
                                  guestPublicID: '',
                                  name: '',
                                  isGuest: true,
                                  myID: userProfile.id,
                                  userChatItemDTO: UserChatItemDTO(
                                    id: "",
                                    participant1ID: userProfile.id,
                                    participant1MobileNumber:
                                        userProfile.mobileNumber,
                                    participant2ID: '',
                                    participant2MobileNumber:
                                        _receiverMobileNumberController.text,
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
                              color: Theme.of(context).colorScheme.onPrimary,
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
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
