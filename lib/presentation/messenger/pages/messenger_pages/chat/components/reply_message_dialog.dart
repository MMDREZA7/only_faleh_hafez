import 'package:faleh_hafez/Service/APIService.dart';
import 'package:faleh_hafez/application/messaging/bloc/messaging_bloc.dart';
import 'package:faleh_hafez/domain/models/message_dto.dart';
import 'package:faleh_hafez/domain/models/user.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ReplyMessageDialog extends StatefulWidget {
  MessageDTO message;
  String token;

  ReplyMessageDialog({
    super.key,
    required this.message,
    required this.token,
  });

  @override
  State<ReplyMessageDialog> createState() => _ReplyMessageDialogState();
}

class _ReplyMessageDialogState extends State<ReplyMessageDialog> {
  final TextEditingController _replyMessageController = TextEditingController();
  final FocusNode _replyMessageFocusNode = FocusNode();

  var userProfile = User(
    id: '',
    displayName: '',
    mobileNumber: '',
    profileImage: '',
    token: '',
    type: UserType.Guest,
  );

  @override
  void initState() {
    super.initState();
    var box = Hive.box('mybox');

    userProfile = User(
      id: box.get('userID'),
      displayName: box.get('userName'),
      mobileNumber: box.get('userMobile'),
      profileImage: box.get('userImage'),
      token: box.get('userToken'),
      type: userTypeConvertToEnum[box.get('userType')],
    );
  }

  void replyMessage(MessageDTO message, String token) {
    var correctReceiverID = '';
    if (userProfile.id == widget.message.senderID) {
      correctReceiverID = widget.message.receiverID!;
    } else {
      correctReceiverID = widget.message.senderID!;
    }

    APIService().sendMessage(
      token: token,
      receiverID: correctReceiverID,
      fileAttachmentID: null,
      text: _replyMessageController.text,
      replyToMessageID: message.messageID,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // backgroundColor: Theme.of(context).colorScheme.background,
      backgroundColor: Colors.transparent,

      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(vertical: 150),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Theme.of(context).colorScheme.onSecondary,
            width: 3,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Reply Message',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const Expanded(child: Center()),
            Text(
              "Reply to '${widget.message.text!.length < 20 ? widget.message.text : '${widget.message.text!.substring(0, 20)} ...'}'",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                focusNode: _replyMessageFocusNode,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                controller: _replyMessageController,
              ),
            ),
            const Expanded(child: Center()),
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        replyMessage(widget.message, widget.token);

                        // try {
                        //   await APIService().editMessage(
                        //     token: widget.token,
                        //     messageID: widget.message.messageID,
                        //     text: _replyMessageController.text,
                        //   );
                        // } catch (e) {
                        //   context.showErrorBar(
                        //     content: Text(e.toString()),
                        //   );
                        // }

                        _replyMessageController.clear();
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Reply Message',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        _replyMessageController.clear();
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel Reply',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
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
