import 'package:Faleh_Hafez/Service/signal_r/SignalR_Service.dart';
import 'package:Faleh_Hafez/application/chat_items/chat_items_bloc.dart';
import 'package:Faleh_Hafez/application/chat_theme_changer/chat_theme_changer_bloc.dart';
import 'package:Faleh_Hafez/application/group_members/group_members_bloc.dart';
import 'package:Faleh_Hafez/application/messaging/bloc/messaging_bloc.dart';
import 'package:Faleh_Hafez/domain/models/group_chat_dto.dart';
import 'package:Faleh_Hafez/domain/models/message_dto.dart';
import 'package:Faleh_Hafez/domain/models/user_chat_dto.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/chat_page.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/components/chatButton.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:swipe_to/swipe_to.dart';

class UsersGroupsTile extends StatefulWidget {
  String title;
  String subTitle;
  void Function() onTap;
  Widget trailing;
  Widget leading;
  ThemeData themeState;
  UserChatItemDTO? userChatItemDTO;
  GroupChatItemDTO? groupChatItemDTO;

  UsersGroupsTile({
    super.key,
    required this.title,
    required this.subTitle,
    required this.onTap,
    required this.trailing,
    required this.leading,
    required this.themeState,
    this.userChatItemDTO,
    this.groupChatItemDTO,
  });

  @override
  State<UsersGroupsTile> createState() => _UsersGroupsTileState();
}

class _UsersGroupsTileState extends State<UsersGroupsTile> {
  @override
  Widget build(BuildContext context) {
    String slidableLabel = '';

    if (widget.groupChatItemDTO?.id != null &&
        widget.groupChatItemDTO?.id != "") {
      slidableLabel = "Leave the group";
    }
    if (widget.userChatItemDTO?.id != null &&
        widget.userChatItemDTO?.id != "") {
      slidableLabel = "Delete chat";
    }

    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.red.shade600,
            foregroundColor: Colors.white,
            onPressed: (context) {
              Slidable.of(context)?.close();
              if (widget.userChatItemDTO?.id != null &&
                  widget.userChatItemDTO?.id != '') {
                var guestDisplayName =
                    widget.userChatItemDTO?.participant1DisplayName ==
                            userProfile.displayName
                        ? widget.userChatItemDTO?.participant2DisplayName
                        : widget.userChatItemDTO?.participant1DisplayName;

                showDialog(
                  context: context,
                  builder: (context) => BlocProvider(
                    create: (_) => context.read<GroupMembersBloc>(),
                    child: AlertDialog(
                      backgroundColor: widget.themeState.colorScheme.secondary,
                      title: Text(
                        "Do you sure to delete '${guestDisplayName}' Chat?",
                        style: TextStyle(
                          fontSize: 16,
                          color: widget.themeState.colorScheme.onSecondary,
                        ),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    context.read<ChatItemsBloc>().add(
                                          ChatItemsDeletePrivateChatEvent(
                                            token: userProfile.token!,
                                            chatID: widget.userChatItemDTO!.id,
                                          ),
                                        );
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: widget
                                          .themeState.colorScheme.tertiary,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Yes",
                                        style: TextStyle(
                                          color: widget.themeState.colorScheme
                                              .onTertiary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color:
                                          widget.themeState.colorScheme.error,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "No",
                                        style: TextStyle(
                                          color: widget.themeState.colorScheme
                                              .onTertiary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              if (widget.groupChatItemDTO?.id != null &&
                  widget.groupChatItemDTO?.id != '') {
                var groupName = widget.groupChatItemDTO?.groupName;

                showDialog(
                  context: context,
                  builder: (context) => BlocProvider(
                    create: (_) => context.read<GroupMembersBloc>(),
                    child: AlertDialog(
                      backgroundColor: widget.themeState.colorScheme.secondary,
                      title: Text(
                        "Do you sure to delete '${groupName}' Chat?",
                        style: TextStyle(
                          fontSize: 16,
                          color: widget.themeState.colorScheme.onSecondary,
                        ),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    try {
                                      GroupMembersBloc().add(
                                        GroupMembersLeaveGroupEvent(
                                          token: userProfile.token!,
                                          groupID: widget.groupChatItemDTO!.id,
                                        ),
                                      );
                                      context.read<ChatItemsBloc>().add(
                                            ChatItemsleaveGroupEvent(
                                              token: userProfile.token!,
                                              groupID:
                                                  widget.groupChatItemDTO!.id,
                                            ),
                                          );
                                    } catch (e) {
                                      context.showErrorBar(
                                        content: Text(
                                          e.toString(),
                                        ),
                                      );
                                      print(e.toString());
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: widget
                                          .themeState.colorScheme.tertiary,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Yes",
                                        style: TextStyle(
                                          color: widget.themeState.colorScheme
                                              .onTertiary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color:
                                          widget.themeState.colorScheme.error,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "No",
                                        style: TextStyle(
                                          color: widget
                                              .themeState.colorScheme.onError,
                                        ),
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
                  ),
                );
              }
            },
            icon: Icons.directions_run,
            label: slidableLabel,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: widget.onTap,
            child: Container(
              padding: const EdgeInsets.all(5),
              // decoration: BoxDecoration(
              //   border: BorderDirectional(
              //     bottom: BorderSide(
              //       width: 2,
              //       color: widget.themeState.colorScheme.secondary,
              //     ),
              //   ),
              //   //   borderRadius: const BorderRadius.only(
              //   //     bottomLeft: Radius.circular(12),
              //   //     bottomRight: Radius.circular(12),
              //   //     topRight: Radius.circular(12),
              // ),
              // color: widget.themeState.primaryColor,
              // ),
              margin: const EdgeInsets.only(
                // left: 15,
                // right: 15,
                top: 5,
              ),
              child: ListTile(
                title: Text(
                  widget.title,
                  style: TextStyle(
                    fontFamily: 'iranSans',
                    color: widget.themeState.colorScheme.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                leading: widget.leading,
                trailing: widget.trailing,
              ),
            ),
          ),
          const Divider(
            height: 1,
            indent: 70,
            color: Colors.white24,
          ),
        ],
      ),
    );
  }
}
