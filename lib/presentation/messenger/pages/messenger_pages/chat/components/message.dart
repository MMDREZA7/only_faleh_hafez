import 'dart:typed_data';

import 'package:Faleh_Hafez/Service/APIService.dart';
import 'package:Faleh_Hafez/application/authentiction/authentication_bloc.dart';
import 'package:Faleh_Hafez/application/chat_theme_changer/chat_theme_changer_bloc.dart';
import 'package:Faleh_Hafez/application/messaging/bloc/messaging_bloc.dart';
import 'package:Faleh_Hafez/domain/models/group_chat_dto.dart';
import 'package:Faleh_Hafez/domain/models/message_dto.dart';
import 'package:Faleh_Hafez/domain/models/user.dart';
import 'package:Faleh_Hafez/domain/models/user_chat_dto.dart';
import 'package:Faleh_Hafez/presentation/messenger/group_profile/edit_group_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swipe_to/swipe_to.dart';

import '../models/chat_message_for_show.dart';
import 'text_message.dart';

class Message extends StatelessWidget {
  final MessageDTO messageDetail;
  final UserChatItemDTO userChatItem;
  final GroupChatItemDTO groupChatItem;
  final ChatMessageForShow message;
  final bool isGuest;
  final String? image;
  final bool isReply;
  ChatThemeChangerState themeState;
  // final String imageDownloaded;

  Message({
    super.key,
    required this.message,
    required this.userChatItem,
    required this.groupChatItem,
    required this.isGuest,
    required this.image,
    required this.messageDetail,
    required this.isReply,
    required this.themeState,
    // required this.imageDownloaded,
  });

  @override
  Widget build(BuildContext context) {
    User userProfile = User(
      id: box.get("userID"),
      mobileNumber: box.get("userMobile"),
      token: box.get("userToken"),
    );

    Future<Uint8List?> _loadUserImage() async {
      String? imageId;
      String? myImageID;

      if (groupChatItem.id.isNotEmpty) {
        imageId = groupPhoto;
      } else {
        imageId = userChatItem.participant1ID == userProfile.id
            ? userChatItem.participant2ProfileImage
            : userChatItem.participant1ProfileImage;
      }
      myImageID = userProfile.profileImage;

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

    Widget messageContaint(
      ChatMessageForShow message,
      UserChatItemDTO userChatItemDTO,
      GroupChatItemDTO groupChatItemDTO,
    ) {
      if (isReply) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextMessage(
                themeState: themeState,
                message: message,
                messageDetail: messageDetail,
              ),
            ],
          ),
        );
      }
      return SwipeTo(
        key: UniqueKey(),
        iconOnLeftSwipe: Icons.reply,
        iconColor: themeState.theme.colorScheme.onBackground,
        offsetDx: 0.75,
        swipeSensitivity: 5,
        onLeftSwipe: (details) {
          context.read<MessagingBloc>().add(
                MessagingReplyMessageEvent(
                  message: messageDetail,
                ),
              );
        },
        animationDuration: const Duration(milliseconds: 150),
        child: TextMessage(
          themeState: themeState,
          message: message,
          messageDetail: messageDetail,
        ),
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
                    // backgroundColor: themeState.colorScheme.onSecondary,
                    radius: 20,
                    child: Icon(
                      groupChatItem.id != '' ? Icons.group : Icons.person,
                      // color: themeState.colorScheme.primary,
                      size: 20,
                    ),
                  );
                }
                return imageWidget;
              },
            ),
            const SizedBox(width: 25 / 2),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
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
              messageContaint(message, userChatItem, groupChatItem),
            ],
          ),
          if (message.isSender!)
            MessageStatusDot(
              status: message.messageStatus,
              themestate: themeState,
            )
        ],
      ),
    );
  }
}

class MessageStatusDot extends StatelessWidget {
  ChatThemeChangerState themestate;
  final MessageStatus? status;

  MessageStatusDot({
    Key? key,
    this.status,
    required this.themestate,
  }) : super(key: key);
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
        color: themestate.theme.scaffoldBackgroundColor,
      ),
    );
  }
}
