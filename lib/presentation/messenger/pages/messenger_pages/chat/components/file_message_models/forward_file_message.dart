import 'package:Faleh_Hafez/application/messaging/bloc/messaging_bloc.dart';
import 'package:Faleh_Hafez/constants.dart';
import 'package:Faleh_Hafez/domain/models/message_dto.dart';
import 'package:Faleh_Hafez/domain/models/user.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/components/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Faleh_Hafez/application/chat_theme_changer/chat_theme_changer_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForwardFileMessage extends StatefulWidget {
  void Function() handleOnPressMessage;
  MessageDTO messageDetail;
  Size size;
  ChatThemeChangerState themeState;
  User userProfile;

  ForwardFileMessage({
    super.key,
    required this.handleOnPressMessage,
    required this.messageDetail,
    required this.size,
    required this.themeState,
    required this.userProfile,
  });

  @override
  State<ForwardFileMessage> createState() => _ForwardFileMessageState();
}

class _ForwardFileMessageState extends State<ForwardFileMessage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.handleOnPressMessage(),
      child: Container(
        width: widget.size.width * 0.55,
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding * 0.75,
          vertical: kDefaultPadding / 2.5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: widget.themeState.theme.colorScheme.onBackground,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  widget.messageDetail.forwardedFromDisplayName != null
                      ? 'Forwarded from ${widget.messageDetail.forwardedFromDisplayName}'
                      : "Forwarded from Unknown",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: widget.themeState.theme.colorScheme.background,
                  ),
                ),
              ],
            ),
            Row(
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
                                  fileID: widget.messageDetail.attachFile!
                                      .fileAttachmentID!,
                                  fileName: widget
                                      .messageDetail.attachFile!.fileName!,
                                  fileSize: widget
                                      .messageDetail.attachFile!.fileSize!,
                                  fileType: widget
                                      .messageDetail.attachFile!.fileType!,
                                  token: widget.userProfile.token!,
                                ),
                              );
                        },
                        icon: Icon(
                          Icons.file_copy,
                          color: widget.messageDetail.senderID ==
                                  widget.userProfile.id
                              ? Colors.grey[500]
                              : Colors.grey[900],
                        ),
                      );
                    },
                  );
                }),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding / 2),
                    child: Text(
                      widget.messageDetail!.attachFile!.fileName!,
                      style: TextStyle(
                        color: widget.themeState.theme.colorScheme.background,
                      ),
                    ),
                  ),
                ),
              ],
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
  }
}
