import 'package:faleh_hafez/application/chat_theme_changer/chat_theme_changer_bloc.dart';
import 'package:faleh_hafez/domain/models/group_chat_dto.dart';
import 'package:faleh_hafez/domain/models/message_dto.dart';
import 'package:faleh_hafez/domain/models/user.dart';
import 'package:faleh_hafez/domain/models/user_chat_dto.dart';
import 'package:faleh_hafez/presentation/messenger/group_profile/group_profile_page.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../../application/messaging/bloc/messaging_bloc.dart';
import 'components/ChatPageMessagesView.dart';

class ChatPage extends StatefulWidget {
  final void Function()? onPressedGroupButton;
  final IconData? icon;
  final String hostPublicID, guestPublicID, name;
  final bool isGuest;
  final String chatID;
  final String token;
  final String myID;
  final UserChatItemDTO userChatItemDTO;
  final GroupChatItemDTO groupChatItemDTO;
  final bool isNewChat;
  final MessageDTO message;
  final void Function()? onClickAppBar;

  const ChatPage({
    super.key,
    required this.hostPublicID,
    required this.guestPublicID,
    required this.name,
    required this.isGuest,
    required this.chatID,
    required this.token,
    required this.myID,
    required this.userChatItemDTO,
    required this.groupChatItemDTO,
    required this.message,
    this.onPressedGroupButton,
    this.icon,
    this.isNewChat = false,
    this.onClickAppBar,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final box = Hive.box('mybox');
  var userProfile = User(
    id: 'id',
    displayName: 'userName',
    mobileNumber: 'mobileNumber',
    token: 'token',
    type: UserType.Guest,
  );

  // late final Future<List<MessageDTO>> messages;

  @override
  void initState() {
    super.initState();

    MessagingBloc().add(
      MessagingGetMessages(
        chatID: widget.message.chatID!,
        token: widget.token,
      ),
    );

    final String id = box.get('userID');
    final String? userName = box.get('userName');
    final String mobileNumber = box.get('userMobile');
    final String token = box.get('userToken');
    // ignore: unused_local_variable
    final int type = box.get('userType');

    // var typeInt = int.tryParse(type);

    userProfile = User(
      id: id,
      displayName: userName ?? "Default UserName",
      mobileNumber: mobileNumber,
      token: token,
      type: userTypeConvertToEnum[type]!,
      // type: typeInt[userTypeConvertToEnum],
      // type: typeInt[userTypeConvertToEnum],
    );

    // messages = APIService().getChatMessages(
    //   chatID: widget.chatID,
    //   token: token,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        if (widget.isNewChat) {
          return MessagingBloc();
          // return MessagingBloc();
        } else {
          return MessagingBloc()
            ..add(
              MessagingGetMessages(
                chatID: widget.chatID,
                token: widget.token,
              ),
            );
          // return MessagingBloc()
          //   ..add(
          //     MessagingGetMessages(
          //       chatID: widget.chatID,
          //       token: widget.token,
          //     ),
          //   );
        }
      },
      child: Scaffold(
        appBar: buildAppBar(context),
        body: BlocProvider(
          create: (context) => ChatThemeChangerBloc()..add(FirstTimeOpenChat()),
          // ChatThemeChangerBloc()..add(FirstTimeOpenChat()),
          child: BlocBuilder<MessagingBloc, MessagingState>(
            builder: (context, state) {
              if (state is MessagingFileLoading) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const ListTile(
                    leading: CircularProgressIndicator(),
                    title: Text("File Uploading"),
                  ),
                );
              }

              if (state is MessagingLoaded) {
                final correctedMessage = MessageDTO(
                  messageID: '',
                  senderID: widget.message.senderID == userProfile.id
                      ? widget.message.senderID
                      : widget.message.receiverID,
                  text: widget.message.text,
                  chatID: widget.message.chatID,
                  groupID: widget.message.groupID,
                  senderMobileNumber: widget.message.senderMobileNumber,
                  receiverID: widget.message.receiverID == userProfile.id
                      ? widget.message.senderID
                      : widget.message.receiverID,
                  receiverMobileNumber: widget.message.receiverMobileNumber,
                  sentDateTime: widget.message.sentDateTime,
                  isRead: widget.message.isRead,
                  attachFile: widget.message.attachFile,
                  replyToMessageText: widget.message.replyToMessageText ?? '',
                );

                return ChatPageMessagesListView(
                  message: correctedMessage,
                  hostPublicID: widget.hostPublicID,
                  guestPublicID: widget.guestPublicID,
                  isGuest: widget.isGuest,
                  myID: widget.myID,
                  isNewChat: widget.isNewChat,
                  userChatItemDTO: widget.userChatItemDTO,
                  token: widget.token,
                  groupChatItemDTO: widget.groupChatItemDTO,
                );
              }

              if (state is MessagingError) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.showErrorBar(
                    content: Text(state.errorMessage),
                  );
                });

                return const Center();
              }

              return const Center();
            },
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    var hostDisplayName = userProfile.displayName;
    var hostMobileNumber = userProfile.mobileNumber;

    var guestDisplayName = widget.userChatItemDTO.participant2DisplayName ==
            userProfile.displayName
        ? widget.userChatItemDTO.participant1DisplayName
        : widget.userChatItemDTO.participant2DisplayName;
    var guestMobileNumber = widget.userChatItemDTO.participant2MobileNumber ==
            userProfile.mobileNumber
        ? widget.userChatItemDTO.participant1MobileNumber
        : widget.userChatItemDTO.participant2MobileNumber;

    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          CupertinoIcons.back,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      title: Row(
        children: [
          const CircleAvatar(
            child: Icon(Icons.person),
          ),
          const SizedBox(width: 10),
          Visibility(
            visible: widget.groupChatItemDTO.id != null ? true : false,
            child: TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                minimumSize: MaterialStateProperty.all(Size.zero),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                shape: MaterialStateProperty.all(
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupProfilePage(
                      group: widget.groupChatItemDTO,
                    ),
                  ),
                );
              },
              child: Text(
                widget.name,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.groupChatItemDTO.id == null ? true : false,
            child: Text(
              widget.name,
              style: TextStyle(
                  fontSize: 16, color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
          BlocBuilder<MessagingBloc, MessagingState>(
            builder: (context, state) {
              if (state is MessagingLoading) {
                return const Text(
                  'Loading...',
                  style: TextStyle(fontSize: 12),
                );
              } else if (state is MessagingLoaded) {
                return Text(
                  guestDisplayName ?? guestMobileNumber,
                  // widget.userChatItemDTO.participant1MobileNumber,
                  style: const TextStyle(fontSize: 15),
                );
              } else {
                return const Text(
                  '',
                  style: TextStyle(fontSize: 12),
                );
              }
            },
          ),
        ],
      ),
      actions: [
        Visibility(
          visible: widget.onPressedGroupButton != null,
          child: IconButton(
            onPressed: widget.onPressedGroupButton,
            icon: Icon(widget.icon),
          ),
        ),
        BlocBuilder<MessagingBloc, MessagingState>(
          builder: (context, state) {
            return IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                if (context.read<MessagingBloc>().isClosed) {
                  return;
                }
                context.read<MessagingBloc>().add(
                      MessagingGetMessages(
                        chatID: widget.chatID,
                        token: userProfile.token!,
                      ),
                    );
              },
            );
          },
        ),
      ],
    );
  }
}
