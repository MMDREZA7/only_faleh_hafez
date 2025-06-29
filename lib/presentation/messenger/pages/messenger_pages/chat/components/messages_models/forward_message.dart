import 'package:faleh_hafez/domain/models/message_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ForwardMessage extends StatefulWidget {
  void Function() handleOnLongPress;
  MessageDTO messageDetail;
  Size size;

  ForwardMessage({
    super.key,
    required this.handleOnLongPress,
    required this.messageDetail,
    required this.size,
  });

  @override
  State<ForwardMessage> createState() => _ForwardMessageState();
}

class _ForwardMessageState extends State<ForwardMessage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.handleOnLongPress(),
      child: Container(
        padding: const EdgeInsets.only(
            // right: kDefaultPadding * 0.75,
            ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 8,
                bottom: 5,
                top: 5,
                right: 10,
              ),
              child: Text(
                widget.messageDetail.forwardedFromDisplayName != null
                    ? 'Forwarded from ${widget.messageDetail.forwardedFromDisplayName}'
                    : "Forwarded from Unknown",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
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
                const SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.check,
                  size: 17,
                  color: widget.messageDetail.isRead == true
                      ? Colors.blue
                      : Theme.of(context).colorScheme.secondary,
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
                    color: Theme.of(context).primaryColor,
                    fontSize: 10,
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
