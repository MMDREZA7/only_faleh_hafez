import 'package:faleh_hafez/application/chat_theme_changer/chat_theme_changer_bloc.dart';
import 'package:faleh_hafez/application/theme_changer/theme_changer_bloc.dart';
import 'package:faleh_hafez/domain/models/user.dart';
import 'package:faleh_hafez/presentation/home/home_page.dart';
import 'package:faleh_hafez/presentation/messenger/components/drawer_chat_item.dart';
import 'package:faleh_hafez/presentation/messenger/pages/login%20&%20register/login_page_chat.dart';
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
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            const SizedBox(
              height: 5,
            ),

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  widget.user.userName ?? widget.user.mobileNumber,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                leading: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),

            const SizedBox(
              height: 5,
            ),

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  widget.user.mobileNumber,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                leading: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                trailing: IconButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: widget.user.mobileNumber,
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
                  icon: Icon(
                    Icons.copy,
                    size: 20,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                // Icon(
                //   Icons.person,
                //   color: Theme.of(context).colorScheme.onPrimary,
                // ),
              ),
            ),
            const SizedBox(height: 100),
            // DrawerItemChat(
            //   boxColor: Colors.blue,
            //   text: 'Profile',
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const ProfilePage(),
            //       ),
            //     );
            //   },
            //   icon: Icons.person,
            // ),
            const SizedBox(height: 25),
            DrawerItemChat(
              boxColor: Colors.grey,
              text: 'Settings',
              onTap: () async {
                context.read<ChatThemeChangerBloc>().add(ChangeChatPageTheme());
              },
              icon: Icons.settings,
            ),
            const SizedBox(height: 25),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPageMessenger(),
                  ),
                );
              },
              onDoubleTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BlocBuilder<ThemeChangerBloc, ThemeChangerState>(
                      builder: (context, state) {
                        if (state is ThemeChangerLoaded) {
                          return MaterialApp(
                            theme: state.theme,
                            home: const HomePage(),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.red,
                ),
                child: const ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
