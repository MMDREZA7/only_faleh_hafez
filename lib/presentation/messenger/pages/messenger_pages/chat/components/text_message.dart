import 'package:flutter/material.dart';

import '../../../../../../constants.dart';
import '../models/chat_message_for_show.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    super.key,
    this.message,
  });

  final ChatMessageForShow? message;

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return GestureDetector(
      onLongPress: () {
        showMenu(
          context: context,
          position: RelativeRect.fill,
          items: [
            PopupMenuItem(
              enabled: false,
              value: message?.text,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${message!.text.length < 20 ? message?.text : '${message!.text.substring(0, 20)} ...'}',
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
            const PopupMenuItem(
              value: "reply",
              child: Row(
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
                print("Hello");
              },
              value: "forward",
              child: Row(
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
            const PopupMenuItem(
              value: "edit",
              child: Row(
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
            const PopupMenuItem(
              value: "delete",
              child: Row(
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
              // Handle the selected value
              print("Selected: $value");
            }
          },
        );
      },
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
          children: [
            Text(
              "Sender's Name",
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).colorScheme.background,
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
                  message!.text,
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
