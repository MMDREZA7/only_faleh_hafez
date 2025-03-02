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
          items: const [
            PopupMenuItem(
              value: "Hello",
              child: Text("Hello"),
            ),
            PopupMenuItem(
              value: "Hi",
              child: Text("Hi"),
            ),
            PopupMenuItem(
              value: "Namaste",
              child: Text("Namaste"),
            ),
            PopupMenuItem(
              value: "Salam",
              child: Text("Salam"),
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
