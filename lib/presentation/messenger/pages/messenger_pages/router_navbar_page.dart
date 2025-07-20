import 'dart:io';

import 'package:Faleh_Hafez/Service/APIService.dart';
import 'package:Faleh_Hafez/application/chat_items/chat_items_bloc.dart';
import 'package:Faleh_Hafez/application/chat_theme_changer/chat_theme_changer_bloc.dart';
import 'package:Faleh_Hafez/application/messaging/bloc/messaging_bloc.dart';
import 'package:Faleh_Hafez/domain/models/user.dart';
import 'package:Faleh_Hafez/presentation/messenger/components/drawer_chat.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/private_chats_page.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/public_chats_page.dart';
import 'package:Faleh_Hafez/presentation/themes/theme.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RouterNavbarPage extends StatefulWidget {
  const RouterNavbarPage({super.key});

  @override
  State<RouterNavbarPage> createState() => _RouterNavbarPageState();
}

class _RouterNavbarPageState extends State<RouterNavbarPage> {
  final box = Hive.box('mybox');
  var userProfile = User(
    id: 'id',
    displayName: 'userName',
    mobileNumber: 'mobileNumber',
    token: 'token',
    type: UserType.Guest,
    profileImage: null,
  );

  var response = User(
    id: '',
    displayName: '',
    profileImage: '',
    mobileNumber: '',
    token: '',
    type: UserType.Admin,
  );

  @override
  initState() {
    super.initState();

    // setState(() {
    //   loginAutomatically();
    // });

    userProfile = User(
      id: box.get("userID"),
      displayName: box.get("userName"),
      mobileNumber: box.get("userMobile"),
      token: box.get("userToken"),
      type: userTypeConvertToEnum[box.get('userType')],
      profileImage: box.get("userImage"),
    );

    try {
      APIService().getUserChats(
        token: userProfile.token!,
      );
    } catch (e) {
      context.showErrorBar(
        content: Text(
          "${e.toString()}: Please Login Again",
        ),
      );

      Navigator.pop(context);
    }
  }

  Future<User> loginAutomatically() async {
    try {
      userProfile = await APIService().loginUser('09000000001', '09000000001');

      box.put("userID", userProfile.id);
      box.put("userName", userProfile.displayName);
      box.put("userMobile", userProfile.mobileNumber);
      box.put("userToken", userProfile.token);
      box.put("userImage", userProfile.profileImage);
      box.put("userType", 2);

      print(userProfile.id);
      print(userProfile.displayName);
      print(userProfile.mobileNumber);
      print(userProfile.token);
      print(userProfile.profileImage);
      print(userProfile.type);

      print("Logged in Successfully!");
    } catch (e) {
      print(e.toString());
    }
    return User(id: '');
  }

  final _screens = [
    {'page': const PrivateChatsPage(), 'title': "Private Chats"},
    {'page': const PublicChatsPage(), 'title': "Group Chats"},
  ];

  int currentIndexPage = 00;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatThemeChangerBloc, ChatThemeChangerState>(
      builder: (context, state) {
        if (state is ChatThemeChangerLoaded) {
          return Scaffold(
            drawer: DrawerHomeChat(user: userProfile),
            appBar: AppBar(
              leading: Builder(builder: (context) {
                return DrawerButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(
                      state.theme.colorScheme.onPrimary,
                    ),
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              }),

              // leading: IconButton(onPressed: , icon: icon),
              elevation: 0,
              backgroundColor: state.theme.colorScheme.primary,
              title: Container(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  _screens[currentIndexPage]['title'] as String,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: state.theme.colorScheme.onPrimary,
                  ),
                ),
              ),
              actions: [
                Builder(
                  builder: (context) {
                    return IconButton(
                      onPressed: () {
                        if (currentIndexPage == 0) {
                          context.read<ChatItemsBloc>().add(
                                ChatItemsGetPrivateChatsEvent(
                                  token: userProfile.token!,
                                ),
                              );
                          return;
                        }
                        if (currentIndexPage == 1) {
                          context.read<ChatItemsBloc>().add(
                                ChatItemsGetPublicChatsEvent(
                                  token: userProfile.token!,
                                ),
                              );
                          return;
                        }
                      },
                      icon: Icon(
                        Icons.refresh,
                        color: state.theme.colorScheme.onPrimary,
                      ),
                    );
                  },
                ),
              ],
            ),
            bottomNavigationBar: NavigationBar(
              indicatorColor: state.theme.colorScheme.onPrimary,
              surfaceTintColor: state.theme.colorScheme.onPrimary,
              overlayColor:
                  MaterialStatePropertyAll(state.theme.colorScheme.onPrimary),
              backgroundColor: state.theme.colorScheme.primary,
              selectedIndex: currentIndexPage,
              onDestinationSelected: (int index) {
                setState(() {
                  currentIndexPage = index;

                  if (context.read<ChatItemsBloc>().isClosed) {
                    if (currentIndexPage == 0) {
                      ChatItemsBloc().add(
                        ChatItemsGetPrivateChatsEvent(
                          token: userProfile.token!,
                        ),
                      );
                    } else if (currentIndexPage == 1) {
                      ChatItemsBloc().add(
                        ChatItemsGetPublicChatsEvent(
                          token: userProfile.token!,
                        ),
                      );
                    }
                  } else {
                    if (currentIndexPage == 0) {
                      context.read<ChatItemsBloc>().add(
                            ChatItemsGetPrivateChatsEvent(
                              token: userProfile.token!,
                            ),
                          );
                    } else if (currentIndexPage == 1) {
                      context.read<ChatItemsBloc>().add(
                            ChatItemsGetPublicChatsEvent(
                              token: userProfile.token!,
                            ),
                          );
                    }
                  }
                });
              },
              destinations: [
                NavigationDestination(
                  icon: Icon(
                    Icons.person,
                    size: 35,
                    color: currentIndexPage == 0
                        ? state.theme.colorScheme.primary
                        : state.theme.colorScheme.onPrimary,
                  ),
                  label: _screens[0]["title"] as String,
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.group,
                    size: 35,
                    color: currentIndexPage != 0
                        ? state.theme.colorScheme.primary
                        : state.theme.colorScheme.onPrimary,
                  ),
                  label: _screens[1]["title"] as String,
                ),
              ],
            ),
            body: _screens[currentIndexPage]["page"] as Widget,
          );
        }
        return const Scaffold(
          body: Center(),
        );
      },
    );
  }
}
