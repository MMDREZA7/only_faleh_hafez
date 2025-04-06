import 'package:faleh_hafez/constants.dart';
import 'package:faleh_hafez/domain/models/group_chat_dto.dart';
import 'package:faleh_hafez/domain/models/massage_dto.dart';
import 'package:faleh_hafez/domain/models/user.dart';
import 'package:faleh_hafez/domain/models/user_chat_dto.dart';
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
  final _messageController = TextEditingController();
  final _messageFocusNode = FocusNode();
  // var _textDirection = ui.TextDirection.rtl;

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
    final String id = box.get('userID');
    final String? userName = box.get('userName');
    final String mobileNumber = box.get('userMobile');
    final String token = box.get('userToken');
    final int type = box.get('userType');

    userProfile = User(
      id: id,
      displayName: userName ?? "Default UserName",
      mobileNumber: mobileNumber,
      token: token,
      type: userTypeConvertToEnum[type]!,

      // !!!!!
      profileImage: null,
      // !!!!!
    );
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
            BlocBuilder<MessagingBloc, MessagingState>(
              builder: (context, state) {
                return IconButton(
                  onPressed: () {
                    context.read<MessagingBloc>().add(
                          MessagingSendFileMessage(
                            token: widget.token,
                            isNewChat: widget.isNewChat,
                            message: widget.message,
                            // senderPublicID: widget.isGuest
                            //     ? widget.hostPublicID
                            //     : widget.guestPublicID,
                            // receiverPublicID: widget.isGuest
                            //     ? widget.guestPublicID
                            //     : widget.hostPublicID,
                            // message: MessageDTO(
                            //   reciverID: '',
                            //   text: '',
                            // ),
                          ),
                        );
                  },
                  icon: const Icon(
                    Icons.attach_file,
                    color: kPrimaryColor,
                  ),
                );
              },
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
                      child: TextFormField(
                        focusNode: _messageFocusNode,
                        controller: _messageController,
                        onEditingComplete: () {
                          if (_messageController.text != '') {
                            // widget.scrollControllerForMessagesList
                            //     .animateTo(
                            //   widget.scrollControllerForMessagesList
                            //       .position.maxScrollExtent,
                            //   duration: Duration(milliseconds: 300),
                            //   curve: Curves.easeOut,
                            // );
                            context.read<MessagingBloc>().add(
                                  MessagingSendMessage(
                                    mobileNumber: widget.userChatItemDTO
                                                .participant2MobileNumber ==
                                            ''
                                        ? widget.groupChatItemDTO.id
                                        : widget.userChatItemDTO
                                            .participant2MobileNumber,
                                    isNewChat: widget.isNewChat,
                                    chatID: widget.userChatItemDTO.id,
                                    message: MessageDTO(
                                      senderID: widget.message.senderID ==
                                              userProfile.id
                                          ? widget.message.senderID
                                          : widget.message.receiverID,
                                      text: _messageController.text,
                                      chatID: widget.message.chatID,
                                      groupID: widget.message.groupID,
                                      senderMobileNumber:
                                          widget.message.senderMobileNumber,
                                      receiverID: widget.message.receiverID ==
                                              userProfile.id
                                          ? widget.message.senderID
                                          : widget.message.receiverID,
                                      receiverMobileNumber:
                                          widget.message.receiverMobileNumber,
                                      sentDateTime: widget.message.sentDateTime,
                                      isRead: widget.message.isRead,
                                      attachFile: widget.message.attachFile,
                                      messageID: widget.message.messageID,
                                    ),
                                    token: widget.token,
                                  ),
                                );
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: "Type message",
                          border: InputBorder.none,
                        ),
                        // textDirection: _textDirection,
                        // onEditingComplete: () {
                        //   if (_messageController.text != null &&
                        //       _messageController.text != '') {
                        //     // widget.scrollControllerForMessagesList.animateTo(
                        //     //   widget.scrollControllerForMessagesList.position
                        //     //       .maxScrollExtent,
                        //     //   duration: Duration(milliseconds: 300),
                        //     //   curve: Curves.easeOut,
                        //     // );
                        //     context.read<MessagingBloc>().add(
                        //           MessagingSendMessage(
                        //               chatID: '',
                        //               message: MessageDTO(
                        //                 reciverID: '',
                        //                 text: '',
                        //               )),
                        //         );
                        //   }
                        // },
                      ),
                    ),
                    _messageController.value == ''
                        ? Row(
                            children: [
                              Icon(
                                Icons.attach_file,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                              const SizedBox(width: kDefaultPadding / 4),
                              Icon(
                                Icons.camera_alt_outlined,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color!
                                    .withOpacity(0.64),
                              ),
                            ],
                          )
                        : TextButton(
                            onPressed: () {
                              if (_messageController.text != '') {
                                // widget.scrollControllerForMessagesList
                                //     .animateTo(
                                //   widget.scrollControllerForMessagesList
                                //       .position.maxScrollExtent,
                                //   duration: Duration(milliseconds: 300),
                                //   curve: Curves.easeOut,
                                // );
                                context.read<MessagingBloc>().add(
                                      MessagingSendMessage(
                                        mobileNumber: widget.userChatItemDTO
                                            .participant2MobileNumber,
                                        isNewChat: widget.isNewChat,
                                        chatID: widget.userChatItemDTO.id,
                                        message: MessageDTO(
                                          messageID: widget.message.messageID,
                                          attachFile: widget.message.attachFile,
                                          senderID: widget.message.senderID ==
                                                  userProfile.id
                                              ? widget.message.senderID
                                              : widget.message.receiverID,
                                          text: _messageController.text,
                                          chatID: widget.message.chatID,
                                          groupID: widget.message.groupID,
                                          senderMobileNumber:
                                              widget.message.senderMobileNumber,
                                          receiverID:
                                              widget.message.receiverID ==
                                                      userProfile.id
                                                  ? widget.message.senderID
                                                  : widget.message.receiverID,
                                          receiverMobileNumber: widget
                                              .message.receiverMobileNumber,
                                          sentDateTime:
                                              widget.message.sentDateTime,
                                          isRead: widget.message.isRead,
                                        ),
                                        token: widget.token,
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
