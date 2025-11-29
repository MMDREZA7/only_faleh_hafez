import 'package:Faleh_Hafez/constants.dart';
import 'package:Faleh_Hafez/domain/models/message_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Faleh_Hafez/application/chat_theme_changer/chat_theme_changer_bloc.dart';

class TextMessageBubble extends StatefulWidget {
  void Function() handleOnPress;
  MessageDTO messageDetail;
  Size size;
  ChatThemeChangerState themeState;

  TextMessageBubble({
    super.key,
    required this.handleOnPress,
    required this.messageDetail,
    required this.size,
    required this.themeState,
  });

  @override
  State<TextMessageBubble> createState() => _TextMessageBubbleState();
}

class _TextMessageBubbleState extends State<TextMessageBubble> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.handleOnPress,
      child: Container(
        width: widget.messageDetail.text!.length > 500
            ? widget.size.width * .75
            : widget.size.width * .5,
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: kDefaultPadding / 4,
        ),
        decoration: BoxDecoration(
          color: widget.themeState.theme.colorScheme.onBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.messageDetail.forwardedFromDisplayName != null &&
                    widget.messageDetail.forwardedFromDisplayName != ''
                ? Text(
                    widget.messageDetail.forwardedFromDisplayName != null
                        ? 'Forwarded from ${widget.messageDetail.forwardedFromDisplayName}'
                        : "Forwarded from Unknown",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'iranSans',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: widget.themeState.theme.colorScheme.background,
                    ),
                  )
                : Text(
                    widget.messageDetail.senderDisplayName ??
                        widget.messageDetail.senderMobileNumber ??
                        '',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'iranSans',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: widget.themeState.theme.colorScheme.background,
                    ),
                  ),
            widget.messageDetail.replyToMessageID != null &&
                    widget.messageDetail.replyToMessageID != ''
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: widget.themeState.theme.colorScheme.secondary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.messageDetail.senderDisplayName}",
                              style: TextStyle(
                                fontFamily: 'iranSans',
                                fontSize: 8,
                                color: widget
                                    .themeState.theme.colorScheme.onSecondary,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              'Reply to: ${widget.messageDetail.replyToMessageText!.length > 20 ? "${widget.messageDetail.replyToMessageText!.substring(0, 12)} ..." : widget.messageDetail.replyToMessageText!}',
                              style: TextStyle(
                                fontFamily: 'iranSans',
                                color: widget
                                    .themeState.theme.colorScheme.onSecondary,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const Center(),
            const SizedBox(
              height: 25,
            ),
            // Prepare message text and detect if it contains RTL (Persian/Arabic) chars
            Builder(builder: (context) {
              final rawMsg = widget.messageDetail.text!
                  .replaceAll(RegExp(r'(?<!\n)\n(?!\n)'), '');
              final isRtl = RegExp(r'[\u0600-\u06FF]').hasMatch(rawMsg);

              return Container(
                color: Colors.transparent,
                constraints: BoxConstraints(maxWidth: widget.size.width * .75),
                child: Directionality(
                  textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                  child: Text(
                    rawMsg,
                    textAlign: isRtl ? TextAlign.right : TextAlign.left,
                    softWrap: true,
                    style: TextStyle(
                      fontFamily: 'iranSans',
                      color: widget.themeState.theme.colorScheme.background,
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(
              height: 25,
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
                  widget.messageDetail.sentDateTime != null
                      ? widget.messageDetail.sentDateTime!
                          .split('.')[0]
                          .split("T")[1]
                      : '',
                  style: TextStyle(
                    fontFamily: 'iranSans',
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
                      fontFamily: 'iranSans',
                      fontSize: 10,
                      color: widget.themeState.theme.colorScheme.secondary,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
