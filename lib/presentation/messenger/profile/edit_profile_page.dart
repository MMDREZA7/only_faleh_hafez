import 'package:faleh_hafez/application/chat_items/chat_items_bloc.dart';
import 'package:faleh_hafez/application/chat_theme_changer/chat_theme_changer_bloc.dart';
import 'package:faleh_hafez/domain/models/user.dart';
import 'package:faleh_hafez/presentation/home/components/button.dart';
import 'package:faleh_hafez/presentation/messenger/pages/messenger_pages/chat/components/chatButton.dart';
import 'package:faleh_hafez/presentation/messenger/profile/items_container.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

TextEditingController _displayNameController =
    TextEditingController(text: displayNameUser);

class _EditProfilePageState extends State<EditProfilePage> {
  bool isThemeDark = true;
  String theme = '';

  @override
  void initState() {
    var box = Hive.box('mybox');

    _displayNameController =
        TextEditingController(text: widget.userProfile.displayName ?? '');

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
    }

    // var user = User(
    //   id: '1654684651-651651-81651651-651651',
    //   mobileNumber: '09000000000',
    //   token: 'asg561asg32sa1gasgsa54651sa6g51as65g165',
    //   type: UserType.Regular,
    // );

    // ignore: unused_local_variable
    // final widget.userProfile = User(
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
    handleEditProfile(String displayName, String profileImage) {
      context.read<ChatItemsBloc>().add(
            ChatItemsEditProfileUser(
              token: widget.userProfile.token!,
              displayName:
                  _displayNameController.text != widget.userProfile.displayName
                      ? _displayNameController.text
                      : widget.userProfile.displayName ?? '',
            ),
          );
      Navigator.pop(context);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        leading: const SizedBox(),
        backgroundColor: Colors.transparent,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Expanded(
          child: Column(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(500),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 10,
                  ),
                ),
                child: widget.userProfile.profileImage != null
                    ? Image(
                        fit: BoxFit.cover,
                        height: 200,
                        image: AssetImage(
                          widget.userProfile.profileImage!,
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
                title: TextField(
                  controller: _displayNameController,
                  decoration: InputDecoration(
                    focusColor: Colors.white,
                    label: Text(
                      widget.userProfile.displayName != null
                          ? 'Your Name is ${widget.userProfile.displayName}'
                          : "You havn't any Name",
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              ProfileItemsContainer(
                marginButtom: 10,
                leading: Icons.phone,
                title: widget.userProfile.mobileNumber,
                trailingIcon: Icons.copy,
                onClickTrailingButton: () {
                  ClipboardData(
                    text: widget.userProfile.mobileNumber!,
                  );
                  context.showInfoBar(
                      content: Text(
                          "[ ${widget.userProfile.mobileNumber} ] Copied!"));
                },
              ),
              ProfileItemsContainer(
                boxColor: Colors.grey[400],
                leadingColor: isThemeDark ? Colors.grey[500] : Colors.grey[200],
                leading: Icons.color_lens,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Dark"),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: Switch(
                        trackColor: MaterialStatePropertyAll(
                          isThemeDark ? Colors.grey[200] : Colors.grey[500],
                        ),
                        thumbColor: MaterialStatePropertyAll(
                          isThemeDark ? Colors.grey[700] : Colors.grey[200],
                        ),
                        trackOutlineColor: MaterialStatePropertyAll(
                          Colors.grey.shade600,
                        ),
                        value: isThemeDark,
                        onChanged: (value) {},
                      ),
                    ),
                    const Text("Light"),
                  ],
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
                      text: "Save",
                      onTap: () {
                        handleEditProfile(_displayNameController.text, '');
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
      ),
    );
  }
}
