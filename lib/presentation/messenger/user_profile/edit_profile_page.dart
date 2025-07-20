// ignore_for_file: deprecated_member_use

import 'package:Faleh_Hafez/Service/APIService.dart';
import 'package:Faleh_Hafez/Service/signal_r/SignalR_Service.dart';
import 'package:Faleh_Hafez/application/authentiction/authentication_bloc.dart';
import 'package:Faleh_Hafez/application/chat_items/chat_items_bloc.dart';
import 'package:Faleh_Hafez/domain/models/user.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/login%20&%20register/login_page_chat.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/components/chatButton.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/router_navbar_page.dart';
import 'package:Faleh_Hafez/presentation/messenger/user_profile/items_container.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../application/chat_theme_changer/chat_theme_changer_bloc.dart';

class EditProfilePage extends StatefulWidget {
  User userProfile;

  EditProfilePage({
    super.key,
    required this.userProfile,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

String displayNameUser = '';
String _imageSelected = '';

TextEditingController _displayNameController =
    TextEditingController(text: displayNameUser);

class _EditProfilePageState extends State<EditProfilePage> {
  var box = Hive.box('mybox');
  @override
  void initState() {
    _displayNameController =
        TextEditingController(text: widget.userProfile.displayName ?? '');

    super.initState();
  }

  Future<Uint8List?> _loadUserImage() async {
    final imageId = box.get("userImage");

    if (imageId != null && imageId != '') {
      try {
        List<int> imageData = await APIService().downloadFile(
          token: widget.userProfile.token!,
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
    handlesendImage() async {
      try {
        final result = await FilePicker.platform.pickFiles();

        if (result == null) return null;

        var file = result.files.first;

        var checkImage = result.files.first.name.split('.')[1];

        print("CHECKING IMAGE: ${checkImage}");

        final response = await APIService().uploadFile(
          filePath: file.path!,
          description: 'Default Description',
          token: widget.userProfile.token!,
          name: file.name,
        );
        box.delete('userImage');

        setState(() {
          _imageSelected = response.id ?? '';
        });
        print("SELECTEDIMAGE: ${_imageSelected}");
        print("response.id: ${response.id}");

        box.put('userImage', response.id);
      } catch (e) {
        context.showErrorBar(
          content: Text(e.toString()),
        );
      }
    }

    handleEditProfile(String displayName, String profileImage) {
      context.read<ChatItemsBloc>().add(
            ChatItemsEditProfileUser(
              token: widget.userProfile.token!,
              displayName:
                  _displayNameController.text != widget.userProfile.displayName
                      ? _displayNameController.text
                      : widget.userProfile.displayName ?? '',
              profileImage: profileImage.isEmpty
                  ? widget.userProfile.profileImage
                  : profileImage,
            ),
          );

      Navigator.pop(context);
    }

    return BlocBuilder<ChatThemeChangerBloc, ChatThemeChangerState>(
      builder: (context, themeState) {
        if (themeState is ChatThemeChangerLoaded) {
          return WillPopScope(
            onWillPop: () {
              Navigator.pop(context);
              throw true;
            },
            child: Scaffold(
              backgroundColor: themeState.theme.colorScheme.primary,
              appBar: AppBar(
                leading: const SizedBox(),
                backgroundColor: Colors.transparent,
                title: Text(
                  "Edit Profile",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: themeState.theme.colorScheme.onPrimary,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          handlesendImage();
                        },
                        onLongPress: () {
                          if (userProfile.profileImage != '' &&
                              userProfile.profileImage != null) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: Colors.red[700],
                                title: const Text(
                                  "Delete Profile Image",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Do you want to delete your profile image",
                                    ),
                                    const SizedBox(
                                      height: 100,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              context.read<ChatItemsBloc>().add(
                                                    ChatItemsEditProfileUser(
                                                      token: userProfile.token!,
                                                      displayName:
                                                          _displayNameController
                                                              .text,
                                                      profileImage: '',
                                                    ),
                                                  );
                                              setState(() {
                                                _imageSelected = '';
                                              });
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Colors.green[900],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  "Confirm",
                                                  style:
                                                      TextStyle(fontSize: 16),
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
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[600],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  "Cancel",
                                                  style:
                                                      TextStyle(fontSize: 16),
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
                            );
                          } else {
                            context.showErrorBar(
                              content: Text(
                                "You haven't any profile image",
                              ),
                            );
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
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
                                  backgroundImage: MemoryImage(snapshot.data!),
                                );
                              } else {
                                imageWidget = CircleAvatar(
                                  backgroundColor:
                                      themeState.theme.colorScheme.onSecondary,
                                  radius: 100,
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
                      ),
                      ProfileItemsContainer(
                        marginBottom: 10,
                        leading: Icons.person,
                        title: TextField(
                          controller: _displayNameController,
                          decoration: const InputDecoration(
                            focusColor: Colors.white,
                            label: Text(
                              "Display Name",
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailingIcon: Icons.close,
                        onClickTrailingButton: () {
                          setState(() {
                            _displayNameController.text = '';
                          });
                        },
                      ),
                      ProfileItemsContainer(
                        marginBottom: 10,
                        leading: Icons.phone,
                        title: widget.userProfile.mobileNumber,
                        trailingIcon: Icons.copy,
                        onClickTrailingButton: () {
                          ClipboardData(
                            text: widget.userProfile.mobileNumber!,
                          );
                          context.showInfoBar(
                            content: Text(
                              "[ ${widget.userProfile.mobileNumber} ] Copied!",
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 150,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: ChatButton(
                              text: "Save",
                              onTap: () {
                                context.showSuccessBar(
                                  content: const Text(
                                    "Profile Changed successfully!",
                                  ),
                                );
                                handleEditProfile(
                                  _displayNameController.text,
                                  _imageSelected,
                                );
                                // ignore: use_build_context_synchronously

                                // Navigator.pushReplacement(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) =>
                                //         const RouterNavbarPage(),
                                //   ),
                                // );
                                Navigator.pop(context);
                              },
                              color: Colors.green[900],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: ChatButton(
                              text: "Cancel",
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              color: Colors.red[900],
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
        }

        return const Center();
      },
    );
  }
}
