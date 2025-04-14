import 'package:faleh_hafez/Service/APIService.dart';
import 'package:faleh_hafez/application/messaging/bloc/messaging_bloc.dart';
import 'package:faleh_hafez/domain/models/message_dto.dart';
import 'package:faleh_hafez/presentation/messenger/pages/messenger_pages/chat/components/edit_message_dialog.dart';
import 'package:faleh_hafez/presentation/messenger/pages/messenger_pages/chat/components/reply_message_dialog.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../../../../constants.dart';
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
  String userProfileToken = '';

  @override
  void initState() {
    var box = Hive.box('mybox');
    super.initState();

    userProfileToken = box.get('userToken');
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

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
              showDialog(
                context: context,
                builder: (context) => ReplyMessageDialog(
                  message: widget.messageDetail!,
                  token: userProfileToken,
                ),
              );
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
            onTap: () {
              print("Hello");
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
            onTap: () {
              print("MessageID: ${widget.messageDetail!.messageID}");
              print("MessageText: ${widget.messageDetail!.text}");

              showDialog(
                context: context,
                builder: (context) => EditMessageDialog(
                  message: widget.messageDetail!,
                  token: userProfileToken,
                ),
              );
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
                  token: userProfileToken,
                  messageID: widget.messageDetail!.messageID,
                );
                context.read<MessagingBloc>().add(
                      MessagingGetMessages(
                        chatID: widget.messageDetail!.chatID ??
                            widget.messageDetail!.groupID!,
                        token: userProfileToken,
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

    if (widget.messageDetail?.replyToMessageText != null &&
        widget.messageDetail?.replyToMessageID != null) {
      return GestureDetector(
        onLongPress: () => handleOnLongPress(),
        child: Container(
          // color: MediaQuery.of(context).platformBrightness == Brightness.dark
          //     ? Colors.white
          //     : Colors.black,
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding * 0.75,
            vertical: kDefaultPadding / 4,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onBackground,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 5, bottom: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.messageDetail!.senderDisplayName ??
                              widget.messageDetail!.senderMobileNumber!,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).colorScheme.background,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                child: Text(
                  widget.messageDetail!.replyToMessageText!.length > 20
                      ? "${widget.messageDetail!.replyToMessageText!.substring(0, 12)} ..."
                      : widget.messageDetail!.replyToMessageText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.transparent,
                width: _size.width * .3,
                child: Center(
                  child: Text(
                    widget.message!.text,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // child: Text(
          //   message!.text,
          //   style: TextStyle(
          //     color: message!.isSender
          //         ? Colors.white
          //         : Theme.of(context).textTheme.bodyText1!.color,
          //   ),
          // ),
        ),
      );
    } else {
      return GestureDetector(
        onLongPress: () => handleOnLongPress(),
        child: Container(
          // color: MediaQuery.of(context).platformBrightness == Brightness.dark
          //     ? Colors.white
          //     : Colors.black,
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding * 0.75,
            vertical: kDefaultPadding / 4,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onBackground,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 5, bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.messageDetail!.senderDisplayName ??
                          widget.messageDetail!.senderMobileNumber!,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).colorScheme.background,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.transparent,
                width: _size.width * .3,
                child: Center(
                  child: Text(
                    widget.message!.text,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // child: Text(
          //   message!.text,
          //   style: TextStyle(
          //     color: message!.isSender
          //         ? Colors.white
          //         : Theme.of(context).textTheme.bodyText1!.color,
          //   ),
          // ),
        ),
      );
    }
  }
}
