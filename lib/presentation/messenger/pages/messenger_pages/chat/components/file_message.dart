import 'package:Faleh_Hafez/Service/APIService.dart';
import 'package:Faleh_Hafez/Service/signal_r/SignalR_Service.dart';
import 'package:Faleh_Hafez/application/chat_theme_changer/chat_theme_changer_bloc.dart';
import 'package:Faleh_Hafez/application/messaging/bloc/messaging_bloc.dart';
import 'package:Faleh_Hafez/constants.dart';
import 'package:Faleh_Hafez/domain/models/message_dto.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/components/file_message_models/forward_file_message.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/components/file_message_models/reply_file_message.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/components/file_message_models/simple_file_message.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/components/forward_modal_sheet.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/chat_message_for_show.dart';

class FileMessage extends StatefulWidget {
  final ChatMessageForShow? message;
  final MessageDTO? messageDto;
  final String token;
  ChatThemeChangerState themeState;

  FileMessage({
    super.key,
    this.message,
    this.messageDto,
    required this.token,
    required this.themeState,
  });

  @override
  State<FileMessage> createState() => _FileMessageState();
}

class _FileMessageState extends State<FileMessage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void safeAddEvent(MessagingEvent event) {
      final bloc = context.read<MessagingBloc>();
      if (!bloc.isClosed) {
        bloc.add(event);
      } else {
        debugPrint("MessagingBloc is closed. Event not added.");
      }
    }

    void handleOnPressMessage() {
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
                    fontFamily: 'iranSans',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: widget.themeState.theme.colorScheme.primary,
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
              //     message: widget.messageDto!,
              //     token: userProfile.token!,
              //   ),
              // );
              if (context.read<MessagingBloc>().isClosed) {
                return;
              } else {
                // var correctReceiverID = '';
                // if (userProfile.id == widget.messageDto!.senderID &&
                //     widget.messageDto!.receiverID != null) {
                //   correctReceiverID = widget.messageDto!.receiverID!;
                // } else {
                //   correctReceiverID = widget.messageDto!.senderID!;
                // }
                var message = widget.messageDto!;
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
          // PopupMenuItem(
          //   onTap: () {
          //     ClipboardData(
          //       text: widget.message!.text,
          //     );
          //     context.showInfoBar(
          //         content: Text(
          //             "'${widget.message!.text.length < 20 ? widget.message?.text : '${widget.message!.text.substring(0, 20)} ...'}' Copied!"));
          //   },
          //   value: "copy",
          //   child: const Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text("Copy"),
          //       SizedBox(
          //         width: 5,
          //       ),
          //       Icon(Icons.copy),
          //     ],
          //   ),
          // ),
          PopupMenuItem(
            onTap: () async {
              // ignore: use_build_context_synchronously
              await showModalBottomSheet(
                  backgroundColor: widget.themeState.theme.colorScheme.primary,
                  context: context,
                  builder: (context) => ForwardModalSheet(
                        message: widget.messageDto!,
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
          // PopupMenuItem(
          //   onTap: () async {
          //     try {
          //       if (widget.messageDto!.senderID == userProfile.id) {
          //         context.read<MessagingBloc>().add(
          //               MessagingEditMessageEvent(
          //                 message: widget.messageDto!,
          //                 token: userProfile.token!,
          //               ),
          //               // MessagingEnterEditMode(
          //               //   message: widget.messageDto!,

          //               // ),
          //             );
          //       } else {
          //         return;
          //       }
          //     } catch (e) {
          //       context.showErrorBar(
          //         content: Text(
          //           e.toString(),
          //         ),
          //       );
          //     }
          //     // // }
          //   },
          //   value: "edit",
          //   child: const Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text("Edit"),
          //       SizedBox(
          //         width: 5,
          //       ),
          //       Icon(Icons.edit),
          //     ],
          //   ),
          // ),

          PopupMenuItem(
            onTap: () async {
              try {
                await APIService().deleteMessage(
                  token: userProfile.token!,
                  messageID: widget.messageDto!.messageID,
                );
                context.read<MessagingBloc>().add(
                      MessagingDeleteMessageSignalR(
                        // chatID: widget.messageDto!.chatID ??
                        //     widget.messageDto!.groupID!,
                        message: widget.messageDto!,
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

    Size _size = MediaQuery.of(context).size;

    if (widget.messageDto!.forwardedFromID != null &&
        widget.messageDto!.forwardedFromID != '') {
      return ForwardFileMessage(
        handleOnPressMessage: handleOnPressMessage,
        messageDetail: widget.messageDto!,
        size: _size,
        themeState: widget.themeState,
        userProfile: userProfile,
      );
    }
    if (widget.messageDto!.replyToMessageID != null &&
        widget.messageDto!.replyToMessageID != '') {
      return ReplyFileMessage(
        handleOnPressMessage: handleOnPressMessage,
        messageDetail: widget.messageDto!,
        size: _size,
        themeState: widget.themeState,
        userProfile: userProfile,
      );
    }

    return SimpleFileMessage(
      handleOnPressMessage: handleOnPressMessage,
      messageDetail: widget.messageDto!,
      size: _size,
      themeState: widget.themeState,
      userProfile: userProfile,
    );
  }
}
