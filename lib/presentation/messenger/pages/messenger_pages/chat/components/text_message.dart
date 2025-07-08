import 'package:Faleh_Hafez/Service/APIService.dart';
import 'package:Faleh_Hafez/application/messaging/bloc/messaging_bloc.dart';
import 'package:Faleh_Hafez/domain/models/message_dto.dart';
import 'package:Faleh_Hafez/domain/models/user.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/components/forward_modal_sheet.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/components/messages_models/forward_message.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/components/messages_models/reply_message.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/components/messages_models/simple_message.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import '../models/chat_message_for_show.dart';

class TextMessage extends StatefulWidget {
  const TextMessage({
    super.key,
    this.message,
    this.messageDetail,
  });

  final ChatMessageForShow? message;
  final MessageDTO? messageDetail;

  @override
  State<TextMessage> createState() => _TextMessageState();
}

class _TextMessageState extends State<TextMessage> {
  var userProfile = User(
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
      type: userTypeConvertToEnum[box.get('userType')],
    );
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   context.read<MessagingBloc>().close();
  // }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    void safeAddEvent(MessagingEvent event) {
      final bloc = context.read<MessagingBloc>();
      if (!bloc.isClosed) {
        bloc.add(event);
      } else {
        debugPrint("MessagingBloc is closed. Event not added.");
      }
    }

    void handleOnLongPress() {
      showMenu(
        context: context,
        position: RelativeRect.fill,
        items: [
          PopupMenuItem(
            enabled: false,
            value: widget.message?.text,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${widget.message!.text.length < 20 ? widget.message?.text : '${widget.message!.text.substring(0, 20)} ...'}',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            onTap: () {
              // showDialog(
              //   context: context,
              //   builder: (context) => ReplyMessageDialog(
              //     message: widget.messageDetail!,
              //     token: userProfile.token!,
              //   ),
              // );
              if (context.read<MessagingBloc>().isClosed) {
                return;
              } else {
                // var correctReceiverID = '';
                // if (userProfile.id == widget.messageDetail!.senderID &&
                //     widget.messageDetail!.receiverID != null) {
                //   correctReceiverID = widget.messageDetail!.receiverID!;
                // } else {
                //   correctReceiverID = widget.messageDetail!.senderID!;
                // }
                var message = widget.messageDetail!;
                safeAddEvent(
                  MessagingReplyMessageEvent(
                    message: message,
                  ),
                );
              }
            },
            value: "reply",
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Reply"),
                SizedBox(
                  width: 5,
                ),
                Icon(Icons.refresh),
              ],
            ),
          ),
          PopupMenuItem(
            onTap: () {
              ClipboardData(
                text: widget.message!.text,
              );
              context.showInfoBar(
                  content: Text(
                      "'${widget.message!.text.length < 20 ? widget.message?.text : '${widget.message!.text.substring(0, 20)} ...'}' Copied!"));
            },
            value: "copy",
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Copy"),
                SizedBox(
                  width: 5,
                ),
                Icon(Icons.copy),
              ],
            ),
          ),
          PopupMenuItem(
            onTap: () async {
              // ignore: use_build_context_synchronously
              await showModalBottomSheet(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  context: context,
                  builder: (context) => ForwardModalSheet(
                        message: widget.messageDetail!,
                      ));
            },
            value: "forward",
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Forward"),
                SizedBox(
                  width: 5,
                ),
                Icon(Icons.fast_forward),
              ],
            ),
          ),
          PopupMenuItem(
            onTap: () async {
              try {
                if (widget.messageDetail!.senderID == userProfile.id) {
                  context.read<MessagingBloc>().add(
                        MessagingEditMessageEvent(
                          message: widget.messageDetail!,
                          token: userProfile.token!,
                        ),
                        // MessagingEnterEditMode(
                        //   message: widget.messageDetail!,

                        // ),
                      );
                } else {
                  return;
                }
              } catch (e) {
                context.showErrorBar(
                  content: Text(
                    e.toString(),
                  ),
                );
              }
              // // }
            },
            value: "edit",
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Edit"),
                SizedBox(
                  width: 5,
                ),
                Icon(Icons.edit),
              ],
            ),
          ),
          PopupMenuItem(
            onTap: () async {
              try {
                await APIService().deleteMessage(
                  token: userProfile.token!,
                  messageID: widget.messageDetail!.messageID,
                );
                context.read<MessagingBloc>().add(
                      MessagingDeleteMessageSignalR(
                        // chatID: widget.messageDetail!.chatID ??
                        //     widget.messageDetail!.groupID!,
                        message: widget.messageDetail!,
                        token: userProfile.token!,
                      ),
                    );
              } catch (e) {
                context.showErrorBar(
                  content: Text(e.toString()),
                );
              }
            },
            value: "delete",
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Delete"),
                SizedBox(
                  width: 5,
                ),
                Icon(Icons.delete),
              ],
            ),
          ),
        ],
      ).then(
        (value) {
          if (value != null) {
            print("Selected: $value");
          }
        },
      );
    }

// if message is Reply Message
    if (widget.messageDetail?.replyToMessageText != null &&
        widget.messageDetail?.replyToMessageID != null) {
      return ReplyMessage(
        handleOnLongPress: handleOnLongPress,
        messageDetail: widget.messageDetail!,
        size: _size,
      );
    }

// if message is Forward Message
    if (widget.messageDetail!.forwardedFromID != null) {
      return ForwardMessage(
        handleOnLongPress: handleOnLongPress,
        messageDetail: widget.messageDetail!,
        size: _size,
      );
    } else {
      return SimpleMessage(
        handleOnLongPress: handleOnLongPress,
        messageDetail: widget.messageDetail!,
        size: _size,
      );
    }
  }
}
