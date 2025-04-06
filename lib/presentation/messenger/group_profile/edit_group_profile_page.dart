import 'package:faleh_hafez/Service/APIService.dart';
import 'package:faleh_hafez/application/authentiction/authentication_bloc.dart';
import 'package:faleh_hafez/application/chat_items/chat_items_bloc.dart';
import 'package:faleh_hafez/domain/models/group_chat_dto.dart';
import 'package:faleh_hafez/domain/models/user.dart';
import 'package:faleh_hafez/presentation/messenger/pages/messenger_pages/chat/components/chatButton.dart';
import 'package:faleh_hafez/presentation/messenger/user_profile/items_container.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

TextEditingController _groupProfileNameController =
    TextEditingController(text: groupProfileName);

class _EditGroupProfilePageState extends State<EditGroupProfilePage> {
  bool isThemeDark = true;
  String theme = '';
  String userProfileToken = '';
  User userProfile = User(id: '');

  @override
  void initState() {
    var box = Hive.box('mybox');

    _groupProfileNameController =
        TextEditingController(text: widget.groupProfile.groupName ?? '');

    userProfile = User(
      id: box.get('userID'),
      displayName: box.get('userName'),
      mobileNumber: box.get('userMobile'),
      profileImage: box.get('userImage'),
      token: box.get('userToken'),
      type: box.get('userType'),
    );

    super.initState();
  }

  @override
  void didUpdateWidget(covariant EditGroupProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.groupProfile.groupName != oldWidget.groupProfile.groupName) {
      _groupProfileNameController.text = widget.groupProfile.groupName ?? '';
    }
  }

  // Future<Uint8List?> _loadUserImage() async {
  //   final imageId = box.get("userImage");

  //   if (imageId != null) {
  //     try {
  //       List<int> imageData = await APIService().downloadFile(
  //         token: userProfile.token!,
  //         id: imageId,
  //       );
  //       return Uint8List.fromList(imageData);
  //     } catch (e) {
  //       debugPrint("Error loading profile image: $e");
  //     }
  //   }
  //   return null;
  // }

  @override
  Widget build(BuildContext context) {
    handleEditProfile(String groupName, String groupProfileImage) {
      APIService().editGroupProfile(
        token: userProfileToken,
        groupID: widget.groupProfile.id,
        groupName: groupName,
        profileImage: groupProfileImage,
      );
      Navigator.pop(context);
      Navigator.pop(context);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        leading: const SizedBox(),
        backgroundColor: Colors.transparent,
        title: Text(
          "Edit Group Profile",
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
            // FutureBuilder<Uint8List?>(
            //   future: _loadUserImage(),
            //   builder: (context, snapshot) {
            //     Widget imageWidget;

            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       imageWidget = const CircularProgressIndicator();
            //     } else if (snapshot.hasData && snapshot.data != null) {
            //       imageWidget = CircleAvatar(
            //         radius: 50,
            //         backgroundImage: MemoryImage(snapshot.data!),
            //       );
            //     } else {
            //       imageWidget = CircleAvatar(
            //         radius: 50,
            //         child: Icon(
            //           Icons.person,
            //           color: Theme.of(context).colorScheme.primary,
            //           size: 50,
            //         ),
            //       );
            //     }
            //     return imageWidget;
            //   },
            // ),
            ProfileItemsContainer(
              marginButtom: 10,
              leading: Icons.person,
              title: TextField(
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
                      handleEditProfile(_groupProfileNameController.text, '');
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
}
