import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:Faleh_Hafez/application/authentiction/authentication_bloc.dart';
import 'package:Faleh_Hafez/domain/models/file_dto.dart';
import 'package:Faleh_Hafez/domain/models/group.dart';
import 'package:Faleh_Hafez/domain/models/group_chat_dto.dart';
import 'package:Faleh_Hafez/domain/models/group_member.dart';
import 'package:Faleh_Hafez/domain/models/message_dto.dart';
import 'package:Faleh_Hafez/domain/models/user.dart';
import 'package:Faleh_Hafez/domain/models/user_chat_dto.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'commons.dart';

class APIService {
  // String baseUrl = "http://192.168.1.107:6060";
  String baseUrl = "http://192.168.2.11:6060";
  // String baseUrl = "http://185.231.115.133:2966";
  // final String stBaseUrl = "http://185.231.115.133:2966";
  // final String ndbaseUrl = "http://192.168.2.11:6060";
  // final String rdBaseUrl = "http://192.168.1.107:6060";
  final dio = Dio();

  Future<String> getLocalFilePath(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final folderPath = '${directory.path}/MyApp/Images';

    final dir = Directory(folderPath);
    if (!(await dir.exists())) {
      await dir.create(recursive: true);
    }

    return '$folderPath/$fileName';
  }

  String firstOne = '8fBzT7wqLx';
  String secondOne = 'LuKKaA0HsRg';
  String completeKey = '8fBzT7wqLxLuKKaA0HsRgLuKKaA0HsRg';

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
        box.delete('userImage');

        box.put('userID', user.id);
        box.put('userName', user.displayName);
        box.put('userMobile', user.mobileNumber);
        box.put('userToken', user.token);
        box.put('userType', userTypeConvertToJson[user.type]);
        box.put('userImage', user.profileImage);

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
              participant1ProfileImage: item['participant1ProfileImage'],
              participant2ID: item['participant2ID'],
              participant2MobileNumber: item['participant2MobileNumber'],
              participant2DisplayName: item['participant2DisplayName'],
              participant2ProfileImage: item['participant2ProfileImage'],
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

  Future<http.Response> deleteChat(
      {required String token, required String chatID}) async {
    final url = Uri.parse('$baseUrl/api/Chat/DeleteChat');

    var bodyRequest = {
      "chatID": chatID,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(bodyRequest),
        // body: bodyRequest,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // var message = json.decode(response.body);
        return response;
      } else {
        final errorText =
            response.body.isEmpty ? response.reasonPhrase : response.body;
        throw Exception(errorText);
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

        await APIService().downloadFile(
          token: token,
          id: file.id!,
        );

        return file;
      } else {
        print("Failed to upload file: ${response.statusCode}");
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
    final localPath = await getLocalFilePath('$id.bin');
    final file = File(localPath);

    if (await file.exists()) {
      print("📦 File exists locally. Returning bytes from storage.");
      return await file.readAsBytes();
    }

    final url = '$baseUrl/api/File/DownloadById?id=$id';

    try {
      final response = await Dio().post(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200) {
        await file.writeAsBytes(response.data);
        print("✅ File downloaded and saved.");
        return response.data as List<int>;
      } else {
        throw Exception('❌ Download failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("❌ Download error: $e");
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
              profileImage: item['profileImage'] ?? '',
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
    final url = Uri.parse('$baseUrl/api/Group/UpdateGroupProfile');

    var bodyRequest = {
      "groupID": groupID,
      "groupName": groupName,
      "profileImage": profileImage,
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
          groupName: group["groupName"],
          lastMessageTime: group['lastMessageTime'],
          createdByID: group['createdByID'],
          profileImage: group['profileImage'],
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
              profileImage: member["profileImage"],
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
              profileImage: member["profileImage"],
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

  Future<List<GroupMember>> leaveGroup({
    required String groupID,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/api/GroupMember/LeaveGroup');

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
              displayName: member["username"],
              profileImage: member["profileImage"],
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

  Future<List<GroupMember>> kickMember({
    required String groupID,
    required String userID,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/api/GroupMember/KickMember');

    var bodyRequest = {
      "groupID": groupID,
      "userID": userID,
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
              profileImage: member["profileImage"],
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
          // DEC
          var mainText = "";
          try {
            final key = Key.fromUtf8(completeKey);

            final encrypter = Encrypter(AES(key));
            print(Commons.iv.base64);

            mainText = encrypter.decrypt(Encrypted.fromBase64(message["text"]),
                iv: Commons.iv);
          } catch (ex) {
            print("ECEPTION");
            print(ex);
            print(message["text"]);
            mainText = message["text"];
          }
          // DEC

          messagesList.add(
            MessageDTO(
              messageID: message['messageID'],
              senderID: message["senderID"],
              text: mainText,
              chatID: message["chatID"],
              groupID: message["groupID"],
              senderMobileNumber: message["senderMobileNumber"],
              receiverID: message["receiverID"],
              receiverMobileNumber: message["receiverMobileNumber"],
              sentDateTime: message["sentDateTime"],
              senderDisplayName: message["senderDisplayName"],
              receiverDisplayName: message["receiverDisplayName"],
              isRead: message["isRead"],
              replyToMessageID: message["replyToMessageID"],
              replyToMessageText: message["replyToMessageText"],
              isEdited: message["isEdited"],
              forwardedFromDisplayName: message["forwardedFromDisplayName"],
              isForwarded: message["isForwarded"],
              forwardedFromID: message["isForwardedFromID"],
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
        throw Exception(
            response.body == '' ? response.reasonPhrase : response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendMessage({
    required String token,
    required String mobileNumber,
    required String receiverID,
    required String text,
    String? fileAttachmentID,
    String? replyToMessageID,
  }) async {
    final url = Uri.parse('$baseUrl/api/Message/SendMessage');

    // ENC
    // String keyString =
    //     (firstOne + mobileNumber + secondOne).padRight(32).substring(0, 32);
    // var myID = box.get('userID');
    // final key = Key.fromUtf8(firstOne + mobileNumber + secondOne);

    // final encrypter = Encrypter(AES(key));

    // final encrypted = encrypter.encrypt(text, iv: Commons.iv);

    // print(completeKey.length);
    final key = Key.fromUtf8(completeKey);

    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(text, iv: Commons.iv);
    // ENC

    var bodyRequest = {
      "receiverID": receiverID,
      "text": encrypted.base64,
      "fileAttachmentID": fileAttachmentID != '' ? fileAttachmentID : null,
      "replyToMessageID": replyToMessageID,
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
        var message = json.decode(response.body);
        print("Message Sended!: ${message}");
        return message;
      } else {
        final errorText =
            response.body.isEmpty ? response.reasonPhrase : response.body;
        throw Exception(errorText);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> forwardMessage({
    required String token,
    required String messageID,
    required String forwardToID,
  }) async {
    final url = Uri.parse('$baseUrl/api/Message/ForwardMessage');

    var bodyRequest = {
      "messageID": messageID,
      "forwardToID": forwardToID,
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
        var message = json.decode(response.body);

        return message;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<MessageDTO> deleteMessage({
    required String token,
    required String messageID,
  }) async {
    final url = Uri.parse('$baseUrl/api/Message/DeleteMessage');

    var bodyRequest = {
      "messageID": messageID,
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
        var message = json.decode(response.body);

        return MessageDTO(
          messageID: message['messageID'],
        );
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> editMessage({
    required String token,
    required String messageID,
    required String text,
  }) async {
    final url = Uri.parse('$baseUrl/api/Message/EditMessage');

    var bodyRequest = {
      "messageID": messageID,
      "text": text,
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
        var message = json.decode(response.body);

        return message;
      } else {
        throw Exception(response.body);
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
        throw Exception(
          response.reasonPhrase == 'Bad Request'
              ? response.body
              : response.reasonPhrase,
        );
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
      "profileImage": profileImage,
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
        // box.delete('userToken');
        box.delete('userImage');
        box.delete('userType');

        box.put('userID', user["userId"]);
        box.put('userName', user["displayName"]);
        box.put('userMobile', user["mobileNumber"]);
        // box.put('userToken', user["userToken"]);
        box.put('userImage', user["profileImage"]);
        box.put('userType', user['type']);

        return User(
          id: user["userID"],
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

  Future<User> changePassword({
    required String token,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    final url = Uri.parse('$baseUrl/api/User/ChangePassword');

    var bodyRequest = {
      "newPassword": newPassword,
      "confirmNewPassword": confirmNewPassword
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
