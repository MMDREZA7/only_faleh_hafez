import 'package:faleh_hafez/Service/APIService.dart';
import 'package:faleh_hafez/application/chat_theme_changer/chat_theme_changer_bloc.dart';
import 'package:faleh_hafez/domain/models/group_chat_dto.dart';
import 'package:faleh_hafez/domain/models/message_dto.dart';
import 'package:faleh_hafez/domain/models/user_chat_dto.dart';
import 'package:faleh_hafez/presentation/messenger/pages/messenger_pages/chat/components/file_message.dart';
import '../../../../../../application/messaging/bloc/messaging_bloc.dart';
import '../../../../../core/empty_view.dart';
import '../../../../../core/failure_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/chat_message_for_show.dart';
import 'chat_input_field.dart';
import 'chat_page_shimmer_loading.dart';
import 'message.dart';

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
      builder: (context, state) {
        if (state is ChatThemeChangerLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ChatThemeChangerLoaded) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: state.theme,
            home: Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
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

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: widget.messages.length,
                itemBuilder: (context, index) {
                  if (widget.messages[index]!.attachFile != null) {
                    return FileMessage(
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
                    );
                  }

                  return Message(
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
