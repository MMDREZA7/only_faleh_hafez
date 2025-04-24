import 'package:faleh_hafez/application/chat_items/chat_items_bloc.dart';
import 'package:faleh_hafez/application/chat_theme_changer/chat_theme_changer_bloc.dart';
import 'package:faleh_hafez/domain/models/group_chat_dto.dart';
import 'package:faleh_hafez/domain/models/user.dart';
import 'package:faleh_hafez/presentation/messenger/group_profile/edit_group_profile_page.dart';
import 'package:faleh_hafez/presentation/messenger/pages/messenger_pages/chat/components/chatButton.dart';
import 'package:faleh_hafez/presentation/messenger/user_profile/items_container.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class GroupProfilePage extends StatefulWidget {
  final GroupChatItemDTO? group;

  const GroupProfilePage({
    super.key,
    this.group,
  });

  @override
  State<GroupProfilePage> createState() => _GroupProfilePageState();
}

class _GroupProfilePageState extends State<GroupProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Group Profile",
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
              child:
                  //  userProfile.profileImage != null
                  // ? Image(
                  //     fit: BoxFit.cover,
                  //     height: 200,
                  //     image: AssetImage(
                  //       userProfile.profileImage!,
                  //     ),
                  //   )
                  // :
                  Icon(
                Icons.person,
                size: 150,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            ProfileItemsContainer(
              marginButtom: 15,
              leading: Icons.person,
              title: widget.group!.groupName,

              // ?? userProfile.displayName,
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
                            create: (context) => context.read<ChatItemsBloc>(),
                            // create: (context) => ChatItemsBloc(),
                            child: EditGroupProfilePage(
                              groupProfile: widget.group!,
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
