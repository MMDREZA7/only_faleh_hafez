import 'package:faleh_hafez/Service/APIService.dart';
import 'package:faleh_hafez/application/authentiction/authentication_bloc.dart';
import 'package:faleh_hafez/application/chat_theme_changer/chat_theme_changer_bloc.dart';
import 'package:faleh_hafez/domain/models/user.dart';
import 'package:faleh_hafez/presentation/messenger/components/drawer_chat_item.dart';
import 'package:faleh_hafez/presentation/messenger/user_profile/other_profile_page.dart';
import 'package:faleh_hafez/presentation/messenger/user_profile/profile_page.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerHomeChat extends StatefulWidget {
  final User user;

  const DrawerHomeChat({
    super.key,
    required this.user,
  });

  @override
  State<DrawerHomeChat> createState() => _DrawerHomeChatState();
}

class _DrawerHomeChatState extends State<DrawerHomeChat> {
  User userProfile = User(id: '');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userProfile = widget.user;
  }

  Future<Uint8List?> _loadUserImage() async {
    final imageId = box.get("userImage");

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatThemeChangerBloc, ChatThemeChangerState>(
      builder: (context, themeState) {
        if (themeState is ChatThemeChangerLoaded) {
          return Drawer(
            backgroundColor: themeState.theme.colorScheme.primary,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 10,
                left: 10,
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    child: FutureBuilder<Uint8List?>(
                      future: _loadUserImage(),
                      builder: (context, snapshot) {
                        Widget imageWidget;

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          imageWidget = const CircularProgressIndicator();
                        } else if (snapshot.hasData && snapshot.data != null) {
                          imageWidget = CircleAvatar(
                            radius: 50,
                            backgroundImage: MemoryImage(snapshot.data!),
                          );
                        } else {
                          imageWidget = CircleAvatar(
                            backgroundColor:
                                themeState.theme.colorScheme.onSecondary,
                            radius: 50,
                            child: Icon(
                              Icons.person,
                              color: themeState.theme.colorScheme.primary,
                              size: 70,
                            ),
                          );
                        }
                        return imageWidget;
                      },
                    ),
                  ),

                  DrawerItemChat(
                    text: widget.user.displayName ?? "",
                    leadingIcon: Icons.person,
                  ),
                  DrawerItemChat(
                    text: widget.user.mobileNumber,
                    leadingIcon: Icons.phone,
                    trailingIcon: Icons.copy,
                    onTapTrailing: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: widget.user.mobileNumber!,
                        ),
                      ).then(
                        (_) {
                          // ignore: use_build_context_synchronously
                          context.showInfoBar(
                            content: Text(
                              "Your Number copied to clipboard ;) \n ${widget.user.mobileNumber}",
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const Expanded(
                    child: SizedBox(
                      height: double.infinity,
                    ),
                  ),
                  // DrawerItemChat(
                  //   text: 'Profile',
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => const ProfilePage(),
                  //       ),
                  //     );
                  //   },
                  //   leadingIcon: Icons.person,
                  //   // boxColor: themeState.theme.colorScheme.background,
                  // ),
                  DrawerItemChat(
                    text: 'Settings',
                    onTap: () {
                      // context.read<ChatThemeChangerBloc>().add(ChangeChatPageTheme());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    },
                    leadingIcon: Icons.settings,
                  ),
                  DrawerItemChat(
                    boxColor: Colors.red[900],
                    textColor: Colors.white,
                    text: "Logout",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    leadingIcon: Icons.logout,
                  ),
                ],
              ),
            ),
          );
        }

        return const Center();
      },
    );
  }
}
