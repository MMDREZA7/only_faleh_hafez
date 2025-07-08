// ignore_for_file: use_build_context_synchronously

import 'package:Faleh_Hafez/Service/APIService.dart';
import 'package:Faleh_Hafez/Service/get_it/service_locator.dart';
import 'package:Faleh_Hafez/Service/signal_r/SignalR_Service.dart';
import 'package:Faleh_Hafez/application/chat_items/chat_items_bloc.dart';
import 'package:Faleh_Hafez/application/chat_theme_changer/chat_theme_changer_bloc.dart';
import 'package:Faleh_Hafez/application/messaging/bloc/messaging_bloc.dart';
import 'package:Faleh_Hafez/domain/models/group_chat_dto.dart';
import 'package:Faleh_Hafez/domain/models/message_dto.dart';
import 'package:Faleh_Hafez/domain/models/user.dart';
import 'package:Faleh_Hafez/domain/models/user_chat_dto.dart';
import 'package:Faleh_Hafez/presentation/messenger/group_profile/edit_group_profile_page.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/chat_page.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/components/add_member_dialog.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/components/chatButton.dart';
import 'package:Faleh_Hafez/presentation/messenger/user_profile/items_container.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class GroupProfilePage extends StatefulWidget {
  final GroupChatItemDTO? group;
  final String groupOwnerID;

  const GroupProfilePage({
    super.key,
    this.group,
    required this.groupOwnerID,
  });

  @override
  State<GroupProfilePage> createState() => _GroupProfilePageState();
}

class _GroupProfilePageState extends State<GroupProfilePage> {
  var userProfile = User(
    id: '',
    displayName: '',
    profileImage: '',
    mobileNumber: '',
    token: '',
    type: UserType.Guest,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var box = Hive.box('mybox');

    userProfile = User(
      id: box.get('userID'),
      displayName: box.get('userName'),
      profileImage: box.get('userImage'),
      mobileNumber: box.get('userMobile'),
      token: box.get('userToken'),
      type: userTypeConvertToEnum[box.get('userType')],
    );
  }

  void _refreshUsers() {
    context.read<ChatItemsBloc>().add(
          ChatItemsGetGroupMembersEvent(
            token: userProfile.token!,
            groupID: widget.group!.id,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatThemeChangerBloc, ChatThemeChangerState>(
      builder: (context, themeState) {
        if (themeState is ChatThemeChangerLoaded) {
          Future<Uint8List?> _loadUserImage() async {
            var imageId = widget.group!.profileImage;

            if (imageId != null && imageId != '') {
              try {
                List<int> imageData = await APIService().downloadFile(
                  token: userProfile.token!,
                  id: imageId,
                );
                return Uint8List.fromList(imageData);
              } catch (e) {
                print("Error loading profile image: $e");
              }
            }
            return null;
          }

          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: themeState.theme.colorScheme.primary,
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(0, 0, 0, 0),
              title: Text(
                "Group Profile",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: themeState.theme.colorScheme.onPrimary,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    context.read<ChatItemsBloc>().add(
                          ChatItemsGetGroupMembersEvent(
                            token: userProfile.token!,
                            groupID: widget.group!.id,
                          ),
                        );
                  },
                  icon: Icon(
                    Icons.refresh_rounded,
                    color: themeState.theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        color: themeState.theme.colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(500),
                        border: Border.all(
                          color: themeState.theme.colorScheme.primary,
                          width: 10,
                        ),
                      ),
                      child: FutureBuilder<Uint8List?>(
                        future: _loadUserImage(),
                        builder: (context, snapshot) {
                          Widget imageWidget;

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            imageWidget = const CircularProgressIndicator();
                          } else if (snapshot.hasData &&
                              snapshot.data != null) {
                            imageWidget = CircleAvatar(
                              radius: 100,
                              backgroundImage: MemoryImage(
                                snapshot.data!,
                              ),
                            );
                          } else {
                            imageWidget = CircleAvatar(
                              backgroundColor:
                                  themeState.theme.colorScheme.onSecondary,
                              radius: 100,
                              child: Icon(
                                Icons.group,
                                color: themeState.theme.colorScheme.primary,
                                size: 150,
                              ),
                            );
                          }
                          return imageWidget;
                        },
                      ),
                    ),
                    ProfileItemsContainer(
                      marginBottom: 15,
                      leading: Icons.group,
                      title: widget.group!.groupName,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: ChatButton(
                            onTap: () => showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return AddMemberDialog(
                                  groupID: widget.group!.id,
                                  groupName: widget.group!.groupName,
                                  token: userProfile.token!,
                                  afterAdd: _refreshUsers,
                                );
                              },
                            ),
                            icon: Icon(
                              CupertinoIcons.add,
                              color: Colors.green[800],
                              size: 30,
                              // color: themeState.theme.colorScheme.onSecondary,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: ChatButton(
                            text: "Change Profile",
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditGroupProfilePage(
                                    groupProfile: widget.group!,
                                  ),
                                ),
                              );
                            },
                            color: themeState.theme.colorScheme.secondary,
                            textColor: themeState.theme.colorScheme.onSecondary,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: ChatButton(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => SingleChildScrollView(
                                  child: Dialog(
                                    backgroundColor:
                                        themeState.theme.colorScheme.primary,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Do you want to leave the '${widget.group!.groupName}' group?",
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                onPressed: () async {
                                                  try {
                                                    await APIService()
                                                        .leaveGroup(
                                                      groupID: widget.group!.id,
                                                      userID: userProfile.id!,
                                                      role:
                                                          userTypeConvertToJson[
                                                                  userProfile
                                                                      .type!] ??
                                                              0,
                                                      token: userProfile.token!,
                                                    );

                                                    // context.read<ChatItemsBloc>().add(
                                                    //       ChatItemsGetPublicChatsEvent(
                                                    //         token: userProfile.token!,
                                                    //       ),
                                                    //     );

                                                    context.showSuccessBar(
                                                      content: const Text(
                                                        "You left the group successfully!",
                                                      ),
                                                    );
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    context
                                                        .read<ChatItemsBloc>()
                                                        .add(
                                                          ChatItemsGetPublicChatsEvent(
                                                            token: userProfile
                                                                .token!,
                                                          ),
                                                        );
                                                  } catch (e) {
                                                    context.showErrorBar(
                                                      content:
                                                          Text(e.toString()),
                                                    );
                                                  }
                                                },
                                                child: Text(
                                                  "Yes",
                                                  style: TextStyle(
                                                    color: themeState.theme
                                                        .colorScheme.onPrimary,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "No",
                                                  style: TextStyle(
                                                    color: themeState.theme
                                                        .colorScheme.onPrimary,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.exit_to_app_rounded,
                              color: Colors.red[900],
                              size: 30,
                              // color: themeState.theme.colorScheme.onSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    BlocBuilder<ChatItemsBloc, ChatItemsState>(
                      builder: (context, state) {
                        if (state is ChatItemsGroupMembersLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is ChatItemsError) {
                          context.showErrorBar(
                            content: Text(
                              state.errorMessage,
                            ),
                          );
                        }
                        if (state is ChatItemsGroupMembersLoaded) {
                          return Center(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.groupMembers.length,
                              itemBuilder: (context, index) {
                                var groupMember = state.groupMembers[index];

                                Future<Uint8List?> _loadUserImage() async {
                                  var imageId = groupMember.profileImage;

                                  if (imageId != null && imageId != '') {
                                    try {
                                      List<int> imageData =
                                          await APIService().downloadFile(
                                        token: userProfile.token!,
                                        id: imageId,
                                      );
                                      return Uint8List.fromList(imageData);
                                    } catch (e) {
                                      debugPrint(
                                          "Error loading profile image: $e");
                                    }
                                  }
                                  return null;
                                }

                                if (state.groupMembers[index].id ==
                                    userProfile.id) {
                                  String adminOwnerUser = '';
                                  // IconData adminOwnerUserIcon = Icons.person;

                                  if (state.groupMembers[index].type == 2) {
                                    adminOwnerUser = 'Admin';
                                    // adminOwnerUserIcon =
                                    //     Icons.admin_panel_settings_rounded;
                                  }
                                  if (state.groupMembers[index].id ==
                                      widget.groupOwnerID) {
                                    adminOwnerUser = 'Owner';
                                    // adminOwnerUserIcon =
                                    //     Icons.admin_panel_settings_rounded;
                                  } else {
                                    adminOwnerUser = '';
                                  }
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: themeState
                                          .theme.colorScheme.onPrimary,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: themeState
                                            .theme.colorScheme.primary,
                                        width: 2,
                                      ),
                                    ),
                                    child: ListTile(
                                      trailing: Text(
                                        adminOwnerUser,
                                        style: TextStyle(
                                          color: themeState
                                              .theme.colorScheme.primary,
                                          fontSize: 12,
                                        ),
                                      ),
                                      leading: FutureBuilder<Uint8List?>(
                                        future: _loadUserImage(),
                                        builder: (context, snapshot) {
                                          Widget imageWidget;

                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            imageWidget =
                                                const CircularProgressIndicator();
                                          } else if (snapshot.hasData &&
                                              snapshot.data != null) {
                                            imageWidget = CircleAvatar(
                                              radius: 25,
                                              backgroundImage: MemoryImage(
                                                snapshot.data!,
                                              ),
                                            );
                                          } else {
                                            imageWidget = CircleAvatar(
                                              backgroundColor: themeState.theme
                                                  .colorScheme.onSecondary,
                                              radius: 30,
                                              child: Icon(
                                                Icons.group,
                                                color: themeState
                                                    .theme.colorScheme.primary,
                                                size: 15,
                                              ),
                                            );
                                          }
                                          return imageWidget;
                                        },
                                      ),

                                      // leading: Icon(
                                      //   adminOwnerUserIcon,
                                      //   color: themeState
                                      //       .theme.colorScheme.primary,
                                      // ),
                                      title: Text(
                                        state.groupMembers[index].displayName!,
                                        style: TextStyle(
                                          color: themeState
                                              .theme.colorScheme.primary,
                                        ),
                                      ),
                                      subtitle: Text(
                                        state.groupMembers[index].mobileNumber,
                                        style: TextStyle(
                                          color: themeState
                                              .theme.colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  String adminOwnerUser = '';
                                  // IconData adminOwnerUserIcon = Icons.person;
                                  print(state.groupMembers[index].type);

                                  if (state.groupMembers[index].type
                                          .toString() ==
                                      'UserType.Admin') {
                                    adminOwnerUser = 'Admin';
                                    // adminOwnerUserIcon =
                                    //     Icons.admin_panel_settings_rounded;
                                  } else if (state.groupMembers[index].id ==
                                      widget.groupOwnerID) {
                                    adminOwnerUser = 'Owner';
                                    // adminOwnerUserIcon =
                                    //     Icons.admin_panel_settings_rounded;
                                  } else {
                                    adminOwnerUser = '';
                                  }

                                  return GestureDetector(
                                    onTap: () async {
                                      var sendedMessage =
                                          await APIService().sendMessage(
                                        token: userProfile.token!,
                                        mobileNumber: userProfile.mobileNumber!,
                                        receiverID: groupMember.id,
                                        text: 'Hello',
                                      );

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BlocProvider<MessagingBloc>(
                                            create: (_) => sl<MessagingBloc>()
                                              ..add(ConnectToSignalR()),
                                            child: ChatPage(
                                              hostPublicID: userProfile.id!,
                                              guestPublicID: groupMember.id,
                                              name: groupMember.displayName!,
                                              isGuest: false,
                                              chatID: sendedMessage['chatID'],
                                              token: userProfile.token!,
                                              myID: userProfile.id!,
                                              userChatItemDTO: UserChatItemDTO(
                                                id: sendedMessage['chatID'],
                                                participant1ID: userProfile.id!,
                                                participant1MobileNumber:
                                                    userProfile.mobileNumber!,
                                                participant1DisplayName:
                                                    userProfile.displayName!,
                                                participant1ProfileImage:
                                                    userProfile.profileImage!,
                                                participant2ID: groupMember.id,
                                                participant2MobileNumber:
                                                    groupMember.mobileNumber,
                                                participant2DisplayName:
                                                    groupMember.displayName!,
                                                participant2ProfileImage:
                                                    groupMember.profileImage,
                                                lastMessageTime: '',
                                              ),
                                              groupChatItemDTO:
                                                  GroupChatItemDTO(
                                                id: '',
                                                groupName: '',
                                                lastMessageTime: '',
                                                createdByID: '',
                                                profileImage: '',
                                              ),
                                              message: MessageDTO(
                                                messageID:
                                                    sendedMessage['messageID'],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: themeState
                                            .theme.colorScheme.primary,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          width: 2,
                                          color: themeState
                                              .theme.colorScheme.onPrimary,
                                        ),
                                      ),
                                      child: ListTile(
                                        trailing: Text(
                                          adminOwnerUser,
                                          style: TextStyle(
                                            color: themeState
                                                .theme.colorScheme.onPrimary,
                                          ),
                                        ),
                                        leading: FutureBuilder<Uint8List?>(
                                          future: _loadUserImage(),
                                          builder: (context, snapshot) {
                                            Widget imageWidget;

                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              imageWidget =
                                                  const CircularProgressIndicator();
                                            } else if (snapshot.hasData &&
                                                snapshot.data != null) {
                                              imageWidget = CircleAvatar(
                                                radius: 25,
                                                backgroundImage: MemoryImage(
                                                  snapshot.data!,
                                                ),
                                              );
                                            } else {
                                              imageWidget = CircleAvatar(
                                                backgroundColor: themeState
                                                    .theme
                                                    .colorScheme
                                                    .onSecondary,
                                                radius: 25,
                                                child: Icon(
                                                  Icons.group,
                                                  color: themeState.theme
                                                      .colorScheme.primary,
                                                  size: 35,
                                                ),
                                              );
                                            }
                                            return imageWidget;
                                          },
                                        ),

                                        // leading: Icon(
                                        //   adminOwnerUserIcon,
                                        //   color: themeState
                                        //       .theme.colorScheme.onPrimary,
                                        // ),
                                        title: Text(
                                          state
                                              .groupMembers[index].displayName!,
                                          style: TextStyle(
                                            color: themeState
                                                .theme.colorScheme.onPrimary,
                                          ),
                                        ),
                                        subtitle: Text(
                                          state
                                              .groupMembers[index].mobileNumber,
                                          style: TextStyle(
                                            color: themeState
                                                .theme.colorScheme.onPrimary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
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
                  ],
                ),
              ),
            ),
          );
        }

        return const Center();
      },
    );
  }
}
