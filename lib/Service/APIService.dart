import 'dart:convert';
import 'package:dio/dio.dart';
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
  final String baseUrl = "http://130.185.76.18:3030";
  final dio = Dio();

  //* Authentication
  Future<String> registerUser(String mobileNumber, String password) async {
    // final box = Hive.box('mybox');

    final url = Uri.parse('$baseUrl/api/Authentication/Register');

    try {
      var bodyRequest = {
        "mobileNumber": mobileNumber,
        "password": password,
      };

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(bodyRequest),
      );

      if (
          // int.parse(response.statusCode.toString()) == 200 ||
          response.statusCode == 201 || response.statusCode == 200) {
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

      if (
          // int.parse(response.statusCode.toString()) == 200 ||
          response.statusCode == 201 || response.statusCode == 200) {
        var bodyContent = json.decode(response.body);
        var user = User(
          id: bodyContent["id"],
          userName: bodyContent["userName"],
          mobileNumber: bodyContent["mobileNumber"],
          token: bodyContent["token"],
          type: userTypeConvertToEnum[bodyContent["type"]]!,
        );

        box.delete('userID');
        box.delete('userMobile');
        box.delete('userToken');
        box.delete('userType');

        box.put('userID', user.id);
        box.put('userMobile', user.mobileNumber);
        box.put('userToken', user.token);
        box.put('userType', bodyContent['type'].toString());

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

      if (
          // int.parse(response.statusCode.toString()) == 200 ||
          response.statusCode == 201 || response.statusCode == 200) {
        var bodyContent = json.decode(response.body);

        final List<UserChatItemDTO> userChatItems = [];

        for (var item in bodyContent) {
          userChatItems.add(
            UserChatItemDTO(
              id: item['id'],
              participant1ID: item['participant1ID'],
              participant1MobileNumber: item['participant1MobileNumber'],
              participant2ID: item['participant2ID'],
              participant2MobileNumber: item['participant2MobileNumber'],
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

        print(
            "_____________________________File Successfully Uploaded!_____________________________");
        print('file: ${file.id}');

        return file;
      } else {
        throw Exception("Failed to upload file: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during file upload: $e");
      rethrow;
    }
  }

  // Future<List<int>> downloadFile({
  //   required String token,
  //   required String id,
  // }) async {
  //   // final url = Uri.parse('$baseUrl/api/File/DownloadById');
  //   final url = '$baseUrl/api/File/DownloadById';

  //   try {
  //     var bodyRequest = {
  //       "id": id,
  //     };

  //     final response = await dio.post<List<int>>(
  //       url,
  //       options: Options(
  //         headers: {
  //           "Content-Type": "application/json",
  //           "Authorization": "Bearer $token"
  //         },
  //         responseType: ResponseType.bytes,
  //         method: 'POST',
  //       ),
  //       data: bodyRequest,
  //     );

  //     print(
  //         "Body Request: ${bodyRequest}_____________________________________________");

  //     if (
  //         // int.parse(response.statusCode.toString()) == 200 ||
  //         response.statusCode == 201 || response.statusCode == 200) {
  //       var bodyContent = json.decode(response.data);

  //       print(
  //           "Response: ${response}_____________________________________________");
  //       print(
  //           "Body Content: ${bodyContent}_____________________________________________");

  //       return bodyContent;
  //     } else {
  //       throw Exception(response.data);
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<List<int>> downloadFile({
    required String token,
    required String id,
  }) async {
    final url = '$baseUrl/api/File/DownloadById?id=$id';
    // final url =
    //     'http://130.185.76.18:3030/api/File/DownloadById?id=bd920d2c-5d00-48c9-bcea-b63b0ee621dd';

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
          responseType: ResponseType.bytes, // Ensures response is raw bytes
        ),
        // data: bodyRequest,
      );

      print("Body Request: $bodyRequest");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Response: ${response.statusCode}");
        print("Downloaded File Bytes: ${response.data}");

        return response.data as List<int>;
      } else {
        print("Unexpected Response: ${response.statusCode} - ${response.data}");
        throw Exception(
            'Failed to download file. Status: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 404) {
          throw Exception("The requested file was not found on the server.");
        }
      }
      print("Error occurred: $e");
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

        for (var item in bodyContent) {
          userChatItems.add(
            GroupChatItemDTO(
              id: item["id"],
              groupName: item["groupName"],
              lastMessageTime: item["lastMessageTime"],
              createdByID: item["createdByID"],
            ),
          );
          print("ITEM: ${item}");
        }

        return userChatItems;
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

        print(group);

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

        print("Members: ${members}");

        for (var member in members) {
          membersList.add(
            GroupMember(
              id: member["userID"],
              mobileNumber: member["mobileNumber"],
              userName: 'NULL',
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

    print("URL: ${url}");
    print("bodyRequest: ${bodyRequest}");

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
              userName: member["username"],
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

    print("URL: ${url}");
    print("bodyRequest: ${bodyRequest}");

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
              userName: member["username"],
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

      print(int.parse(response.statusCode.toString()));

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

        print("Message: ${message}");

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
}
