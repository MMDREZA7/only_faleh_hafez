import 'package:faleh_hafez/application/chat_items/chat_items_bloc.dart';
import 'package:faleh_hafez/application/chat_theme_changer/chat_theme_changer_bloc.dart';
import 'package:faleh_hafez/domain/models/user.dart';
import 'package:faleh_hafez/presentation/home/components/button.dart';
import 'package:faleh_hafez/presentation/messenger/pages/messenger_pages/chat/components/chatButton.dart';
import 'package:faleh_hafez/presentation/messenger/profile/edit_profile_page.dart';
import 'package:faleh_hafez/presentation/messenger/profile/items_container.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var userProfile = User(
    id: 'id',
    displayName: 'userName',
    mobileNumber: 'mobileNumber',
    profileImage: "",
    token: 'token',
    type: UserType.Guest,
  );

  bool isThemeDark = true;
  String theme = '';
  String themeText = "";

  @override
  void initState() {
    var box = Hive.box('mybox');

    userProfile = User(
      id: box.get('userID'),
      displayName: box.get('userName'),
      mobileNumber: box.get('userMobile'),
      profileImage: box.get('profileImage'),
      token: box.get('userToken'),
      type: userTypeConvertToEnum[box.get('userType')],
    );

    theme = box.get("chatTheme");
    print(theme);

    if (theme == "darkChatTheme") {
      setState(() {
        isThemeDark = true;
      });
    }
    if (theme == "darkChatTheme") {
      setState(() {
        isThemeDark = false;
      });

      print("Theme : ${theme}");
      print("ThemeText : ${themeText}");
    }

    // var user = User(
    //   id: '1654684651-651651-81651651-651651',
    //   mobileNumber: '09000000000',
    //   token: 'asg561asg32sa1gasgsa54651sa6g51as65g165',
    //   type: UserType.Regular,
    // );

    // ignore: unused_local_variable
    // final userProfile = User(
    //   id: box.get("userID"),
    //   displayName: box.get("userName"),
    //   mobileNumber: box.get("userMobile"),
    //   token: box.get("userToken"),
    //   type: userTypeConvertToEnum[box.get("userType")]!,
    // );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Profile",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(500),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 10,
                ),
              ),
              child: userProfile.profileImage != null
                  ? Image(
                      fit: BoxFit.cover,
                      height: 200,
                      image: AssetImage(
                        userProfile.profileImage!,
                      ),
                    )
                  : Icon(
                      Icons.person,
                      size: 200,
                      color: Theme.of(context).colorScheme.primary,
                    ),
            ),
            ProfileItemsContainer(
              marginButtom: 10,
              leading: Icons.person,
              title: userProfile.displayName,
              // ?? userProfile.displayName,
            ),
            ProfileItemsContainer(
              marginButtom: 10,
              leading: Icons.phone,
              title: userProfile.mobileNumber,
              // ?? userProfile.mobileNumber,
              trailingIcon: Icons.copy,
              onClickTrailingButton: () {
                ClipboardData(
                  text: userProfile.mobileNumber!,
                );
                context.showInfoBar(
                    content: Text("[ ${userProfile.mobileNumber} ] Copied!"));
              },
            ),
            ProfileItemsContainer(
              leading: Icons.color_lens,
              title: Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Dark"),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: Switch(
                        activeColor: Theme.of(context).colorScheme.secondary,
                        trackOutlineColor: const MaterialStatePropertyAll(
                          Colors.transparent,
                        ),
                        thumbColor: MaterialStatePropertyAll(
                          isThemeDark ? Colors.black : Colors.white,
                        ),
                        value: isThemeDark,
                        onChanged: (value) {
                          context
                              .read<ChatThemeChangerBloc>()
                              .add(ChangeChatPageTheme());
                          setState(() {
                            isThemeDark = !isThemeDark;
                          });
                        },
                      ),
                    ),
                    const Text("Light"),
                  ],
                ),
              ),
            ),
            const Expanded(
              child: SizedBox(
                height: 2,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ChatButton(
                    text: "Change Profile",
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => ChatItemsBloc(),
                            child: EditProfilePage(
                              userProfile: userProfile,
                            ),
                          ),
                        ),
                      );
                    },
                    color: Theme.of(context).colorScheme.secondary,
                    textColor: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                // const SizedBox(
                //   width: 10,
                // ),
                // Expanded(
                //   child: ChatButton(
                //     text: "Cancel",
                //     onTap: () {},
                //     color: Colors.red[900],
                //   ),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
