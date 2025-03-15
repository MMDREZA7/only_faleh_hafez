import 'package:faleh_hafez/application/chat_items/chat_items_bloc.dart';
import 'package:faleh_hafez/domain/models/user.dart';
import 'package:faleh_hafez/presentation/messenger/components/drawer_chat_item.dart';
import 'package:faleh_hafez/presentation/messenger/pages/login%20&%20register/login_page_chat.dart';
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 10,
          left: 10,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.only(
                top: 35,
                bottom: 25,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              child: Center(
                child: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                  size: 100,
                ),
              ),
              // child: Image(image: AssetImage("assetName")),
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
            //   // boxColor: Theme.of(context).colorScheme.background,
            // ),
            DrawerItemChat(
              text: 'Settings',
              onTap: () {
                // context.read<ChatThemeChangerBloc>().add(ChangeChatPageTheme());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => ChatItemsBloc(),
                      child: const ProfilePage(),
                    ),
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPageMessenger(),
                  ),
                );
              },
              leadingIcon: Icons.logout,
            ),
          ],
        ),
      ),
    );
  }
}
