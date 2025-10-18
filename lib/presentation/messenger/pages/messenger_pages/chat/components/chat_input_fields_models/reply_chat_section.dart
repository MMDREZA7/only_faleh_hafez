import 'package:Faleh_Hafez/application/authentiction/authentication_bloc.dart';
import 'package:Faleh_Hafez/application/chat_theme_changer/chat_theme_changer_bloc.dart';
import 'package:Faleh_Hafez/application/messaging/bloc/messaging_bloc.dart';
import 'package:Faleh_Hafez/domain/models/message_dto.dart';
import 'package:Faleh_Hafez/domain/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReplyChatSection extends StatefulWidget {
  MessageDTO? message;
  ReplyChatSection({
    super.key,
    this.message,
  });

  @override
  State<ReplyChatSection> createState() => _ReplyChatSectionState();
}

class _ReplyChatSectionState extends State<ReplyChatSection> {
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

    // box.put("userID", '77a16c07-2bba-4706-d059-08dd2cc521d1');
    // box.put("userMobile", '09000000001');
    // box.put(
    //   "userToken",
    //   "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiI3N2ExNmMwNy0yYmJhLTQ3MDYtZDA1OS0wOGRkMmNjNTIxZDEiLCJ1bmlxdWVfbmFtZSI6IjA5MDAwMDAwMDAxIiwibmJmIjoxNzQyMjAzNTc2LCJleHAiOjE3NDIyMTEzNzYsImlhdCI6MTc0MjIwMzU3NiwiaXNzIjoiWW91ckFQSSIsImF1ZCI6IllvdXJBUElVc2VycyJ9.WUmNou6qKBTxMbElVJUBHNsKz2h3TL_1i_AWocwLric",
    // );
    // box.put("userType", 2);

    userProfile = User(
      id: box.get("userID"),
      displayName: box.get("userName"),
      mobileNumber: box.get("userMobile"),
      token: box.get("userToken"),
      type: userTypeConvertToEnum[box.get('userType')]!,

      // !!!!!
      profileImage: null,
      // !!!!!
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatThemeChangerBloc, ChatThemeChangerState>(
      builder: (context, themeState) {
        if (themeState is ChatThemeChangerLoaded) {
          return Container(
            width: double.infinity,
            // padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: themeState.theme.colorScheme.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.reply_rounded,
                    color: themeState.theme.colorScheme.onPrimary,
                    size: 25,
                  ),
                  title: Text(
                    "Reply to ${widget.message?.senderDisplayName != null && widget.message?.senderDisplayName != "" ? widget.message?.senderDisplayName! : "Unknown"}",
                    style: TextStyle(
                      fontFamily: 'iranSans',
                      color: themeState.theme.colorScheme.onPrimary,
                    ),
                  ),
                  subtitle: Text(
                    widget.message!.text!.length > 30
                        ? "${widget.message!.text!.substring(0, 30)}..."
                        : widget.message!.text!,
                    style: TextStyle(
                      fontFamily: 'iranSans',
                      color: themeState.theme.colorScheme.onBackground,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      setState(() {});
                      context.read<MessagingBloc>().add(
                            MessagingGetMessages(
                              chatID: widget.message!.chatID ??
                                  widget.message!.groupID!,
                              token: userProfile.token!,
                            ),
                          );
                    },
                    icon: Icon(
                      Icons.close,
                      color: themeState.theme.colorScheme.onPrimary,
                      size: 25,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Container(
          width: double.infinity,
          // padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
          ),
          child: ListTile(
            leading: Icon(
              Icons.reply_rounded,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 25,
            ),
            title: Text(
              "Reply to ${widget.message?.senderDisplayName != null ? widget.message?.senderDisplayName! : widget.message?.senderMobileNumber}",
              style: TextStyle(
                fontFamily: 'iranSans',
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            subtitle: Text(
              widget.message!.text!,
              style: TextStyle(
                fontFamily: 'iranSans',
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {});
                // context.read<MessagingBloc>().add(
                //       MessagingGetMessages(
                //         chatID: widget.message!.chatID ?? widget.message!.groupID!,
                //         token: userProfile.token!,
                //       ),
                //     );
              },
              icon: Icon(
                Icons.close,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 25,
              ),
            ),
          ),
        );
      },
    );
  }
}
