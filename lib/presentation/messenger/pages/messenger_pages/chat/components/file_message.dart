import 'package:Faleh_Hafez/application/messaging/bloc/messaging_bloc.dart';
import 'package:Faleh_Hafez/constants.dart';
import 'package:Faleh_Hafez/domain/models/message_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/chat_message_for_show.dart';

class FileMessage extends StatefulWidget {
  final ChatMessageForShow? message;
  final MessageDTO? messageDto;
  final String token;

  const FileMessage({
    super.key,
    this.message,
    this.messageDto,
    required this.token,
  });

  @override
  State<FileMessage> createState() => _FileMessageState();
}

class _FileMessageState extends State<FileMessage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return Container(
      width: _size.width * 0.55,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding * 0.75,
        vertical: kDefaultPadding / 2.5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Theme.of(context).colorScheme.onBackground,
      ),
      child: Row(
        children: [
          Builder(builder: (context) {
            return BlocBuilder<MessagingBloc, MessagingState>(
              builder: (context, state) {
                if (state is MessagingFileLoading) {
                  return const CircularProgressIndicator();
                }
                return IconButton(
                  onPressed: () async {
                    context.read<MessagingBloc>().add(
                          MessagingDownloadFileMessage(
                            fileID: widget
                                .messageDto!.attachFile!.fileAttachmentID!,
                            fileName: widget.messageDto!.attachFile!.fileName!,
                            fileSize: widget.messageDto!.attachFile!.fileSize!,
                            fileType: widget.messageDto!.attachFile!.fileType!,
                            token: widget.token,
                          ),
                        );
                  },
                  icon: Icon(
                    Icons.file_copy,
                    color: widget.message!.isSender!
                        ? Colors.grey[600]
                        : Colors.grey[900],
                  ),
                );
              },
            );
          }),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
              child: Text(
                widget.messageDto!.attachFile!.fileName!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
