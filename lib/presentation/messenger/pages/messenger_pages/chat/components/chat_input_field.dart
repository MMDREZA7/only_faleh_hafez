import 'package:Faleh_Hafez/Service/APIService.dart';
import 'package:Faleh_Hafez/Service/signal_r/SignalR_Service.dart';
import 'package:Faleh_Hafez/application/chat_theme_changer/chat_theme_changer_bloc.dart';
import 'package:Faleh_Hafez/constants.dart';
import 'package:Faleh_Hafez/domain/models/group_chat_dto.dart';
import 'package:Faleh_Hafez/domain/models/message_dto.dart';
import 'package:Faleh_Hafez/domain/models/user.dart';
import 'package:Faleh_Hafez/domain/models/user_chat_dto.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/chat_page.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/components/chat_input_fields_models/reply_chat_section.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/components/voiceRecorderButton.dart';
import 'package:flash/flash_helper.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../../../application/messaging/bloc/messaging_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatInputField extends StatefulWidget {
  final String hostPublicID, guestPublicID;
  final bool isGuest;
  final bool isNewChat;
  final UserChatItemDTO userChatItemDTO;
  final GroupChatItemDTO groupChatItemDTO;
  final String receiverID;
  final String token;
  final MessageDTO message;
  // final ScrollController scrollControllerForMessagesList;

  const ChatInputField({
    Key? key,
    required this.hostPublicID,
    required this.guestPublicID,
    required this.isGuest,
    required this.isNewChat,
    required this.userChatItemDTO,
    required this.groupChatItemDTO,
    required this.receiverID,
    required this.token,
    required this.message,
    // required this.scrollControllerForMessagesList,
  }) : super(key: key);

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  User userProfile = User(
    id: '',
    displayName: '',
    mobileNumber: '',
    profileImage: '',
    token: '',
    type: UserType.Guest,
  );

  @override
  void initState() {
    super.initState();
    var box = Hive.box('mybox');

    userProfile = User(
      id: box.get('userID'),
      displayName: box.get('userName'),
      mobileNumber: box.get('userMobile'),
      profileImage: box.get('userImage'),
      token: box.get('userToken'),
      type: userTypeConvertToEnum[box.get("userType")],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagingBloc, MessagingState>(
      // bloc: context.read<MessagingBloc>(),
      builder: (context, state) {
        if (state is MessagingLoaded) {
          print("State is: ${state}");

          if (state.replyMessage?.messageID != null &&
              state.replyMessage!.messageID.isNotEmpty) {
            return Column(
              children: [
                ReplyChatSection(
                  message: state.replyMessage,
                ),
                ChatInput(
                  hostPublicID: widget.hostPublicID,
                  guestPublicID: widget.guestPublicID,
                  isGuest: widget.isGuest,
                  isNewChat: widget.isNewChat,
                  userChatItemDTO: widget.userChatItemDTO,
                  groupChatItemDTO: widget.groupChatItemDTO,
                  receiverID: widget.receiverID,
                  token: widget.token,
                  message: widget.message,
                  replyToMessage: state.replyMessage,
                  userProfile: userProfile,
                  replyText: state.replyMessage!.text,
                ),
              ],
            );
          }
          if (state.editMessage != null) {
            return BlocBuilder<ChatThemeChangerBloc, ChatThemeChangerState>(
              builder: (context, themeState) {
                if (themeState is ChatThemeChangerLoaded) {
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: themeState.theme.colorScheme.primary,
                        ),
                        padding: const EdgeInsets.all(5),
                        child: ListTile(
                          title: Text(
                            "Editing",
                            style: TextStyle(
                              color: themeState.theme.colorScheme.onPrimary,
                            ),
                          ),
                          subtitle: Text(
                            state.editMessage!.text!,
                            style: TextStyle(
                              color: themeState.theme.colorScheme.onPrimary,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              context.read<MessagingBloc>().add(
                                    MessagingGetMessages(
                                      chatID: widget.message.chatID!,
                                      token: userProfile.token!,
                                    ),
                                  );
                            },
                            icon: const Icon(
                              Icons.close,
                            ),
                          ),
                        ),
                      ),
                      ChatInput(
                        hostPublicID: widget.hostPublicID,
                        guestPublicID: widget.guestPublicID,
                        isGuest: widget.isGuest,
                        isNewChat: widget.isNewChat,
                        userChatItemDTO: widget.userChatItemDTO,
                        groupChatItemDTO: widget.groupChatItemDTO,
                        receiverID: widget.receiverID,
                        token: widget.token,
                        message: state.editMessage!,
                        replyToMessage: state.replyMessage,
                        userProfile: userProfile,
                        editText: state.editMessage!.text,
                      ),
                    ],
                  );
                }
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: ListTile(
                        title: const Text("Editing"),
                        subtitle: Text(state.editMessage!.text!),
                        trailing: IconButton(
                          onPressed: () {
                            context.read<MessagingBloc>().add(
                                  MessagingGetMessages(
                                    chatID: widget.message.chatID!,
                                    token: userProfile.token!,
                                  ),
                                );
                          },
                          icon: const Icon(
                            Icons.close,
                          ),
                        ),
                      ),
                    ),
                    ChatInput(
                      hostPublicID: widget.hostPublicID,
                      guestPublicID: widget.guestPublicID,
                      isGuest: widget.isGuest,
                      isNewChat: widget.isNewChat,
                      userChatItemDTO: widget.userChatItemDTO,
                      groupChatItemDTO: widget.groupChatItemDTO,
                      receiverID: widget.receiverID,
                      token: widget.token,
                      message: state.editMessage!,
                      replyToMessage: state.replyMessage,
                      userProfile: userProfile,
                      editText: state.editMessage!.text,
                    ),
                  ],
                );
              },
            );
          }
          // return Center();

          return ChatInput(
            hostPublicID: widget.hostPublicID,
            guestPublicID: widget.guestPublicID,
            isGuest: widget.isGuest,
            isNewChat: widget.isNewChat,
            userChatItemDTO: widget.userChatItemDTO,
            groupChatItemDTO: widget.groupChatItemDTO,
            receiverID: widget.receiverID,
            token: widget.token,
            message: widget.message,
            userProfile: userProfile,
          );
        }

        // return ChatInput(
        //   hostPublicID: widget.hostPublicID,
        //   guestPublicID: widget.guestPublicID,
        //   isGuest: widget.isGuest,
        //   isNewChat: widget.isNewChat,
        //   userChatItemDTO: widget.userChatItemDTO,
        //   groupChatItemDTO: widget.groupChatItemDTO,
        //   receiverID: widget.receiverID,
        //   token: widget.token,
        //   message: widget.message,
        //   userProfile: userProfile,
        // );
        return Center();
      },
    );
  }
}

class ChatInput extends StatefulWidget {
  final String hostPublicID, guestPublicID;
  final bool isGuest;
  final bool isNewChat;
  final UserChatItemDTO userChatItemDTO;
  final GroupChatItemDTO groupChatItemDTO;
  final String receiverID;
  final String token;
  final MessageDTO message;
  final MessageDTO? replyToMessage;
  final String? editText;
  final String? replyText;
  final User? userProfile;

  ChatInput({
    Key? key,
    required this.hostPublicID,
    required this.guestPublicID,
    required this.isGuest,
    required this.isNewChat,
    required this.userChatItemDTO,
    required this.groupChatItemDTO,
    required this.receiverID,
    required this.token,
    required this.message,
    this.replyToMessage,
    this.editText,
    this.replyText,
    required this.userProfile,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  late TextEditingController _messageController;
  final FocusNode _messageFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController(
      text: widget.editText ?? '',
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatThemeChangerBloc, ChatThemeChangerState>(
      builder: (context, themeState) {
        if (themeState is ChatThemeChangerLoaded) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding,
              vertical: kDefaultPadding / 2,
            ),
            decoration: BoxDecoration(
              color: themeState.theme.scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 4),
                  blurRadius: 32,
                  color: const Color(0xFF087949).withOpacity(0.08),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      context.read<MessagingBloc>().add(
                            MessagingSendFileMessage(
                              token: widget.token,
                              isNewChat: widget.isNewChat,
                              message: widget.message,
                            ),
                          );
                    },
                    icon: const Icon(
                      Icons.attach_file,
                      color: kPrimaryColor,
                    ),
                  ),
                  // VoiceRecordButton(
                  //   iconColor: Colors.blue[700],
                  //   // iconColor: themeState.theme.colorScheme.primary,
                  //   backgroundColor: themeState.theme.colorScheme.onPrimary,
                  //   onSend: (recordedFile) {
                  //     print(recordedFile);
                  //     context.showSuccessBar(
                  //       content: const Text(
                  //         "Your Voice Recorded!",
                  //       ),
                  //     );
                  //     throw true;
                  //   },
                  // ),
                  const SizedBox(width: kDefaultPadding),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: kDefaultPadding / 4),
                          Expanded(
                            child: TextFormField(
                              maxLines: null,
                              autofocus:
                                  widget.replyToMessage?.messageID != null ||
                                          widget.editText != null
                                      ? true
                                      : false,
                              focusNode: _messageFocusNode,
                              controller: _messageController,
                              decoration: const InputDecoration(
                                hintText: "Type message",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                border: InputBorder.none,
                              ),
                              cursorColor:
                                  themeState.theme.colorScheme.onPrimary,
                              style: TextStyle(
                                color: themeState.theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                          BlocBuilder<MessagingBloc, MessagingState>(
                            bloc: context.read<MessagingBloc>(),
                            builder: (context, state) {
                              if (state is MessagingLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (state is MessagingLoaded) {
                                return TextButton(
                                  onPressed: () async {
                                    if (state.editMessage != null ||
                                        widget.editText != null) {
                                      try {
                                        var message = widget.message;
                                        await APIService().editMessage(
                                          token: widget.userProfile!.token!,
                                          messageID: widget.message.messageID,
                                          text: _messageController.text,
                                        );

                                        context.read<MessagingBloc>().add(
                                              MessagingEditMessageSignalR(
                                                message: MessageDTO(
                                                  messageID: message.messageID,
                                                  senderID: message.senderID,
                                                  text: _messageController.text,
                                                  chatID: message.chatID,
                                                  groupID: message.groupID,
                                                  senderMobileNumber: message
                                                      .senderMobileNumber,
                                                  senderDisplayName:
                                                      message.senderDisplayName,
                                                  receiverID:
                                                      message.receiverID,
                                                  receiverMobileNumber: message
                                                      .receiverMobileNumber,
                                                  receiverDisplayName: message
                                                      .receiverDisplayName,
                                                  sentDateTime:
                                                      message.sentDateTime,
                                                  dateCreate:
                                                      message.dateCreate,
                                                  isRead: message.isRead,
                                                  attachFile:
                                                      message.attachFile,
                                                  replyToMessageID:
                                                      message.replyToMessageID,
                                                  replyToMessageText: message
                                                      .replyToMessageText,
                                                  isEdited: message.isEdited,
                                                  isForwarded:
                                                      message.isForwarded,
                                                  forwardedFromID:
                                                      message.forwardedFromID,
                                                  forwardedFromDisplayName: message
                                                      .forwardedFromDisplayName,
                                                ),
                                                token:
                                                    widget.userProfile!.token!,
                                              ),
                                            );
                                      } catch (e) {
                                        // ignore: use_build_context_synchronously
                                        context.showErrorBar(
                                          content: Text(
                                            e.toString(),
                                          ),
                                        );
                                      }
                                    } else if (state.replyMessage?.messageID !=
                                            null &&
                                        state.replyMessage?.messageID != '' &&
                                        widget.replyText != null) {
                                      var message = widget.message;
                                      context.read<MessagingBloc>().add(
                                            MessagingSendMessage(
                                              message: MessageDTO(
                                                messageID: message.messageID,
                                                senderID: message.senderID,
                                                text: _messageController.text,
                                                chatID:
                                                    state.replyMessage?.chatID,
                                                groupID: message.groupID,
                                                senderMobileNumber:
                                                    userProfile.mobileNumber,
                                                senderDisplayName:
                                                    userProfile.displayName,
                                                receiverID: message
                                                            .receiverID ==
                                                        widget.userProfile!.id
                                                    ? message.senderID
                                                    : message.receiverID,
                                                receiverMobileNumber: message
                                                            .receiverID ==
                                                        widget.userProfile!.id
                                                    ? message.senderMobileNumber
                                                    : message
                                                        .receiverMobileNumber,
                                                receiverDisplayName:
                                                    message.receiverDisplayName,
                                                sentDateTime:
                                                    message.sentDateTime,
                                                isRead: message.isRead,
                                                attachFile: message.attachFile,
                                                replyToMessageID: state
                                                    .replyMessage?.messageID,
                                                replyToMessageText:
                                                    state.replyMessage?.text,
                                                isEdited: message.isEdited,
                                                isForwarded:
                                                    message.isForwarded,
                                                forwardedFromID:
                                                    message.forwardedFromID,
                                                forwardedFromDisplayName: message
                                                    .forwardedFromDisplayName,
                                              ),
                                              chatID:
                                                  state.replyMessage?.chatID,
                                              isNewChat: false,
                                              token: widget.userProfile!.token!,
                                              mobileNumber: message
                                                          .receiverID ==
                                                      widget.userProfile!.id
                                                  ? message.senderMobileNumber!
                                                  : message
                                                      .receiverMobileNumber!,
                                            ),
                                          );
                                    } else if (_messageController.text != '') {
                                      context.read<MessagingBloc>().add(
                                            MessagingSendMessage(
                                              chatID: widget.message.chatID!,
                                              message: MessageDTO(
                                                messageID:
                                                    widget.message.messageID,
                                                senderID:
                                                    widget.message.senderID,
                                                text: _messageController.text,
                                                chatID: widget.message.chatID,
                                                groupID: widget.message.groupID,
                                                senderMobileNumber: widget
                                                    .message.senderMobileNumber,
                                                senderDisplayName: widget
                                                    .message.senderDisplayName,
                                                receiverID:
                                                    widget.message.receiverID,
                                                receiverMobileNumber: widget
                                                    .message
                                                    .receiverMobileNumber,
                                                receiverDisplayName: widget
                                                    .message
                                                    .receiverDisplayName,
                                                sentDateTime:
                                                    widget.message.sentDateTime,
                                                isRead: widget.message.isRead,
                                                attachFile: widget
                                                            .message
                                                            .attachFile
                                                            ?.fileAttachmentID ==
                                                        ""
                                                    ? null
                                                    : widget.message.attachFile,
                                                isEdited:
                                                    widget.message.isEdited,
                                                isForwarded:
                                                    widget.message.isForwarded,
                                                forwardedFromID: widget
                                                    .message.forwardedFromID,
                                                forwardedFromDisplayName: widget
                                                    .message
                                                    .forwardedFromDisplayName,
                                              ),
                                              mobileNumber: widget
                                                  .userProfile!.mobileNumber!,
                                              token: widget.userProfile!.token!,
                                              isNewChat: false,
                                            ),
                                          );
                                    }
                                    _messageController.clear();
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                    child: Text(
                                      'Send',
                                      style: TextStyle(
                                        color: themeState
                                            .theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              // if (state is MessagingError) {
                              //   context.showErrorBar(
                              //     content: Text(
                              //       state.errorMessage,
                              //     ),
                              //   );
                              //   return Center();
                              // }
                              return TextButton(
                                onPressed: () async {
                                  if (_messageController.text != '') {
                                    // context.read<MessagingBloc>().add(
                                    //       MessagingSendMessage(
                                    //         chatID: widget.message.chatID!,
                                    //         message: MessageDTO(
                                    //           messageID: widget.message.messageID,
                                    //           senderID: widget.message.senderID,
                                    //           text: _messageController.text,
                                    //           chatID: widget.message.chatID,
                                    //           groupID: widget.message.groupID,
                                    //           senderMobileNumber:
                                    //               widget.message.senderMobileNumber,
                                    //           senderDisplayName:
                                    //               widget.message.senderDisplayName,
                                    //           receiverID: widget.message.receiverID,
                                    //           receiverMobileNumber:
                                    //               widget.message.receiverMobileNumber,
                                    //           receiverDisplayName:
                                    //               widget.message.receiverDisplayName,
                                    //           sentDateTime:
                                    //               widget.message.sentDateTime,
                                    //           isRead: widget.message.isRead,
                                    //           attachFile: widget.message.attachFile,
                                    //           replyToMessageID:
                                    //               widget.message.replyToMessageID,
                                    //           replyToMessageText:
                                    //               widget.message.replyToMessageText,
                                    //           isEdited: widget.message.isEdited,
                                    //           isForwarded: widget.message.isForwarded,
                                    //           forwardedFromID:
                                    //               widget.message.forwardedFromID,
                                    //           forwardedFromDisplayName: widget
                                    //               .message.forwardedFromDisplayName,
                                    //         ),
                                    //         mobileNumber:
                                    //             widget.userProfile!.mobileNumber!,
                                    //         token: widget.userProfile!.token!,
                                    //         isNewChat: false,
                                    //       ),
                                    //     );
                                    // _messageController.clear();
                                  }
                                  // context.read<MessagingBloc>().add(
                                  //       MessagingGetMessages(
                                  //         chatID: widget.message.chatID ??
                                  //             widget.message.groupID!,
                                  //         token: widget.userProfile!.token!,
                                  //       ),
                                  //     );
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: Text(
                                    'alk;g;sjdfk;lasd',
                                    style: TextStyle(
                                      color: themeState
                                          .theme.colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Center();
      },
    );
  }
}
