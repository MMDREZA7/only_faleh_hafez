import 'dart:io';
import 'package:Faleh_Hafez/Service/APIService.dart';
import 'package:Faleh_Hafez/Service/signal_r/SignalR_Service.dart';
import 'package:Faleh_Hafez/application/chat_items/chat_items_bloc.dart';
import 'package:Faleh_Hafez/application/chat_theme_changer/chat_theme_changer_bloc.dart';
import 'package:Faleh_Hafez/constants.dart';
import 'package:Faleh_Hafez/domain/models/group_chat_dto.dart';
import 'package:Faleh_Hafez/domain/models/message_dto.dart';
import 'package:Faleh_Hafez/domain/models/user.dart';
import 'package:Faleh_Hafez/domain/models/user_chat_dto.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/components/chat_input_fields_models/reply_chat_section.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/components/voiceRecorderButton.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/components/voice_message/voice_message_bubble.dart';
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
                              fontFamily: 'iranSans',
                              color: themeState.theme.colorScheme.onPrimary,
                            ),
                          ),
                          subtitle: Text(
                            state.editMessage!.text!,
                            style: TextStyle(
                              fontFamily: 'iranSans',
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
        return const Center();
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
  bool isVoiceExist = false;
  bool isRecordingVoice = false;
  File? recordedExistFile;
  String? recordedExistFileID;
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
    Future<List<int>> getVoiceFile(String fileID) async {
      return await APIService().downloadFile(
        id: fileID,
        token: widget.token,
      );
    }

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
                      size: 25,
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isVoiceExist
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                isVoiceExist = false;
                                recordedExistFileID = null;
                                recordedExistFile = null;
                              });
                            },
                            icon: Icon(
                              Icons.delete_forever_rounded,
                              color: themeState.theme.colorScheme.error,
                            ),
                          )
                        : VoiceRecordButton(
                            iconColor: Colors.blue[700],
                            onRecordingStateChanged: (isRecording) =>
                                setState(() {
                              isRecordingVoice = isRecording;
                            }),
                            // iconColor: themeState.theme.colorScheme.primary,
                            backgroundColor:
                                themeState.theme.colorScheme.onPrimary,
                            onSend: (File recordedFile) async {
                              try {
                                var response = await APIService().uploadFile(
                                  token: userProfile.token!,
                                  filePath: recordedFile.path,
                                  name: recordedFile.path.split('/').last,
                                  description: 'VoiceFile',
                                );

                                setState(() {
                                  isVoiceExist = true;
                                  recordedExistFile = recordedFile;
                                  recordedExistFileID = response.id;
                                  isRecordingVoice = !isRecordingVoice;
                                });
                                // await APIService().sendMessage(
                                //   token: userProfile.token!,
                                //   mobileNumber: userProfile.mobileNumber!,
                                //   receiverID: widget.receiverID,
                                //   text: recordedFile.path.split('/').last,
                                //   fileAttachmentID: response.id,
                                //   replyToMessageID: widget.replyToMessage?.messageID,
                                // );

                                // context.showSuccessBar(
                                //   content: const Text(
                                //     "Your Voice Recorded!",
                                //   ),
                                // );
                              } catch (e) {}
                            },
                          ),
                  ),
                  // const SizedBox(width: kDefaultPadding),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: isRecordingVoice
                                  ? Center(
                                      child: Text(
                                        "Recording ...",
                                        style: TextStyle(
                                          fontFamily: 'iranSans',
                                          color: Colors.red[800],
                                        ),
                                      ),
                                    )
                                  : isVoiceExist
                                      ? Row(
                                          children: [
                                            Expanded(
                                              child: FutureBuilder<List<int>>(
                                                future: getVoiceFile(
                                                    recordedExistFileID!),
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState ==
                                                          ConnectionState
                                                              .done &&
                                                      snapshot.hasData) {
                                                    return VoiceMessageBubble(
                                                      audioBytes:
                                                          snapshot.data!,
                                                      isMessage: false,
                                                      themeState:
                                                          themeState.theme,
                                                    );
                                                  }
                                                  return const Center();
                                                },
                                              ),
                                            ),
                                          ],
                                        )
                                      : TextFormField(
                                          maxLines: null,
                                          autofocus: widget.replyToMessage
                                                          ?.messageID !=
                                                      null ||
                                                  widget.editText != null
                                              ? true
                                              : false,
                                          focusNode: _messageFocusNode,
                                          controller: _messageController,
                                          decoration: const InputDecoration(
                                            hintText: "Type message",
                                            hintStyle: TextStyle(
                                              fontFamily: 'iranSans',
                                              color: Colors.white,
                                            ),
                                            border: InputBorder.none,
                                          ),
                                          cursorColor: themeState
                                              .theme.colorScheme.onPrimary,
                                          style: TextStyle(
                                            fontFamily: 'iranSans',
                                            color: themeState
                                                .theme.colorScheme.onPrimary,
                                          ),
                                        ),
                            ),
                          ),
                          // const SizedBox(width: kDefaultPadding),
                          BlocBuilder<MessagingBloc, MessagingState>(
                            bloc: context.read<MessagingBloc>(),
                            builder: (context, state) {
                              if (state is MessagingLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (state is MessagingLoaded) {
                                if (isRecordingVoice) {
                                  return const Center();
                                }
                                if (recordedExistFileID != null &&
                                    recordedExistFileID != '') {
                                  return IconButton(
                                    onPressed: () async {
                                      var message = widget.message;

                                      context.read<MessagingBloc>().add(
                                            MessagingSendMessage(
                                              message: MessageDTO(
                                                messageID: message.messageID,
                                                senderID: message.senderID,
                                                text: recordedExistFile!.path
                                                    .split('/')
                                                    .last,
                                                chatID: message.chatID,
                                                groupID: message.groupID,
                                                senderMobileNumber:
                                                    message.senderMobileNumber,
                                                senderDisplayName:
                                                    message.senderDisplayName,
                                                receiverID: message.receiverID,
                                                receiverMobileNumber: message
                                                    .receiverMobileNumber,
                                                receiverDisplayName:
                                                    message.receiverDisplayName,
                                                sentDateTime:
                                                    message.sentDateTime,
                                                dateCreate: message.dateCreate,
                                                isRead: message.isRead,
                                                attachFile: AttachmentFile(
                                                  fileAttachmentID:
                                                      recordedExistFileID,
                                                ),
                                                replyToMessageID: widget
                                                    .replyToMessage?.messageID,
                                                replyToMessageText:
                                                    message.replyToMessageText,
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
                                      setState(() {
                                        recordedExistFile = null;
                                        recordedExistFileID = null;
                                        isVoiceExist = false;
                                      });
                                      // context.read<ChatItemsBloc>().add(
                                      //     ChatItemsGetPrivateChatsEvent(
                                      //         token: userProfile.token!));
                                      // context.read<ChatItemsBloc>().add(
                                      //     ChatItemsGetPublicChatsEvent(
                                      //         token: userProfile.token!));
                                    },
                                    icon: Icon(
                                      Icons.send_rounded,
                                      color: Colors.blue[700],
                                      size: 25,
                                    ),
                                  );
                                }
                                return TextButton(
                                  onPressed: () async {
                                    if (isVoiceExist) {
                                      var message = widget.message;
                                      // await APIService().sendMessage(
                                      //   token: userProfile.token!,
                                      //   mobileNumber: userProfile.mobileNumber!,
                                      //   receiverID: widget.receiverID,
                                      //   text: recordedExistFile!.path
                                      //       .split('/')
                                      //       .last,
                                      //   fileAttachmentID: recordedExistFileID,
                                      //   replyToMessageID:
                                      //       widget.replyToMessage?.messageID,
                                      // );
                                      context.read<MessagingBloc>().add(
                                            MessagingSendMessage(
                                              message: MessageDTO(
                                                messageID: message.messageID,
                                                senderID: message.senderID,
                                                text: _messageController.text,
                                                chatID: message.chatID,
                                                groupID: message.groupID,
                                                senderMobileNumber:
                                                    message.senderMobileNumber,
                                                senderDisplayName:
                                                    message.senderDisplayName,
                                                receiverID: message.receiverID,
                                                receiverMobileNumber: message
                                                    .receiverMobileNumber,
                                                receiverDisplayName:
                                                    message.receiverDisplayName,
                                                sentDateTime:
                                                    message.sentDateTime,
                                                dateCreate: message.dateCreate,
                                                isRead: message.isRead,
                                                attachFile: AttachmentFile(
                                                  fileAttachmentID:
                                                      recordedExistFileID,
                                                ),
                                                replyToMessageID:
                                                    message.replyToMessageID,
                                                replyToMessageText:
                                                    message.replyToMessageText,
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
                                      setState(() {
                                        recordedExistFile = null;
                                        recordedExistFileID = null;
                                        isVoiceExist = false;
                                      });
                                    }
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
                                        fontFamily: 'iranSans',
                                        color: themeState
                                            .theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              return TextButton(
                                onPressed: () {},
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
                                      fontFamily: 'iranSans',
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
        return const Center();
      },
    );
  }
}
