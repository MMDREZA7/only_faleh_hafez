import 'package:faleh_hafez/Service/APIService.dart';
import 'package:faleh_hafez/application/messaging/bloc/messaging_bloc.dart';
import 'package:faleh_hafez/domain/models/message_dto.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditMessageDialog extends StatefulWidget {
  MessageDTO message;
  String token;

  EditMessageDialog({
    super.key,
    required this.message,
    required this.token,
  });

  @override
  State<EditMessageDialog> createState() => _EditMessageDialogState();
}

class _EditMessageDialogState extends State<EditMessageDialog> {
  late TextEditingController _editMessageController;

  @override
  void initState() {
    super.initState();

    _editMessageController = TextEditingController(text: widget.message.text);

    print(widget.message.text);
  }

  @override
  void dispose() {
    _editMessageController.dispose();
    super.dispose();
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
                  'Edit Message',
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
              "Edit Message ${widget.message.text}",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            // Text(
            //   "Reply to '${widget.text.length < 20 ? widget.text : '${widget.text.substring(0, 20)} ...'}'",
            //   style: TextStyle(
            //     color: Theme.of(context).colorScheme.onBackground,
            //   ),
            // ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                controller: _editMessageController,
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
                        try {
                          await APIService().editMessage(
                            token: widget.token,
                            messageID: widget.message.messageID,
                            text: _editMessageController.text,
                          );

                          context.read<MessagingBloc>().add(
                                MessagingGetMessages(
                                  chatID: widget.message.chatID!,
                                  token: widget.token,
                                ),
                              );
                        } catch (e) {
                          context.showErrorBar(
                            content: Text(e.toString()),
                          );
                        }

                        _editMessageController.clear();
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Edit Message',
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
                        print("Your Mesage is ${_editMessageController.text}");

                        _editMessageController.clear();
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel Edit',
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
