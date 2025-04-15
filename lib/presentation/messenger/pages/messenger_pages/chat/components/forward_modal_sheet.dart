import 'package:faleh_hafez/Service/APIService.dart';
import 'package:faleh_hafez/domain/models/message_dto.dart';
import 'package:faleh_hafez/domain/models/user.dart';
import 'package:faleh_hafez/domain/models/user_chat_dto.dart';
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
  List<UserChatItemDTO> chats = [];
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

    getChatsMessage();
  }

  void getChatsMessage() async {
    final fetchedChats =
        await APIService().getUserChats(token: userProfile.token!);
    setState(() {
      chats = fetchedChats;
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

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Message forwarded!")),
        );

        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
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
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
                childAspectRatio: 1,
              ),
              itemCount: chats.length,
              itemBuilder: (context, index) {
                var guestDisplayName = userProfile.displayName ==
                        chats[index].participant1DisplayName
                    ? chats[index].participant2DisplayName
                    : chats[index].participant1DisplayName;
                var guestNumber = userProfile.mobileNumber ==
                        chats[index].participant1MobileNumber
                    ? chats[index].participant2MobileNumber
                    : chats[index].participant1MobileNumber;
                var guestID = userProfile.id == chats[index].participant1ID
                    ? chats[index].participant2ID
                    : chats[index].participant1ID;
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
        ],
      ),
    );
  }
}
