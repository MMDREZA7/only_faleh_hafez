import 'package:Faleh_Hafez/Service/APIService.dart';
import 'package:Faleh_Hafez/Service/signal_r/SignalR_Service.dart';
import 'package:Faleh_Hafez/application/chat_theme_changer/chat_theme_changer_bloc.dart';
import 'package:Faleh_Hafez/domain/models/group_chat_dto.dart';
import 'package:Faleh_Hafez/domain/models/message_dto.dart';
import 'package:Faleh_Hafez/domain/models/user_chat_dto.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/components/file_message.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/components/voice_message/simple_voice_message.dart';
import '../../../../../../application/messaging/bloc/messaging_bloc.dart';
import '../../../../../core/empty_view.dart';
import '../../../../../core/failure_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/chat_message_for_show.dart';
import 'chat_input_field.dart';
import 'chat_page_shimmer_loading.dart';
import 'message.dart';
import 'package:swipe_to/swipe_to.dart';

class ChatPageMessagesListView extends StatelessWidget {
  final String hostPublicID, guestPublicID;
  final bool isGuest;
  final bool isNewChat;
  final String myID;
  final String? image;
  final String token;
  final UserChatItemDTO userChatItemDTO;
  final GroupChatItemDTO groupChatItemDTO;
  final MessageDTO message;
  final ScrollController scrollController = ScrollController();

  ChatPageMessagesListView({
    super.key,
    required this.hostPublicID,
    required this.guestPublicID,
    required this.isGuest,
    required this.isNewChat,
    required this.myID,
    required this.userChatItemDTO,
    required this.groupChatItemDTO,
    required this.token,
    required this.message,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatThemeChangerBloc, ChatThemeChangerState>(
      builder: (context, themeState) {
        if (themeState is ChatThemeChangerLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (themeState is ChatThemeChangerLoaded) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: themeState.theme.colorScheme.background,
              body: BlocBuilder<MessagingBloc, MessagingState>(
                builder: (context, state) {
                  if (state is MessagingInitial) {
                    return Column(
                      children: [
                        const Expanded(
                          child: EmptyView(message: 'No Messages Yet'),
                        ),
                        ChatInputField(
                          message: message,
                          guestPublicID: guestPublicID,
                          hostPublicID: hostPublicID,
                          isGuest: isGuest,
                          isNewChat: isNewChat,
                          userChatItemDTO: userChatItemDTO,
                          groupChatItemDTO: groupChatItemDTO,
                          receiverID: myID == userChatItemDTO.participant1ID
                              ? userChatItemDTO.participant2ID
                              : userChatItemDTO.participant1ID,
                          token: token,
                          // scrollControllerForMessagesList: scrollController,
                        ),
                      ],
                    );
                  }
                  if (state is MessagingError) {
                    return BlocProvider(
                      create: (context) => context.read<ChatThemeChangerBloc>()
                        ..add(FirstTimeOpenChat()),
                      // ChatThemeChangerBloc()..add(FirstTimeOpenChat()),
                      child: FailureView(
                        message: state.errorMessage.contains("Bad Request")
                            ? "درخواست شما قابل اجرا نمی باشد"
                            : state.errorMessage,
                        onTapTryAgain: () => context.read<MessagingBloc>()
                          ..add(
                            MessagingGetMessages(
                              chatID: userChatItemDTO.id,
                              token: token,
                            ),
                          ),
                      ),
                    );
                  }
                  if (state is MessagingLoadEmpty) {
                    return Column(
                      children: [
                        const Expanded(
                          child: EmptyView(message: 'No Messages Yet'),
                        ),
                        ChatInputField(
                          message: message,
                          guestPublicID: guestPublicID,
                          hostPublicID: hostPublicID,
                          isGuest: isGuest,
                          isNewChat: isNewChat,
                          groupChatItemDTO: GroupChatItemDTO.empty(),
                          userChatItemDTO: UserChatItemDTO.empty(),
                          receiverID: myID == userChatItemDTO.participant1ID
                              ? userChatItemDTO.participant2ID
                              : userChatItemDTO.participant1ID,
                          token: token,
                          // scrollControllerForMessagesList: scrollController,
                        ),
                      ],
                    );
                  }
                  if (state is MessagingLoading) {
                    return const ChatsPageShimmerLoading();
                  }
                  if (state is MessagingLoaded) {
                    return _loadSuccessView(
                      messages: state.messages,
                      message: message,
                      isGuest: isGuest,
                      hostPublicID: hostPublicID,
                      guestPublicID: guestPublicID,
                      image: image,
                      myID: myID,
                      isNewChat: isNewChat,
                      userChatItemDTO: userChatItemDTO,
                      groupChatItemDTO: groupChatItemDTO,
                      token: token,
                      themeState: themeState,
                    );
                  }
                  return const Center(
                    child: Text('Some error happened.'),
                  );
                },
              ),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class _loadSuccessView extends StatefulWidget {
  final List<MessageDTO?> messages;
  final bool isGuest;
  final bool isNewChat;
  final String hostPublicID;
  final String guestPublicID;
  // final ScrollController scrollController;
  final String? image;
  final String myID;
  final String token;
  final UserChatItemDTO userChatItemDTO;
  final GroupChatItemDTO groupChatItemDTO;
  final MessageDTO message;
  ChatThemeChangerState themeState;

  _loadSuccessView({
    Key? key,
    required this.messages,
    required this.isGuest,
    required this.isNewChat,
    required this.hostPublicID,
    required this.guestPublicID,
    // required this.scrollController,
    required this.myID,
    required this.token,
    required this.userChatItemDTO,
    required this.groupChatItemDTO,
    required this.message,
    this.image,
    required this.themeState,
  }) : super(key: key);

  @override
  State<_loadSuccessView> createState() => _loadSuccessViewState();
}

class _loadSuccessViewState extends State<_loadSuccessView> {
  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    void _scrollToBottom() async {
      if (_scrollController.hasClients) {
        // sleep(
        //   const Duration(
        //     milliseconds: 100,
        //   ),
        // );
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 800),
          curve: Curves.linearToEaseOut,
        );
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    Future<List<int>> getVoiceFile(String fileID) async {
      return await APIService().downloadFile(
        id: fileID,
        token: widget.token,
      );
    }

    return Scaffold(
      backgroundColor: widget.themeState.theme.colorScheme.background,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: widget.messages.length,
                itemBuilder: (context, index) {
                  if (widget.messages[index]?.attachFile?.fileName
                          ?.split('.')
                          .last ==
                      'aac') {
                    if (widget.messages[index]?.attachFile == null ||
                        widget.messages[index]?.attachFile!.fileName == null) {
                      return const SizedBox.shrink();
                    }
                    return SwipeTo(
                      iconOnLeftSwipe: Icons.reply,
                      iconColor:
                          widget.themeState.theme.colorScheme.onBackground,
                      offsetDx: 0.75,
                      swipeSensitivity: 5,
                      onLeftSwipe: (details) {
                        context.read<MessagingBloc>().add(
                              MessagingReplyMessageEvent(
                                message: widget.message,
                              ),
                            );
                      },
                      child: FutureBuilder<List<int>>(
                        future: getVoiceFile(widget
                            .messages[index]!.attachFile!.fileAttachmentID!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            if (widget.messages[index]?.replyToMessageID !=
                                    '' &&
                                widget.messages[index]?.replyToMessageID !=
                                    null &&
                                widget.messages[index]?.replyToMessageText !=
                                    '' &&
                                widget.messages[index]?.replyToMessageText !=
                                    '') {
                              return VoiceMessageBubble(
                                themeState: widget.themeState.theme,
                                audioBytes: snapshot.data!,
                                isMessage: true,
                                message: widget.messages[index],
                              );
                            }
                            return VoiceMessageBubble(
                              themeState: widget.themeState.theme,
                              audioBytes: snapshot.data!,
                              isMessage: true,
                              message: widget.messages[index],
                            );
                          }
                          return const Padding(
                            padding: EdgeInsets.all(8),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  if (widget.messages[index]!.attachFile?.fileAttachmentID !=
                      null) {
                    return SwipeTo(
                      key: UniqueKey(),
                      iconOnLeftSwipe: Icons.reply,
                      iconColor:
                          widget.themeState.theme.colorScheme.onBackground,
                      offsetDx: 0.75,
                      swipeSensitivity: 5,
                      onLeftSwipe: (details) {
                        context.read<MessagingBloc>().add(
                              MessagingReplyMessageEvent(
                                message: widget.message,
                              ),
                            );
                      },
                      child: FileMessage(
                        themeState: widget.themeState,
                        messageDto: widget.messages[index],
                        message: ChatMessageForShow(
                          id: 0,
                          messageStatus: MessageStatus.viewed,
                          isSender:
                              widget.messages[index]!.senderID == widget.myID,
                          text: widget.messages[index]!.text!,
                          messageMode: MessageMode.file,
                        ),
                        token: widget.token,
                      ),
                    );
                  }

                  return Message(
                    themeState: widget.themeState,
                    isReply: false,
                    userChatItem: widget.userChatItemDTO,
                    groupChatItem: widget.groupChatItemDTO,
                    messageDetail: widget.messages[index]!,
                    isGuest: widget.messages[index]!.receiverID == widget.myID,
                    image: widget.image,
                    message: ChatMessageForShow(
                      messageMode: widget.message.text != ''
                          ? MessageMode.file
                          : MessageMode.text,
                      id: 0,
                      // messages[index]!.id,
                      messageStatus: MessageStatus.viewed,
                      isSender: widget.messages[index]!.senderID == widget.myID,
                      text: widget.messages[index]!.text!,
                    ),
                  );
                },
              ),
            ),
          ),
          ChatInputField(
            message: widget.message,
            guestPublicID: widget.guestPublicID,
            hostPublicID: widget.hostPublicID,
            isGuest: widget.isGuest,
            isNewChat: widget.isNewChat,
            userChatItemDTO: widget.userChatItemDTO,
            groupChatItemDTO: widget.groupChatItemDTO,
            receiverID: widget.myID == widget.userChatItemDTO.participant1ID
                ? widget.userChatItemDTO.participant2ID
                : widget.userChatItemDTO.participant1ID,
            token: widget.token,
            // scrollControllerForMessagesList: scrollController,
          ),
        ],
      ),
    );
  }
}
