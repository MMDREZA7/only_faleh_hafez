import 'package:faleh_hafez/application/chat_items/chat_items_bloc.dart';
import 'package:faleh_hafez/domain/models/user.dart';
import 'package:faleh_hafez/presentation/messenger/components/drawer_chat.dart';
import 'package:faleh_hafez/presentation/messenger/pages/messenger_pages/home_chats_page.dart';
import 'package:faleh_hafez/presentation/messenger/pages/messenger_pages/public_chats_page.dart';
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

    // !!!!!
    profileImage: null,
    // !!!!!
  );
  @override
  void initState() {
    super.initState();

    box.put("userID", '77a16c07-2bba-4706-d059-08dd2cc521d1');
    box.put("userMobile", '09000000001');
    box.put(
      "userToken",
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiI3N2ExNmMwNy0yYmJhLTQ3MDYtZDA1OS0wOGRkMmNjNTIxZDEiLCJ1bmlxdWVfbmFtZSI6IjA5MDAwMDAwMDAxIiwibmJmIjoxNzQyMjEyMDMyLCJleHAiOjE3NDIyMTk4MzIsImlhdCI6MTc0MjIxMjAzMiwiaXNzIjoiWW91ckFQSSIsImF1ZCI6IllvdXJBUElVc2VycyJ9.4L6efO5CzJsi-LiKeRKRW3ZXbYUJixqKcCR1q0ls3Go",
    );
    box.put("userType", 2);

    userProfile = User(
      id: box.get("userID"),
      displayName: box.get("userName"),
      mobileNumber: box.get("userMobile"),
      token: box.get("userToken"),
      type: userTypeConvertToEnum[box.get('userType')]!,

      // !!!!!
      profileImage: null,
      // !!!!!
    );
    print(userProfile.displayName);
  }

  final _screens = [
    {
      'page': const HomeChatsPage(),
      'title': "Private Chats",
      'onclick': () {
        // context.read<ChatItemsBloc>().add(
        //       ChatItemsGetPublicChatsEvent(
        //         token: userProfile.token!,
        //       ),
        //     );
      }
    },
    {'page': const PublicChatsPage(), 'title': "Public Chats"},
  ];

  int currentIndexPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerHomeChat(user: userProfile),
      appBar: AppBar(
        // leading: IconButton(onPressed: , icon: icon),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Container(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            _screens[currentIndexPage]['title'] as String,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const PublicChatsPage(),
          //       ),
          //     );
          //   },
          //   icon: Icon(
          //     Icons.group_rounded,
          //     color: Theme.of(context).colorScheme.onPrimary,
          //   ),
          // ),
          Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                context.read<ChatItemsBloc>().add(
                      ChatItemsGetPrivateChatsEvent(
                        token: userProfile.token!,
                      ),
                    );
              },
              icon: Icon(
                Icons.refresh,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            );
          }),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndexPage,
        onDestinationSelected: (int index) {
          setState(() {
            currentIndexPage = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.person,
              size: 35,
            ),
            label: "Private Chats",
          ),
          NavigationDestination(
            icon: Icon(
              Icons.group,
              size: 35,
            ),
            label: "Public Chats",
          ),
        ],
      ),
      body: _screens[currentIndexPage]["page"] as Widget,
    );
  }
}
