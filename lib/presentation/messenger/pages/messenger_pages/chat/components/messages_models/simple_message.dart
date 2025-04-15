import 'package:faleh_hafez/constants.dart';
import 'package:faleh_hafez/domain/models/message_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SimpleMessage extends StatefulWidget {
  void Function() handleOnLongPress;
  MessageDTO messageDetail;
  Size size;

  SimpleMessage({
    super.key,
    required this.handleOnLongPress,
    required this.messageDetail,
    required this.size,
  });

  @override
  State<SimpleMessage> createState() => _SimpleMessageState();
}

class _SimpleMessageState extends State<SimpleMessage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => widget.handleOnLongPress(),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding * 0.50,
          vertical: kDefaultPadding / 4,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.messageDetail.senderDisplayName ??
                  widget.messageDetail.senderMobileNumber!,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.background,
              ),
            ),
            Container(
              color: Colors.transparent,
              width: widget.size.width * .3,
              child: Center(
                child: Text(
                  widget.messageDetail.text!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.check,
                  size: 17,
                  color: widget.messageDetail!.isRead == true
                      ? Colors.blue
                      : Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  // widget.messageDetail!.sentDateTime!.split('T')[0] +
                  //     ' | ' +
                  widget.messageDetail!.sentDateTime!
                      .split('.')[0]
                      .split("T")[1],
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
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
                      color: Theme.of(context).colorScheme.secondary,
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
        //         : Theme.of(context).textTheme.bodyText1!.color,
        //   ),
        // ),
      ),
    );
  }
}
