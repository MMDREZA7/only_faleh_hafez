import 'package:Faleh_Hafez/constants.dart';
import 'package:Faleh_Hafez/domain/models/message_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Faleh_Hafez/application/chat_theme_changer/chat_theme_changer_bloc.dart';

class SimpleMessage extends StatefulWidget {
  void Function() handleOnLongPress;
  MessageDTO messageDetail;
  Size size;
  ChatThemeChangerState themeState;

  SimpleMessage({
    super.key,
    required this.handleOnLongPress,
    required this.messageDetail,
    required this.size,
    required this.themeState,
  });

  @override
  State<SimpleMessage> createState() => _SimpleMessageState();
}

class _SimpleMessageState extends State<SimpleMessage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.handleOnLongPress(),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding * 0.50,
          vertical: kDefaultPadding / 4,
        ),
        decoration: BoxDecoration(
          color: widget.themeState.theme.colorScheme.onBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.messageDetail.senderDisplayName ??
                  widget.messageDetail.senderMobileNumber ??
                  '',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: widget.themeState.theme.colorScheme.background,
              ),
            ),
            Container(
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
                  widget.messageDetail.sentDateTime != null
                      ? widget.messageDetail.sentDateTime!
                          .split('.')[0]
                          .split("T")[1]
                      : '',
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
                    widget.messageDetail!.isEdited == true ? "Edited" : '',
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
        // child: Text(
        //   message!.text,
        //   style: TextStyle(
        //     color: message!.isSender
        //         ? Colors.white
        //         : widget.themeState.theme.textTheme.bodyText1!.color,
        //   ),
        // ),
      ),
    );
  }
}
