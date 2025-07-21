import 'package:Faleh_Hafez/domain/models/user.dart';

class GroupRole {
  String name;
  UserType userType;
  int userTypeInt;

  GroupRole({
    required this.name,
    required this.userType,
    required this.userTypeInt,
  });
  @override
  String toString() => name;
}
