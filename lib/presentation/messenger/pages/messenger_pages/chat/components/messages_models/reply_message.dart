import 'package:Faleh_Hafez/application/chat_theme_changer/chat_theme_changer_bloc.dart';
import 'package:Faleh_Hafez/domain/models/message_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ReplyMessage extends StatefulWidget {
  void Function() handleOnLongPress;
  MessageDTO messageDetail;
  Size size;
  ChatThemeChangerState themeState;

  ReplyMessage({
    super.key,
    required this.handleOnLongPress,
    required this.messageDetail,
    required this.size,
    required this.themeState,
  });

  @override
  State<ReplyMessage> createState() => _ReplyMessageState();
}

class _ReplyMessageState extends State<ReplyMessage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.handleOnLongPress(),
      child: Container(
        // color: MediaQuery.of(context).platformBrightness == Brightness.dark
        //     ? Colors.white
        //     : Colors.black,
        padding: const EdgeInsets.symmetric(
            // horizontal: kDefaultPadding * 0.75,
            // vertical: kDefaultPadding / 4,
            ),
        decoration: BoxDecoration(
          color: widget.themeState.theme.colorScheme.onBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 12, bottom: 5, top: 3),
              child: Text(
                widget.messageDetail.senderDisplayName ??
                    widget.messageDetail.senderMobileNumber!,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: widget.themeState.theme.colorScheme.background,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: widget.themeState.theme.colorScheme.secondary,
              ),
              child: Row(
                children: [
                  Text('Reply to: '),
                  Text(
                    widget.messageDetail.replyToMessageText!.length > 20
                        ? "${widget.messageDetail.replyToMessageText!.substring(0, 12)} ..."
                        : widget.messageDetail.replyToMessageText!,
                    style: TextStyle(
                      color: widget.themeState.theme.colorScheme.onSecondary,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              color: Colors.transparent,
              width: widget.size.width * .3,
              child: Center(
                child: Text(
                  widget.messageDetail.text!,
                  style: TextStyle(
                    color: widget.themeState.theme.colorScheme.background,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.check,
                  size: 17,
                  color: widget.messageDetail.isRead == true
                      ? Colors.blue
                      : widget.themeState.theme.colorScheme.secondary,
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  // widget.messageDetail!.sentDateTime!.split('T')[0] +
                  //     ' | ' +
                  widget.messageDetail.sentDateTime!
                      .split('.')[0]
                      .split("T")[1],
                  style: TextStyle(
                    color: widget.themeState.theme.primaryColor,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(
                  width: 3,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    widget.messageDetail.isEdited == true ? "Edited" : '',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 10,
                      color: widget.themeState.theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    ;
  }
}
