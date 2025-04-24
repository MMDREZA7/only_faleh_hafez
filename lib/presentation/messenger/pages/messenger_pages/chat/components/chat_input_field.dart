import 'package:faleh_hafez/Service/APIService.dart';
import 'package:faleh_hafez/constants.dart';
import 'package:faleh_hafez/domain/models/group_chat_dto.dart';
import 'package:faleh_hafez/domain/models/message_dto.dart';
import 'package:faleh_hafez/domain/models/user.dart';
import 'package:faleh_hafez/domain/models/user_chat_dto.dart';
import 'package:faleh_hafez/presentation/messenger/pages/messenger_pages/chat/components/chat_input_fields_models/reply_chat_section.dart';
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
      bloc: context.read<MessagingBloc>(),
      builder: (context, state) {
        if (state is MessagingLoaded) {
          if (state.replyMessage != null) {
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
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                  ),
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
                  editText: state.editMessage!.text,
                  userProfile: userProfile,
                ),
              ],
            );
          }
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
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
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
                    // Icon(
                    //   Icons.sentiment_satisfied_alt_outlined,
                    //   color: Theme.of(context)
                    //       .textTheme
                    //       .bodyText1!
                    //       .color!
                    //       .withOpacity(0.64),
                    // ),
                    const SizedBox(width: kDefaultPadding / 4),
                    Expanded(
                      child: TextField(
                        autofocus: widget.replyToMessage?.messageID != null ||
                                widget.editText != null
                            ? true
                            : false,
                        focusNode: _messageFocusNode,
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: "Type message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    BlocBuilder<MessagingBloc, MessagingState>(
                      builder: (context, state) {
                        if (state is MessagingLoaded) {
                          return TextButton(
                            onPressed: () async {
                              if (state.editMessage != null ||
                                  widget.editText != null) {
                                APIService().editMessage(
                                  token: widget.token,
                                  messageID: state.editMessage!.messageID,
                                  text: _messageController.text,
                                );
                                // context.read<MessagingBloc>().add(
                                //       MessagingEditMessageEvent(
                                //         messageID: state.editMessage!.messageID,
                                //         messageText: _messageController.text,
                                //         token: widget.token,
                                //       ),
                                //     );
                              } else if (state.replyMessage != null ||
                                  widget.replyText != null) {
                                APIService().sendMessage(
                                    token: widget.token,
                                    receiverID: widget.message.receiverID ==
                                            widget.userProfile!.id
                                        ? widget.message.senderID!
                                        : widget.message.receiverID!,
                                    text: _messageController.text,
                                    replyToMessageID:
                                        state.replyMessage!.messageID);
                                // context.read<MessagingBloc>().add(
                                //       MessagingSendMessage(
                                //         chatID: widget.message.chatID!,
                                //         message: MessageDTO(
                                //           messageID: widget.message.messageID,
                                //           text: _messageController.text,
                                //           receiverID: widget.message.receiverID,
                                //           // attachFile: widget.message.attachFile,
                                //           replyToMessageID:
                                //               state.replyMessage!.messageID,
                                //         ),
                                //         mobileNumber:
                                //             widget.userProfile!.mobileNumber!,
                                //         token: widget.userProfile!.token!,
                                //         isNewChat: false,
                                //       ),
                                //     );
                              } else if (_messageController.text != '') {
                                context.read<MessagingBloc>().add(
                                      MessagingSendMessage(
                                        chatID: widget.message.chatID!,
                                        message: MessageDTO(
                                          messageID: widget.message.messageID,
                                          senderID: widget.message.senderID,
                                          text: _messageController.text,
                                          chatID: widget.message.chatID,
                                          groupID: widget.message.groupID,
                                          senderMobileNumber:
                                              widget.message.senderMobileNumber,
                                          senderDisplayName:
                                              widget.message.senderDisplayName,
                                          receiverID: widget.message.receiverID,
                                          receiverMobileNumber: widget
                                              .message.receiverMobileNumber,
                                          receiverDisplayName: widget
                                              .message.receiverDisplayName,
                                          sentDateTime:
                                              widget.message.sentDateTime,
                                          isRead: widget.message.isRead,
                                          attachFile: widget.message.attachFile,
                                          replyToMessageID:
                                              widget.message.replyToMessageID,
                                          replyToMessageText:
                                              widget.message.replyToMessageText,
                                          isEdited: widget.message.isEdited,
                                          isForwarded:
                                              widget.message.isForwarded,
                                          forwardedFromID:
                                              widget.message.forwardedFromID,
                                          forwardedFromDisplayName: widget
                                              .message.forwardedFromDisplayName,
                                        ),
                                        mobileNumber:
                                            widget.userProfile!.mobileNumber!,
                                        token: widget.userProfile!.token!,
                                        isNewChat: false,
                                      ),
                                    );
                              }
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
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          );
                        }
                        return TextButton(
                          onPressed: () async {
                            if (_messageController.text != '') {
                              context.read<MessagingBloc>().add(
                                    MessagingSendMessage(
                                      chatID: widget.message.chatID!,
                                      message: MessageDTO(
                                        messageID: widget.message.messageID,
                                        senderID: widget.message.senderID,
                                        text: _messageController.text,
                                        chatID: widget.message.chatID,
                                        groupID: widget.message.groupID,
                                        senderMobileNumber:
                                            widget.message.senderMobileNumber,
                                        senderDisplayName:
                                            widget.message.senderDisplayName,
                                        receiverID: widget.message.receiverID,
                                        receiverMobileNumber:
                                            widget.message.receiverMobileNumber,
                                        receiverDisplayName:
                                            widget.message.receiverDisplayName,
                                        sentDateTime:
                                            widget.message.sentDateTime,
                                        isRead: widget.message.isRead,
                                        attachFile: widget.message.attachFile,
                                        replyToMessageID:
                                            widget.message.replyToMessageID,
                                        replyToMessageText:
                                            widget.message.replyToMessageText,
                                        isEdited: widget.message.isEdited,
                                        isForwarded: widget.message.isForwarded,
                                        forwardedFromID:
                                            widget.message.forwardedFromID,
                                        forwardedFromDisplayName: widget
                                            .message.forwardedFromDisplayName,
                                      ),
                                      mobileNumber:
                                          widget.userProfile!.mobileNumber!,
                                      token: widget.userProfile!.token!,
                                      isNewChat: false,
                                    ),
                                  );
                            }
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
                                color: Theme.of(context).colorScheme.onPrimary,
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
}
