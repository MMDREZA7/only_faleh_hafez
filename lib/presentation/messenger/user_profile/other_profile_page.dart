import 'package:faleh_hafez/Service/APIService.dart';
import 'package:faleh_hafez/application/authentiction/authentication_bloc.dart';
import 'package:faleh_hafez/application/chat_items/chat_items_bloc.dart';
import 'package:faleh_hafez/application/chat_theme_changer/chat_theme_changer_bloc.dart';
import 'package:faleh_hafez/domain/models/user.dart';
import 'package:faleh_hafez/presentation/messenger/pages/messenger_pages/chat/components/chatButton.dart';
import 'package:faleh_hafez/presentation/messenger/user_profile/edit_profile_page.dart';
import 'package:faleh_hafez/presentation/messenger/user_profile/items_container.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OtherProfilePage extends StatefulWidget {
  final User otherUserProfile;

  const OtherProfilePage({
    super.key,
    required this.otherUserProfile,
  });

  @override
  State<OtherProfilePage> createState() => _OtherProfilePageState();
}

class _OtherProfilePageState extends State<OtherProfilePage> {
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
    }

    super.initState();
  }

  Future<Uint8List?> _loadUserImage() async {
    final imageId = widget.otherUserProfile.profileImage;
    final token = widget.otherUserProfile.token!;

    if (imageId != null) {
      try {
        List<int> imageData = await APIService().downloadFile(
          token: token,
          id: imageId,
        );
        return Uint8List.fromList(imageData);
      } catch (e) {
        debugPrint("Error loading profile image: $e");
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatThemeChangerBloc, ChatThemeChangerState>(
      builder: (context, themeState) {
        if (themeState is ChatThemeChangerLoaded) {
          return Scaffold(
            backgroundColor: themeState.theme.colorScheme.primary,
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                icon: Icon(
                  CupertinoIcons.left_chevron,
                  color: themeState.theme.colorScheme.onPrimary,
                ),
              ),
              backgroundColor: Colors.transparent,
              title: Text(
                "Profile",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: themeState.theme.colorScheme.onPrimary,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(15),
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
                            radius: 100,
                            backgroundImage: MemoryImage(snapshot.data!),
                          );
                        } else {
                          imageWidget = CircleAvatar(
                            radius: 100,
                            backgroundColor:
                                themeState.theme.colorScheme.onSecondary,
                            child: Icon(
                              Icons.person,
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
                    marginBottom: 10,
                    leading: Icons.person,
                    title: widget.otherUserProfile.displayName,
                  ),
                  ProfileItemsContainer(
                    marginBottom: 10,
                    leading: Icons.phone,
                    title: widget.otherUserProfile.mobileNumber,
                    trailingIcon: Icons.copy,
                    onClickTrailingButton: () {
                      ClipboardData(
                        text: widget.otherUserProfile.mobileNumber!,
                      );
                      context.showInfoBar(
                          content: Text(
                              "[ ${widget.otherUserProfile.mobileNumber} ] Copied!"));
                    },
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
