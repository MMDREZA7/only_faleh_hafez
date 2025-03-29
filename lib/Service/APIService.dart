import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:faleh_hafez/application/authentiction/authentication_bloc.dart';
import 'package:faleh_hafez/domain/models/file_dto.dart';
import 'package:faleh_hafez/domain/models/group.dart';
import 'package:faleh_hafez/domain/models/group_chat_dto.dart';
import 'package:faleh_hafez/domain/models/group_member.dart';
import 'package:faleh_hafez/domain/models/massage_dto.dart';
import 'package:faleh_hafez/domain/models/user.dart';
import 'package:faleh_hafez/domain/models/user_chat_dto.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class APIService {
  final String baseUrl = "http://185.231.115.133:2966";
  final dio = Dio();

  //* Authentication
  Future<String> registerUser(
    String mobileNumber,
    String userName,
    String password,
  ) async {
    // final box = Hive.box('mybox');

    final url = Uri.parse('$baseUrl/api/Authentication/Register');

    try {
      var bodyRequest = {
        "mobileNumber": mobileNumber,
        "displayName": userName,
        "password": password,
      };

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(bodyRequest),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<User> loginUser(String mobileNumber, String password) async {
    final box = Hive.box('mybox');

    final url = Uri.parse('$baseUrl/api/Authentication/Login');
    try {
      var bodyRequest = {"mobileNumber": mobileNumber, "password": password};

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(bodyRequest),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        var bodyContent = json.decode(response.body);

        print(bodyContent['type'].runtimeType);
        print(bodyContent['type'].toString());

        var user = User(
          id: bodyContent["id"],
          mobileNumber: bodyContent["mobileNumber"],
          displayName: bodyContent["displayName"],
          token: bodyContent["token"],
          type: userTypeConvertToEnum[bodyContent['type']]!,
          profileImage: bodyContent["profileImage"],
        );

        box.delete('userID');
        box.delete('userName');
        box.delete('userMobile');
        box.delete('userToken');
        box.delete('userType');

        box.put('userID', user.id);
        box.put('userName', user.displayName);
        box.put('userMobile', user.mobileNumber);
        box.put('userToken', user.token);
        box.put('userType', bodyContent['type']);

        return user;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  //* Chat
  Future<List<UserChatItemDTO>> getUserChats({required String token}) async {
    final url = Uri.parse('$baseUrl/api/Chat/GetUserChats');

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        var bodyContent = json.decode(response.body);

        final List<UserChatItemDTO> userChatItems = [];

        for (var item in bodyContent) {
          userChatItems.add(
            UserChatItemDTO(
              id: item['id'],
              participant1ID: item['participant1ID'],
              participant1MobileNumber: item['participant1MobileNumber'],
              participant1DisplayName: item['participant1DisplayName'],
              participant2ID: item['participant2ID'],
              participant2MobileNumber: item['participant2MobileNumber'],
              participant2DisplayName: item['participant2DisplayName'],
              lastMessageTime: item['lastMessageTime'],
            ),
          );
        }

        return userChatItems;
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      rethrow;
    }
  }

  //* File
  Future<FileDTO> uploadFile({
    required String token,
    required String filePath,
    required String name,
    required String description,
  }) async {
    final dio = Dio();
    final url = '$baseUrl/api/File/UploadFile';

    try {
      FormData formData = FormData.fromMap({
        'File': await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
        'Name': name,
        'Description': description,
      });

      // Make a POST request
      final response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        var file = FileDTO(
          id: data["id"],
          address: data["address"],
        );

        return file;
      } else {
        throw Exception("Failed to upload file: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<int>> downloadFile({
    required String token,
    required String id,
  }) async {
    final url = '$baseUrl/api/File/DownloadById?id=$id';

    try {
      var bodyRequest = {
        "id": id,
      };

      final response = await dio.post(
        url,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as List<int>;
      } else {
        throw Exception(
            'Failed to download file. Status: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 404) {
          throw Exception("The requested file was not found on the server.");
        }
      }
      rethrow;
    }
  }

  //* Group
  Future<List<GroupChatItemDTO>> getGroupsChat({required String token}) async {
    final url = Uri.parse('$baseUrl/api/Group/GetUserGroups');

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (
          // int.parse(response.statusCode.toString()) == 200 ||
          response.statusCode == 201 || response.statusCode == 200) {
        var bodyContent = json.decode(response.body);

        final List<GroupChatItemDTO> userChatItems = [];

        //        {
        //   "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        //   "groupName": "string",
        //   "lastMessageTime": "2025-02-27T11:14:24.975Z",
        //   "createdByID": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        //   "profileImage": "string"
        // }

        for (var item in bodyContent) {
          userChatItems.add(
            GroupChatItemDTO(
              id: item["id"],
              groupName: item["groupName"],
              lastMessageTime: item["lastMessageTime"],
              createdByID: item["createdByID"],
              prifileImage: item['profileImage'] ?? '',
            ),
          );
        }

        return userChatItems;
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<GroupChatItemDTO> editGroupProfile({
    required String token,
    required String groupID,
    required String groupName,
    String? profileImage,
  }) async {
    final url = Uri.parse('$baseUrl/api/User/EditUserProfile');

    var bodyRequest = {
      groupID = groupID,
      groupName = groupName,
      profileImage = profileImage,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(bodyRequest),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        var group = json.decode(response.body);

        return GroupChatItemDTO(
          id: group["id"],
          groupName: group[groupName],
          lastMessageTime: group['lastMessageTime'],
          createdByID: group['createdByID'],
          prifileImage: group['prifileImage'],
        );
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Group> createGroup({
    required String groupName,
    required String token,
  }) async {
    // final box = Hive.box('mybox');

    final url = Uri.parse('$baseUrl/api/Group/CreateGroup');
    try {
      var bodyRequest = {"groupName": groupName};

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(bodyRequest),
      );

      if (
          // int.parse(response.statusCode.toString()) == 200 ||
          response.statusCode == 201 || response.statusCode == 200) {
        var bodyContent = json.decode(response.body);
        var group = Group(
          id: bodyContent["id"],
          groupName: bodyContent["groupName"],
          lastMessageTime: bodyContent["lastMessageTime"],
          createdByID: bodyContent["createdByID"],
        );

        return group;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  //* Group Member
  Future<List<GroupMember>> getGroupMembers({
    required String groupID,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/api/GroupMember/GetGroupMembers');

    var bodyRequest = {
      "groupID": groupID,
    };

    List<GroupMember> membersList = [];

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(bodyRequest),
      );

      if (
          // int.parse(response.statusCode.toString()) == 200 ||
          response.statusCode == 201 || response.statusCode == 200) {
        var members = json.decode(response.body);

        for (var member in members) {
          membersList.add(
            GroupMember(
              id: member["userID"],
              mobileNumber: member["mobileNumber"],
              displayName: member["displayName"],
              // userName: member["username"],
              type: groupMemberConvertToEnum[member["type"]]!,
            ),
          );
        }

        return membersList;
      } else {
        throw Exception(response);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<GroupMember>> addUserToGroup({
    required String groupID,
    required String userID,
    required int role,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/api/GroupMember/AddToGroup');

    var bodyRequest = {
      "groupID": groupID,
      "userID": userID,
      "role": role,
    };

    List<GroupMember> membersList = [];

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(bodyRequest),
      );

      if (
          // int.parse(response.statusCode.toString()) == 200 ||
          response.statusCode == 201 || response.statusCode == 200) {
        var members = json.decode(response.body);

        for (var member in members) {
          membersList.add(
            GroupMember(
              id: member["userID"],
              mobileNumber: member["mobileNumber"],
              displayName: member["displayName"],
              // type: member[groupMemberConvertToEnum["type"]]!,
              type: groupMemberConvertToEnum[member["type"]]!,
            ),
          );
        }

        return membersList;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  // ! Leave Groupe
  Future<List<GroupMember>> leaveGroup({
    required String groupID,
    required String userID,
    required int role,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/api/GroupMember/LeaveGroup');

    var bodyRequest = {
      "groupID": groupID,
      "userID": userID,
      "role": role,
    };

    List<GroupMember> membersList = [];

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(bodyRequest),
      );

      if (
          // int.parse(response.statusCode.toString()) == 200 ||
          response.statusCode == 201 || response.statusCode == 200) {
        var members = json.decode(response.body);

        for (var member in members) {
          membersList.add(
            GroupMember(
              id: member["userID"],
              mobileNumber: member["mobileNumber"],
              displayName: member["username"],
              // type: member[groupMemberConvertToEnum["type"]]!,
              type: groupMemberConvertToEnum[member["type"]]!,
            ),
          );
        }

        return membersList;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  //* Message
  Future<List<MessageDTO>> getChatMessages({
    required String chatID,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/api/Message/GetMessages');

    var bodyRequest = {
      "id": chatID,
    };

    List<MessageDTO> messagesList = [];

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(bodyRequest),
      );

      if (
          // // int.parse(response.statusCode.toString()) == 200 ||
          response.statusCode == 201 || response.statusCode == 200) {
        var messages = json.decode(response.body);

        for (var message in messages) {
          messagesList.add(
            MessageDTO(
              senderID: message["senderID"],
              text: message["text"],
              chatID: message["chatID"],
              groupID: message["groupID"],
              senderMobileNumber: message["senderMobileNumber"],
              receiverID: message["receiverID"],
              receiverMobileNumber: message["receiverMobileNumber"],
              sentDateTime: message["sentDateTime"],
              isRead: message["isRead"],
              attachFile: message["fileAttachment"] == null
                  ? null
                  : AttachmentFile(
                      fileAttachmentID: message["fileAttachment"]
                          ["fileAttachmentID"],
                      fileName: message["fileAttachment"]["fileName"],
                      fileSize: message["fileAttachment"]["fileSize"],
                      fileType: message["fileAttachment"]["fileType"],
                    ),
            ),
          );
        }

        return messagesList;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendMessage({
    required String token,
    required String receiverID,
    required String? fileAttachmentID,
    required String text,
  }) async {
    final url = Uri.parse('$baseUrl/api/Message/SendMessage');

    var bodyRequest = {
      "receiverID": receiverID,
      "text": text,
      "fileAttachmentID": fileAttachmentID == '' ? null : fileAttachmentID,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(bodyRequest),
      );

      if (
          // int.parse(response.statusCode.toString()) == 200 ||
          response.statusCode == 201 || response.statusCode == 200) {
        var message = json.decode(response.body);

        return message;
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      rethrow;
    }
  }

  //* User
  Future<String> getUserID({
    required String token,
    required String mobileNumber,
  }) async {
    final url = Uri.parse('$baseUrl/api/User/GetUserID');

    var bodyRequest = {
      "mobileNumber": mobileNumber,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(bodyRequest),
      );

      if (
          // int.parse(response.statusCode.toString()) == 200 ||
          response.statusCode == 201 || response.statusCode == 200) {
        var id = json.decode(response.body);
        return id;
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<User> editUser({
    required String token,
    required String displayName,
    String? profileImage,
  }) async {
    final url = Uri.parse('$baseUrl/api/User/EditUserProfile');

    var bodyRequest = {
      "displayName": displayName,
      // "profileImage": profileImage,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(bodyRequest),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        var user = json.decode(response.body);

        box.delete('userID');
        box.delete('userName');
        box.delete('userMobile');
        box.delete('userToken');
        box.delete('userType');

        box.put('userID', user.id);
        box.put('userName', user.displayName);
        box.put('userMobile', user.mobileNumber);
        box.put('userToken', user.token);
        box.put('userType', user['type']);

        return User(
          id: user["userId"],
          displayName: user["displayName"],
          mobileNumber: user["mobileNumber"],
          profileImage: user["profileImage"],
          type: userTypeConvertToEnum[user["type"]],
        );
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      rethrow;
    }
  }
}
