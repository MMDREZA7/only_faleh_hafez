import 'package:faleh_hafez/Service/APIService.dart';
import 'package:faleh_hafez/application/chat_items/chat_items_bloc.dart';
import 'package:faleh_hafez/domain/models/massage_dto.dart';
import 'package:faleh_hafez/domain/models/user.dart';
import 'package:faleh_hafez/domain/models/user_chat_dto.dart';
import 'package:faleh_hafez/presentation/messenger/pages/messenger_pages/chat/chat_page.dart';
import 'package:faleh_hafez/presentation/messenger/pages/messenger_pages/chat/components/group_members_page.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

    final String id = box.get('userID');
    final String? userName = box.get('userName');
    final String mobileNumber = box.get('userMobile');
    final String token = box.get('userToken');
    // final String userImage = box.get('userImge');
    final int type = box.get('userType');

    print("Type: ${type}");
    print("Type Type: ${type.runtimeType}");
    userProfile = User(
      profileImage: '',
      id: id,
      displayName: userName ?? "Default UserName",
      mobileNumber: mobileNumber,
      token: token,
      type: userTypeConvertToEnum[type]!,
    );
    print("UserProfile.Type: ${userProfile.type}");
    print("UserProfile.Type Type: ${userProfile.type.runtimeType}");
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatItemsBloc()
        ..add(
          ChatItemsGetPublicChatsEvent(
            token: userProfile.token!,
          ),
        ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            'Public Chats',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          actions: [
            Builder(builder: (context) {
              return IconButton(
                onPressed: () => context.read<ChatItemsBloc>().add(
                      ChatItemsGetPublicChatsEvent(
                        token: userProfile.token!,
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
              return ListView.builder(
                itemCount: state.groupChatItem.length,
                itemBuilder: (context, index) {
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
                          builder: (context) => ChatPage(
                            icon: Icons.settings,
                            onPressedGroupButton: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GroupMemberspage(
                                    userProfile: userProfile,
                                    groupID: state.groupChatItem[index].id,
                                    token: userProfile.token!,
                                    adminID:
                                        state.groupChatItem[index].createdByID,
                                    groupName:
                                        state.groupChatItem[index].groupName,
                                  ),
                                ),
                              );
                            },
                            isNewChat: false,
                            message: MessageDTO(
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
                              participant1DisplayName: userProfile.displayName,
                              participant1MobileNumber: '',
                              participant2ID: chatItem.id,
                              participant2MobileNumber: '',
                              lastMessageTime: '',
                              participant2DisplayName: '',
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
                        color: Theme.of(context).primaryColor,
                      ),
                      margin: const EdgeInsets.symmetric(
                        vertical: 7.5,
                        horizontal: 15,
                      ),
                      child: ListTile(
                        title: Text(
                          chatItem.groupName,
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
            _groupNameController.clear();

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
                          labelText: 'Enter Group Name',
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

                            Navigator.pop(context);

                            // ignore: use_build_context_synchronously
                            context.showSuccessBar(
                              content: const Text(
                                'برای مشاهده گروه های اضافه شده، صفحه را ریفرش کنید',
                              ),
                            );
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
                            // TODO: Testing this section to check when go back on chat message
                            await APIService().createGroup(
                              groupName: _groupNameController.text,
                              token: userProfile.token!,
                            );
                            Navigator.pop(context);
                          }
                        },
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
