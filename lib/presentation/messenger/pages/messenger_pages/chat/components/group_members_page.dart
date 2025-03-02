import 'package:faleh_hafez/application/chat_items/chat_items_bloc.dart';
import 'package:faleh_hafez/domain/models/group_chat_dto.dart';
import 'package:faleh_hafez/domain/models/massage_dto.dart';
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
      create: (context) => ChatItemsBloc()
        ..add(
          ChatItemsGetGroupMembersEvent(
            token: widget.token,
            groupID: widget.groupID,
          ),
        ),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
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
                        addMemberBloc: context.read<ChatItemsBloc>(),
                      ),
                    ),
                    icon: Icon(
                      Icons.group_add,
                      color: Theme.of(context).colorScheme.onBackground,
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
                                color: Theme.of(context).colorScheme.onPrimary,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2,
                                )),
                            child: ListTile(
                              trailing: Text(
                                state.groupMembers[index].id == widget.adminID
                                    ? "Admin"
                                    : '',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                              leading: Icon(
                                state.groupMembers[index].id == widget.adminID
                                    ? Icons.admin_panel_settings
                                    : Icons.person,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              title: Text(
                                state.groupMembers[index].mobileNumber,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          );
                        }

                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              width: 2,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          child: ListTile(
                            trailing: Text(
                              state.groupMembers[index].id == widget.adminID
                                  ? "Admin"
                                  : '',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            leading: Icon(
                              state.groupMembers[index].type.toString() ==
                                      'UserType.Admin'
                                  ? Icons.admin_panel_settings
                                  : Icons.person,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            title: Text(
                              state.groupMembers[index].mobileNumber,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
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
        },
      ),
    );
  }
}
