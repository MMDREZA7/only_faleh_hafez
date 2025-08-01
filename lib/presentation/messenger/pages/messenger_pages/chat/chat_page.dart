import 'dart:async';
import 'dart:typed_data';

import 'package:Faleh_Hafez/Service/APIService.dart';
import 'package:Faleh_Hafez/Service/signal_r/SignalR_Service.dart';
import 'package:Faleh_Hafez/application/chat_items/chat_items_bloc.dart';
import 'package:Faleh_Hafez/application/chat_theme_changer/chat_theme_changer_bloc.dart';
import 'package:Faleh_Hafez/application/group_members/group_members_bloc.dart';
import 'package:Faleh_Hafez/domain/models/group_chat_dto.dart';
import 'package:Faleh_Hafez/domain/models/message_dto.dart';
import 'package:Faleh_Hafez/domain/models/user.dart';
import 'package:Faleh_Hafez/domain/models/user_chat_dto.dart';
import 'package:Faleh_Hafez/presentation/messenger/group_profile/group_profile_page.dart';
import 'package:Faleh_Hafez/presentation/messenger/user_profile/other_profile_page.dart';
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

  SignalRService? signalR;

  @override
  void initState() {
    super.initState();
    final messagingBloc = context.read<MessagingBloc>();

    signalR = SignalRService(messagingBloc: messagingBloc);

    signalR?.initConnection();
    print("✅ SignalR connected.");

    messagingBloc.currentChatID =
        widget.chatID != "" && widget.chatID != '' && widget.chatID.isNotEmpty
            ? widget.chatID
            : widget.groupChatItemDTO.id;

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

    context.read<MessagingBloc>().add(
          MessagingGetMessages(
            chatID: widget.chatID.isEmpty
                ? widget.groupChatItemDTO.id
                : widget.chatID,
            token: userProfile.token!,
          ),
        );
  }

  @override
  void dispose() {
    signalR?.stopConnection();
    print("✅ SignalR disConnected.");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatThemeChangerBloc, ChatThemeChangerState>(
      builder: (context, themeState) {
        if (themeState is ChatThemeChangerLoaded) {
          return Scaffold(
            appBar: buildAppBar(context, themeState, widget.userChatItemDTO),
            backgroundColor: themeState.theme.colorScheme.background,
            body: BlocProvider(
              create: (context) =>
                  ChatThemeChangerBloc()..add(FirstTimeOpenChat()),
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

                  if (state is MessagingLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: themeState.theme.colorScheme.primary,
                      ),
                    );
                  }
                  if (state is MessagingLoaded) {
                    state.editMessage;
                    state.replyMessage;
                    final correctedMessage = MessageDTO(
                      messageID: '',
                      senderID: widget.message.senderID == userProfile.id
                          ? widget.message.senderID
                          : widget.message.receiverID,
                      text: widget.message.text,
                      chatID: widget.message.chatID,
                      groupID: widget.message.groupID,
                      senderMobileNumber: userProfile.mobileNumber,
                      receiverID: widget.message.receiverID == userProfile.id
                          ? widget.message.senderID
                          : widget.message.receiverID,
                      receiverMobileNumber:
                          widget.message.receiverMobileNumber ==
                                  userProfile.mobileNumber
                              ? widget.message.senderMobileNumber
                              : widget.message.receiverMobileNumber,
                      sentDateTime: widget.message.sentDateTime,
                      isRead: widget.message.isRead,
                      attachFile: widget.message.attachFile,
                      replyToMessageText: state.replyMessage?.text,
                      forwardedFromDisplayName:
                          widget.message.forwardedFromDisplayName,
                      forwardedFromID: widget.message.forwardedFromID,
                      isEdited: widget.message.isEdited,
                      isForwarded: widget.message.isForwarded,
                      receiverDisplayName: widget.message.receiverDisplayName,
                      replyToMessageID: state.replyMessage?.messageID,
                      senderDisplayName: widget.message.senderDisplayName,
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
          );
        }

        return const Center();
      },
    );
  }

  AppBar buildAppBar(BuildContext context, ChatThemeChangerState themeState,
      UserChatItemDTO userChatItem) {
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

    var guestProfileImage =
        widget.userChatItemDTO.participant2ID == userProfile.id
            ? widget.userChatItemDTO.participant1ProfileImage
            : widget.userChatItemDTO.participant2ProfileImage;
    // var hostProfileImage =
    //     widget.userChatItemDTO.participant1ID == userProfile.id
    //         ? widget.userChatItemDTO.participant1ProfileImage
    //         : widget.userChatItemDTO.participant2ProfileImage;

    Future<Uint8List?> _loadUserImage() async {
      String? imageId;
      if (widget.groupChatItemDTO.id.isNotEmpty) {
        imageId = widget.groupChatItemDTO.profileImage;
      } else {
        imageId = userChatItem.participant1ID == userProfile.id
            ? userChatItem.participant2ProfileImage
            : userChatItem.participant1ProfileImage;
      }

      if (imageId != '') {
        try {
          List<int> imageData = await APIService().downloadFile(
            token: userProfile.token!,
            id: imageId ?? '',
          );
          return Uint8List.fromList(imageData);
        } catch (e) {
          debugPrint("Error loading profile image: $e");
        }
      }
      return null;
    }

    print(themeState.theme.colorScheme.onPrimary);

    return AppBar(
      foregroundColor: themeState.theme.colorScheme.onPrimary,
      backgroundColor: themeState.theme.colorScheme.primary,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          CupertinoIcons.back,
          // color: themeState.colorScheme.onPrimary,
        ),
      ),
      title: Row(
        children: [
          FutureBuilder<Uint8List?>(
            future: _loadUserImage(),
            builder: (context, snapshot) {
              Widget imageWidget;

              if (snapshot.connectionState == ConnectionState.waiting) {
                imageWidget = const CircularProgressIndicator();
              } else if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data!.isNotEmpty) {
                imageWidget = CircleAvatar(
                  radius: 17,
                  backgroundImage: MemoryImage(
                    snapshot.data!,
                  ),
                );
              } else {
                imageWidget = CircleAvatar(
                  backgroundColor: themeState.theme.colorScheme.onSecondary,
                  radius: 20,
                  child: Icon(
                    widget.groupChatItemDTO.id != ''
                        ? Icons.group
                        : Icons.person,
                    color: themeState.theme.colorScheme.primary,
                    size: 30,
                  ),
                );
              }
              return imageWidget;
            },
          ),
          const SizedBox(width: 10),
          Visibility(
            // ignore: unnecessary_null_comparison
            visible: widget.groupChatItemDTO.id != null &&
                    widget.groupChatItemDTO.id.isNotEmpty
                ? true
                : false,
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
                    builder: (context) => BlocProvider(
                      create: (context) => context.read<GroupMembersBloc>()
                        ..add(
                          GroupMembersGetGroupMembersEvent(
                            token: userProfile.token!,
                            groupID: widget.groupChatItemDTO.id,
                          ),
                        ),
                      child: GroupProfilePage(
                        group: widget.groupChatItemDTO,
                        groupOwnerID: widget.groupChatItemDTO.createdByID,
                      ),
                    ),
                  ),
                );
              },
              child: Text(
                widget.name,
                style: TextStyle(
                  fontFamily: 'iranSans',
                  fontSize: 16,
                  color: themeState.theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          BlocBuilder<MessagingBloc, MessagingState>(
            builder: (context, state) {
              if (state is MessagingLoading) {
                return const Text(
                  'Loading...',
                  style: TextStyle(fontFamily: 'iranSans', fontSize: 12),
                );
              } else if (state is MessagingLoaded) {
                return TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    minimumSize: MaterialStateProperty.all(Size.zero),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    shape: MaterialStateProperty.all(
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtherProfilePage(
                          userChatItem: widget.userChatItemDTO,
                          otherUserProfile: User(
                            id: '',
                            displayName: guestDisplayName,
                            profileImage: guestProfileImage,
                            mobileNumber: guestMobileNumber,
                            token: userProfile.token,
                            type: UserType.Regular,
                          ),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    widget.userChatItemDTO.participant1DisplayName ==
                            userProfile.displayName
                        ? widget.userChatItemDTO.participant2DisplayName
                        : widget.userChatItemDTO.participant1DisplayName,
                    style: TextStyle(
                      fontFamily: 'iranSans',

                      fontSize: 16,
                      // color: themeState.colorScheme.onPrimary,
                    ),
                  ),
                );
              } else {
                return const Text(
                  '',
                  style: TextStyle(fontFamily: 'iranSans', fontSize: 12),
                );
              }
            },
          ),
        ],
      ),
      actions: [
        // Visibility(
        //   visible: widget.onPressedGroupButton != null,
        //   child: IconButton(
        //     onPressed: widget.onPressedGroupButton,
        //     icon: Icon(widget.icon),
        //   ),
        // ),
        BlocBuilder<MessagingBloc, MessagingState>(
          builder: (context, state) {
            return IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
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
