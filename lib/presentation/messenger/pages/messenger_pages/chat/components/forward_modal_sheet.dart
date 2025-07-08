import 'package:Faleh_Hafez/Service/APIService.dart';
import 'package:Faleh_Hafez/domain/models/group_chat_dto.dart';
import 'package:Faleh_Hafez/domain/models/message_dto.dart';
import 'package:Faleh_Hafez/domain/models/user.dart';
import 'package:Faleh_Hafez/domain/models/user_chat_dto.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class ForwardModalSheet extends StatefulWidget {
  final MessageDTO message;
  const ForwardModalSheet({
    super.key,
    required this.message,
  });

  @override
  State<ForwardModalSheet> createState() => _ForwardModalSheetState();
}

class _ForwardModalSheetState extends State<ForwardModalSheet> {
  List<UserChatItemDTO> privateChats = [];
  List<GroupChatItemDTO> publicChats = [];
  var userProfile = User(
    id: '',
    displayName: '',
    mobileNumber: '',
    profileImage: '',
    token: '',
    type: UserType.Guest,
  );

  @override
  void initState() {
    super.initState();

    var box = Hive.box('mybox');

    userProfile = User(
      id: box.get('userID'),
      displayName: box.get('userName'),
      mobileNumber: box.get('userMobile'),
      profileImage: box.get('userImage'),
      token: box.get('userToken'),
      type: userTypeConvertToEnum[box.get('userType')],
    );

    getPrivateChats();
    getPublicChats();
  }

  void getPrivateChats() async {
    final fetchedChats =
        await APIService().getUserChats(token: userProfile.token!);
    setState(() {
      privateChats = fetchedChats;
    });
  }

  void getPublicChats() async {
    final fetchedChats =
        await APIService().getGroupsChat(token: userProfile.token!);
    setState(() {
      publicChats = fetchedChats;
    });
  }

  @override
  Widget build(BuildContext context) {
    void handleForwardMessage(forwardToID) async {
      try {
        await APIService().forwardMessage(
          token: userProfile.token!,
          messageID: widget.message.messageID,
          forwardToID: forwardToID,
        );

        // ignore: use_build_context_synchronously
        context.showSuccessBar(
          content: Text("Message forwarded!"),
        );

        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      } catch (e) {
        // ignore: use_build_context_synchronously
        context.showErrorBar(
          content: Text(e.toString()),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Center(
            child: Text(
              "Forward to ....",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),

          //! PRIVATE CHATS LIST
          const Row(
            children: [
              Text("Private Chats:",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),

          Expanded(
            flex: 3,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
                childAspectRatio: 1,
              ),
              itemCount: privateChats.length,
              itemBuilder: (context, index) {
                var guestDisplayName = userProfile.displayName ==
                        privateChats[index].participant1DisplayName
                    ? privateChats[index].participant2DisplayName
                    : privateChats[index].participant1DisplayName;
                var guestNumber = userProfile.mobileNumber ==
                        privateChats[index].participant1MobileNumber
                    ? privateChats[index].participant2MobileNumber
                    : privateChats[index].participant1MobileNumber;
                var guestID =
                    userProfile.id == privateChats[index].participant1ID
                        ? privateChats[index].participant2ID
                        : privateChats[index].participant1ID;
                if (guestDisplayName != null) {
                  return GestureDetector(
                    onTap: () => handleForwardMessage(guestID),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.white,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Column(
                            children: [
                              Text(
                                guestDisplayName,
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                guestNumber,
                                style: const TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return GestureDetector(
                  onTap: () => handleForwardMessage(guestID),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Column(
                          children: [
                            Text(
                              guestNumber,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(
            color: Theme.of(context).colorScheme.onBackground,
          ),

          //! PUBLIC CHATS LIST
          const Row(
            children: [
              Text("Public Chats:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
          // Expanded(
          //   child: GridView.builder(
          //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: publicChats.length,
          //       crossAxisSpacing: 1,
          //       mainAxisSpacing: 1,
          //       childAspectRatio: 1,
          //     ),
          //     itemCount: publicChats.length,
          //     itemBuilder: (context, index) {
          //       var groupName = publicChats[index].groupName;
          //       var groupID = publicChats[index].id;
          //       return GestureDetector(
          //         onTap: () => handleForwardMessage(groupID),
          //         child: Container(
          //           padding: const EdgeInsets.all(10),
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             children: [
          //               const CircleAvatar(
          //                 backgroundColor: Colors.white,
          //               ),
          //               const SizedBox(
          //                 height: 5,
          //               ),
          //               Column(
          //                 children: [
          //                   Text(
          //                     groupName,
          //                     style: const TextStyle(fontSize: 15),
          //                   ),
          //                 ],
          //               ),
          //             ],
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),

          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: publicChats.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                var groupName = publicChats[index].groupName;
                var groupID = publicChats[index].id;

                return GestureDetector(
                  onTap: () => handleForwardMessage(groupID),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Column(
                          children: [
                            Text(
                              groupName,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
