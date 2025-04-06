import 'package:faleh_hafez/domain/models/massage_dto.dart';
import 'package:flutter/material.dart';

import '../models/chat_message_for_show.dart';
import 'text_message.dart';

class Message extends StatelessWidget {
  final MessageDTO messageDetail;
  final ChatMessageForShow message;
  final bool isGuest;
  final String? image;

  const Message({
    Key? key,
    required this.message,
    required this.isGuest,
    required this.image,
    required this.messageDetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget messageContaint(ChatMessageForShow message) {
      return TextMessage(
        message: message,
        messageDetail: messageDetail,
      );

      // switch (message.messageType) {
      //   case MessageMode.text:
      //     return TextMessage(message: message);
      //   // case MessageMode.file:
      //   //   return FileMessage(message: message);
      //   // case MessageMode.audio:
      //   //   return AudioMessage(message: message);
      //   // case MessageMode.video:
      //   //   return VideoMessage();
      //   default:
      //     return SizedBox();
      // }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Row(
        mainAxisAlignment:
            message.isSender! ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isSender!) ...[
            const CircleAvatar(
              child: Icon(Icons.person),
            ),
            const SizedBox(width: 25 / 2),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // if (message.isSender)
              //   BlocBuilder<MessagingBloc, MessagingState>(
              //     builder: (context, state) {
              //       return IconButton(
              //         onPressed: () {
              //           context
              //               .read<MessagingBloc>()
              //               .add(MessagingDeleteMessage(messageID: message.id));
              //         },
              //         icon: const Icon(
              //           Icons.delete,
              //           color: Colors.red,
              //           size: 20,
              //         ),
              //       );
              //     },
              //   ),
              messageContaint(message),
            ],
          ),
          if (message.isSender!) MessageStatusDot(status: message.messageStatus)
        ],
      ),
    );
  }
}

class MessageStatusDot extends StatelessWidget {
  final MessageStatus? status;

  const MessageStatusDot({Key? key, this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color dotColor(MessageStatus status) {
      switch (status) {
        case MessageStatus.not_sent:

          // TODO
          // TODO
          return Colors.black;
        case MessageStatus.not_view:
        // return Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.1);
        case MessageStatus.viewed:
          return Colors.white;
        // TODO
        // TODO

        default:
          return Colors.transparent;
      }
    }

    return Container(
      margin: const EdgeInsets.only(left: 25 / 2),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: dotColor(status!),
        shape: BoxShape.circle,
      ),
      child: Icon(
        status == MessageStatus.not_sent ? Icons.close : Icons.done,
        size: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
