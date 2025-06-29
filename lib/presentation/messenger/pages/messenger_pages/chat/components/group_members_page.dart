import 'package:faleh_hafez/Service/APIService.dart';
import 'package:faleh_hafez/application/chat_items/chat_items_bloc.dart';
import 'package:faleh_hafez/application/chat_theme_changer/chat_theme_changer_bloc.dart';
import 'package:faleh_hafez/application/messaging/bloc/messaging_bloc.dart';
import 'package:faleh_hafez/domain/models/group_chat_dto.dart';
import 'package:faleh_hafez/domain/models/message_dto.dart';
import 'package:faleh_hafez/domain/models/user.dart';
import 'package:faleh_hafez/domain/models/user_chat_dto.dart';
import 'package:faleh_hafez/presentation/messenger/pages/messenger_pages/chat/chat_page.dart';
import 'package:faleh_hafez/presentation/messenger/pages/messenger_pages/chat/components/add_member_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupMemberspage extends StatefulWidget {
  final String token;
  final String groupID;
  final String adminID;
  final String groupName;
  final User userProfile;

  const GroupMemberspage({
    super.key,
    required this.token,
    required this.groupID,
    required this.adminID,
    required this.groupName,
    required this.userProfile,
  });

  @override
  State<GroupMemberspage> createState() => _GroupMemberspageState();
}

class _GroupMemberspageState extends State<GroupMemberspage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => context.read<ChatItemsBloc>()
        ..add(
          ChatItemsGetGroupMembersEvent(
            token: widget.userProfile.token!,
            groupID: widget.groupID,
          ),
        ),
      child: BlocBuilder<ChatThemeChangerBloc, ChatThemeChangerState>(
        builder: (context, themeState) {
          if (themeState is ChatThemeChangerLoaded) {
            return Scaffold(
              backgroundColor: themeState.theme.colorScheme.background,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: IconButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (dialogContext) => AddMemberDialog(
                          groupID: widget.groupID,
                          groupName: widget.groupName,
                          token: widget.token,
                          afterAdd: () {},
                          // addMemberBloc: context.read<ChatItemsBloc>(),
                        ),
                      ),
                      icon: Icon(
                        Icons.group_add,
                        color: themeState.theme.colorScheme.onBackground,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: IconButton(
                      onPressed: () => context.read<ChatItemsBloc>()
                        ..add(
                          ChatItemsGetGroupMembersEvent(
                            token: widget.userProfile.token!,
                            groupID: widget.groupID,
                          ),
                        ),
                      icon: Icon(
                        Icons.refresh_rounded,
                        color: themeState.theme.colorScheme.onBackground,
                      ),
                    ),
                  ),
                ],
              ),
              body: BlocBuilder<ChatItemsBloc, ChatItemsState>(
                builder: (context, state) {
                  if (state is ChatItemsGroupMembersLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is ChatItemsGroupMembersLoaded) {
                    return Center(
                      child: ListView.builder(
                        itemCount: state.groupMembers.length,
                        itemBuilder: (context, index) {
                          if (state.groupMembers[index].id ==
                              widget.userProfile.id) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: themeState.theme.colorScheme.onPrimary,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: themeState.theme.colorScheme.primary,
                                  width: 2,
                                ),
                              ),
                              child: ListTile(
                                trailing: Text(
                                  userTypeConvertToJson[
                                              state.groupMembers[index].type] ==
                                          2
                                      ? "Admin"
                                      : "",
                                  style: TextStyle(
                                    color:
                                        themeState.theme.colorScheme.onPrimary,
                                  ),
                                ),
                                leading: Icon(
                                  state.groupMembers[index].id == widget.adminID
                                      ? Icons.admin_panel_settings
                                      : Icons.person,
                                  color: themeState.theme.colorScheme.primary,
                                ),
                                title: Text(
                                  "${state.groupMembers[index].mobileNumber} ${state.groupMembers[index].displayName ?? ''}",
                                  style: TextStyle(
                                    color: themeState.theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            );
                          }

                          return GestureDetector(
                            onTap: () async {
                              var receiver = state.groupMembers[index];
                              var sender = widget.userProfile;

                              String receiverID = await APIService().getUserID(
                                mobileNumber: receiver.mobileNumber,
                                token: widget.userProfile.token!,
                              );

                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => MessagingBloc(),
                                    child: ChatPage(
                                      groupChatItemDTO: GroupChatItemDTO(
                                        id: '',
                                        groupName: '',
                                        lastMessageTime: '',
                                        createdByID: '',
                                        profileImage: '',
                                      ),
                                      message: MessageDTO(
                                        attachFile: AttachmentFile(
                                          fileAttachmentID: '',
                                          fileName: '',
                                          fileSize: 0,
                                          fileType: '',
                                        ),
                                        senderID: widget.userProfile.id,
                                        text: '',
                                        chatID: '',
                                        groupID: '',
                                        senderMobileNumber:
                                            widget.userProfile.mobileNumber,
                                        receiverID: receiverID,
                                        receiverMobileNumber:
                                            receiver.mobileNumber,
                                        sentDateTime: '',
                                        receiverDisplayName:
                                            receiver.displayName,
                                        isRead: true,
                                        messageID: '',
                                      ),
                                      token: widget.userProfile.token!,
                                      chatID: '',
                                      hostPublicID: widget.userProfile.id!,
                                      guestPublicID: receiverID,
                                      name: '',
                                      isGuest: true,
                                      myID: widget.userProfile.id!,
                                      userChatItemDTO: UserChatItemDTO(
                                        id: '',
                                        participant1ID: widget.userProfile.id!,
                                        participant1MobileNumber:
                                            widget.userProfile.mobileNumber!,
                                        participant1DisplayName:
                                            widget.userProfile.displayName ??
                                                "Default UserName",
                                        participant2ID: '',
                                        participant2MobileNumber:
                                            receiver.mobileNumber,
                                        participant2DisplayName: '',
                                        lastMessageTime: "",
                                      ),
                                      isNewChat: true,
                                    ),
                                  ),
                                ),
                              );

                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => ChatPage(
                              //       groupChatItemDTO: GroupChatItemDTO(
                              //         id: '',
                              //         groupName: '',
                              //         lastMessageTime: '',
                              //         createdByID: '',
                              //         prifileImage: '',
                              //       ),
                              //       message: MessageDTO(
                              //         receiverDisplayName: receiver.displayName,
                              //         senderDisplayName: sender.displayName,
                              //         attachFile: null,
                              //         senderID: sender.id,
                              //         text: '',
                              //         chatID: '',
                              //         groupID: '',
                              //         senderMobileNumber: sender.mobileNumber,
                              //         receiverID: receiver.id,
                              //         receiverMobileNumber: receiver.mobileNumber,
                              //         sentDateTime: '',
                              //         isRead: true,
                              //       ),
                              //       token: sender.token!,
                              //       chatID: '',
                              //       hostPublicID: sender.id!,
                              //       guestPublicID: receiver.id,
                              //       name: '',
                              //       isGuest: true,
                              //       myID: sender.id!,
                              //       userChatItemDTO: UserChatItemDTO(
                              //         id: '',
                              //         participant1ID: sender.id!,
                              //         participant1MobileNumber:
                              //             sender.mobileNumber!,
                              //         participant1DisplayName:
                              //             sender.displayName ??
                              //                 "Default UserName",
                              //         participant2ID: receiver.id,
                              //         participant2MobileNumber:
                              //             receiver.mobileNumber,
                              //         participant2DisplayName:
                              //             receiver.displayName,
                              //         lastMessageTime: "",
                              //       ),
                              //       isNewChat: true,
                              //     ),
                              //   ),
                              // );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: themeState.theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  width: 2,
                                  color: themeState.theme.colorScheme.onPrimary,
                                ),
                              ),
                              child: ListTile(
                                trailing: Text(
                                  state.groupMembers[index].type.toString() ==
                                          'UserType.Admin'
                                      ? "Admin"
                                      : "",
                                  style: TextStyle(
                                    color:
                                        themeState.theme.colorScheme.onPrimary,
                                  ),
                                ),
                                leading: Icon(
                                  state.groupMembers[index].type.toString() ==
                                          'UserType.Admin'
                                      ? Icons.admin_panel_settings
                                      : Icons.person,
                                  color: themeState.theme.colorScheme.onPrimary,
                                ),
                                title: Text(
                                  "${state.groupMembers[index].mobileNumber} ${state.groupMembers[index].displayName ?? ''}",
                                  style: TextStyle(
                                    color:
                                        themeState.theme.colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  if (state is ChatItemsGroupMembersError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.errorMessage.contains('Bad')
                                ? "مشکلی پیش آمده است مجددا تلاش کنید"
                                : state.errorMessage,
                          ),
                        ],
                      ),
                    );
                  }

                  return const Center(
                    child: Text(
                      "Something Went Wrong",
                    ),
                  );
                },
              ),
            );
          }

          return const Center();
        },
      ),
    );
  }
}
