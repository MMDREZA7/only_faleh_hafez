import 'package:Faleh_Hafez/Service/APIService.dart';
import 'package:Faleh_Hafez/application/authentiction/authentication_bloc.dart';
import 'package:Faleh_Hafez/application/chat_items/chat_items_bloc.dart';
import 'package:Faleh_Hafez/application/group_profile/group_profile_bloc.dart';
import 'package:Faleh_Hafez/domain/models/group_chat_dto.dart';
import 'package:Faleh_Hafez/domain/models/user.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/components/chatButton.dart';
import 'package:Faleh_Hafez/presentation/messenger/user_profile/items_container.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../application/chat_theme_changer/chat_theme_changer_bloc.dart';

class EditGroupProfilePage extends StatefulWidget {
  GroupChatItemDTO groupProfile;

  EditGroupProfilePage({
    super.key,
    required this.groupProfile,
  });

  @override
  State<EditGroupProfilePage> createState() => _EditGroupProfilePageState();
}

String groupProfileName = '';
String groupPhoto = '';
String _imageSelected = '';

TextEditingController _groupProfileNameController =
    TextEditingController(text: groupProfileName);

class _EditGroupProfilePageState extends State<EditGroupProfilePage> {
  bool isThemeDark = true;
  var userProfile = User(
    id: 'id',
    displayName: 'displayName',
    mobileNumber: 'mobileNumber',
    profileImage: 'profileImage',
    token: 'token',
    type: UserType.Guest,
  );

  @override
  void initState() {
    var box = Hive.box('mybox');

    _groupProfileNameController =
        TextEditingController(text: widget.groupProfile.groupName);

    userProfile = User(
      id: box.get('userID'),
      displayName: box.get('userName'),
      mobileNumber: box.get('userMobile'),
      profileImage: box.get('userImage'),
      token: box.get('userToken'),
      type: userTypeConvertToEnum[box.get('userType')],
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? imageId;

    Future<Uint8List?> _loadUserImage(String? imageID) async {
      imageId = imageID;

      if (imageId != null && imageId != '') {
        try {
          List<int> imageData = await APIService().downloadFile(
            token: userProfile.token!,
            id: imageId ?? '',
          );
          return Uint8List.fromList(imageData);
        } catch (e) {
          // ignore: use_build_context_synchronously
          context.showErrorBar(
            content: Text("Error loading profile image: $e"),
          );
        }
      }
      return null;
    }

    void handlesendImage() async {
      try {
        final result = await FilePicker.platform.pickFiles();

        if (result == null) return null;

        var file = result.files.first;

        var checkImage = result.files.first.name.split('.')[1];

        print("CHECKING IMAGE: ${checkImage}");

        final response = await APIService().uploadFile(
          filePath: file.path!,
          description: 'Default Description',
          token: userProfile.token!,
          name: file.name,
        );

        setState(() {
          _imageSelected = response.id!;
        });
      } catch (e) {
        context.showErrorBar(
          content: Text(e.toString()),
        );
      }
    }

    handleEditProfile(String groupName, String groupProfileImage) async {
      if (groupName.isEmpty) {
        context.showErrorBar(
          content: const Text(
            "The GroupName dosen't be Empty!",
          ),
        );
        Navigator.pop(context);
        return;
      }
      if (groupName.length > 15) {
        context.showInfoBar(
          content: const Text(
            'Group name should be lower than 15 character!',
          ),
        );
        return;
      }

      context.read<GroupProfileBloc>().add(
            EditGroupProfileEvent(
              token: userProfile.token!,
              groupID: widget.groupProfile.id,
              groupImage: groupProfileImage,
              groupName: groupName,
            ),
          );
      Navigator.pop(context);

      _imageSelected = '';
    }

    return BlocBuilder<ChatThemeChangerBloc, ChatThemeChangerState>(
      builder: (context, themeState) {
        if (themeState is ChatThemeChangerLoaded) {
          return BlocBuilder<GroupProfileBloc, GroupProfileState>(
            builder: (context, state) {
              if (state is GroupProfileLoading) {
                const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is GroupProfileLoaded) {
                return Scaffold(
                  backgroundColor: themeState.theme.colorScheme.primary,
                  appBar: AppBar(
                    leading: const SizedBox(),
                    backgroundColor: Colors.transparent,
                    title: Text(
                      "Edit Group Profile",
                      style: TextStyle(
                        fontFamily: 'iranSans',
                        fontSize: 22,
                        fontWeight: FontWeight.w300,
                        color: themeState.theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            handlesendImage();
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            child: FutureBuilder<Uint8List?>(
                              future: _loadUserImage(_imageSelected),
                              builder: (context, snapshot) {
                                Widget imageWidget;

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  imageWidget =
                                      const CircularProgressIndicator();
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
                                    backgroundColor: themeState
                                        .theme.colorScheme.onSecondary,
                                    radius: 100,
                                    child: Icon(
                                      Icons.group,
                                      color:
                                          themeState.theme.colorScheme.primary,
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
                          leading: Icons.group,
                          title: TextField(
                            maxLength: 15,
                            controller: _groupProfileNameController,
                            decoration: const InputDecoration(
                              focusColor: Colors.white,
                              label: Text(
                                "Group Name",
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
                              _groupProfileNameController.text = '';
                            });
                          },
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
                                text: "Save",
                                onTap: () {
                                  handleEditProfile(
                                    _groupProfileNameController.text,
                                    _imageSelected,
                                  );
                                },
                                color: Colors.green[900],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: ChatButton(
                                text: "Cancel",
                                onTap: () {
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
                );
              }
              return Scaffold(
                backgroundColor: themeState.theme.colorScheme.primary,
                appBar: AppBar(
                  leading: const SizedBox(),
                  backgroundColor: Colors.transparent,
                  title: Text(
                    "Edit Group Profile",
                    style: TextStyle(
                      fontFamily: 'iranSans',
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                      color: themeState.theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          handlesendImage();
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          child: FutureBuilder<Uint8List?>(
                            future: _loadUserImage(_imageSelected),
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
                      ),
                      ProfileItemsContainer(
                        marginBottom: 10,
                        leading: Icons.group,
                        title: TextField(
                          maxLength: 15,
                          controller: _groupProfileNameController,
                          decoration: const InputDecoration(
                            focusColor: Colors.white,
                            label: Text(
                              "Group Name",
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
                            _groupProfileNameController.text = '';
                          });
                        },
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
                              text: "Save",
                              onTap: () {
                                handleEditProfile(
                                  _groupProfileNameController.text,
                                  _imageSelected,
                                );
                              },
                              color: Colors.green[900],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ChatButton(
                              text: "Cancel",
                              onTap: () {
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
              );
            },
          );
        }

        return Scaffold(
          backgroundColor: themeState.theme.colorScheme.primary,
          appBar: AppBar(
            leading: const SizedBox(),
            backgroundColor: Colors.transparent,
            title: Text(
              "Edit Group Profile",
              style: TextStyle(
                fontFamily: 'iranSans',
                fontSize: 22,
                fontWeight: FontWeight.w300,
                color: themeState.theme.colorScheme.onPrimary,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    handlesendImage();
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    child: FutureBuilder<Uint8List?>(
                      future: _loadUserImage(widget.groupProfile.profileImage),
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
                            child: Icon(
                              Icons.group,
                              color: themeState.theme.colorScheme.primary,
                              size: 100,
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
                  leading: Icons.group,
                  title: TextField(
                    maxLength: 15,
                    controller: _groupProfileNameController,
                    decoration: const InputDecoration(
                      focusColor: Colors.white,
                      label: Text(
                        "Group Name",
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
                      _groupProfileNameController.text = '';
                    });
                  },
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
                        text: "Save",
                        onTap: () {
                          handleEditProfile(
                              _groupProfileNameController.text, '');
                        },
                        color: Colors.green[900],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ChatButton(
                        text: "Cancel",
                        onTap: () {
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
        );
      },
    );
  }
}
