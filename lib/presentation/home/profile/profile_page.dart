import 'package:faleh_hafez/domain/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = User(
    id: 'id',
    userName: 'userName',
    mobileNumber: 'mobileNumber',
    token: 'token',
    type: UserType.Guest,
  );
  @override
  void initState() {
    var box = Hive.box('mybox');

    // var user = User(
    //   id: '1654684651-651651-81651651-651651',
    //   mobileNumber: '09000000000',
    //   token: 'asg561asg32sa1gasgsa54651sa6g51as65g165',
    //   type: UserType.Regular,
    // );
    // ignore: unused_local_variable
    final user = User(
      id: box.get("userID"),
      userName: box.get("userName"),
      mobileNumber: box.get("userMobile"),
      token: box.get("userToken"),
      type: userTypeConvertToEnum[int.parse(box.get("userType"))]!,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.phone),
            title: Text(user.mobileNumber),
            trailing: IconButton(
              onPressed: () {
                ClipboardData(text: user.mobileNumber);
              },
              icon: const Icon(Icons.copy),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
