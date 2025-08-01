import 'dart:async';
import 'package:Faleh_Hafez/Service/signal_r/SignalR_Service.dart';
import 'package:bloc/bloc.dart';
import 'package:Faleh_Hafez/Service/APIService.dart';
import 'package:Faleh_Hafez/application/authentiction/authentication_bloc.dart';
import 'package:Faleh_Hafez/domain/models/group_chat_dto.dart';
import 'package:Faleh_Hafez/domain/models/group_member.dart';
import 'package:Faleh_Hafez/domain/models/user.dart';
import 'package:Faleh_Hafez/domain/models/user_chat_dto.dart';
import 'package:flutter/foundation.dart';

part 'chat_items_event.dart';
part 'chat_items_state.dart';

class ChatItemsBloc extends Bloc<ChatItemsEvent, ChatItemsState> {
  List<UserChatItemDTO> privatesList = [];
  List<GroupChatItemDTO> publicsList = [];

  ChatItemsBloc() : super(ChatItemsInitial()) {
    on<ChatItemsGetPrivateChatsEvent>(_fetchPrivateChats);
    on<ChatItemsGetPublicChatsEvent>(_fetchPublicChats);
    // on<ChatItemsGetGroupMembersEvent>(_getGroupMembers);
    // on<ChatItemsAddNewMemberToGroupEvent>(_addNewMember);
    // on<ChatItemsleaveGroupEvent>(_leaveGroup);
    on<ChatItemsDeletePrivateChatEvent>(_deleteChat);
    on<ChatItemsEditProfileUserEvent>(_editProfile);
    on<ChatItemsMoveChatToTopEvent>(_moveChatToTop);
    on<ChatItemsReadMessageEvent>(_readMessage);
  }

  FutureOr<void> _fetchPrivateChats(
    ChatItemsGetPrivateChatsEvent event,
    Emitter<ChatItemsState> emit,
  ) async {
    try {
      final response = await APIService().getUserChats(token: event.token);

      if (response.isEmpty) {
        emit(ChatItemsEmpty());
        return;
      }

      privatesList = response;

      emit(ChatItemsPrivateChatsLoaded(userChatItems: privatesList));
    } catch (e) {
      emit(
        ChatItemsError(
            errorMessage: e.toString().contains(':')
                ? e.toString().split(':')[1]
                : e.toString()),
      );
    }
  }

  FutureOr<void> _fetchPublicChats(
    ChatItemsGetPublicChatsEvent event,
    Emitter<ChatItemsState> emit,
  ) async {
    try {
      final response = await APIService().getGroupsChat(token: event.token);

      if (response.isEmpty) {
        emit(ChatItemsEmpty());
        return;
      }

      publicsList = response;

      emit(
        ChatItemsPublicChatsLoaded(
          groupChatItem: publicsList,
        ),
      );
    } catch (e) {
      emit(
        ChatItemsError(
          errorMessage: e.toString().contains(':')
              ? e.toString().split(':')[1]
              : e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _deleteChat(
    ChatItemsDeletePrivateChatEvent event,
    Emitter<ChatItemsState> emit,
  ) async {
    emit(ChatItemsLoading());

    try {
      var index = privatesList.indexWhere(
        (element) => element.id == event.chatID,
      );

      await APIService().deleteChat(
        token: event.token,
        chatID: event.chatID,
      );

      if (index != -1) {
        privatesList.removeAt(index);

        emit(
          ChatItemsPrivateChatsLoaded(
            userChatItems: privatesList,
          ),
        );
        // add(
        //   ChatItemsGetPrivateChatsEvent(
        //     token: event.token,
        //   ),
        // );
      }
    } catch (e) {
      emit(
        ChatItemsGroupMembersError(
          errorMessage: e.toString().contains(':')
              ? e.toString().split(':')[1]
              : e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _editProfile(
    ChatItemsEditProfileUserEvent event,
    Emitter<ChatItemsState> emit,
  ) async {
    emit(ChatItemsLoading());

    try {
      User response = await APIService().editUser(
        token: event.token,
        displayName: event.displayName,
        profileImage: event.profileImage,
      );

      // emit(
      //   ChatItemsEditProfileLoaded(user: response),
      // );
      add(
        ChatItemsGetPrivateChatsEvent(
          token: event.token,
        ),
      );

      box.delete('userName');
      box.delete('userID');
      box.delete('userMobile');
      box.delete('userImage');
      box.delete('userType');

      box.put('userName', response.displayName);
      box.put('userID', response.id);
      box.put('userMobile', response.mobileNumber);
      box.put('userImage', response.profileImage);
      box.put("userType", userTypeConvertToJson[response.type]);
    } catch (e) {
      emit(
        ChatItemsError(
          errorMessage: e.toString().contains(':')
              ? e.toString().split(':')[1]
              : e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _moveChatToTop(
    ChatItemsMoveChatToTopEvent event,
    Emitter<ChatItemsState> emit,
  ) async {
    emit(ChatItemsLoading());

    if (event.groupChatID != null && event.groupChatID != '') {
      var groupIndex =
          publicsList.indexWhere((group) => group.id == event.groupChatID);

      GroupChatItemDTO groupChat = publicsList.firstWhere(
        (group) => group.id == event.groupChatID,
        orElse: () => throw Exception("Group chat not found"),
      );

      if (groupIndex != -1) {
        publicsList.removeAt(groupIndex);
      }

      if (event.isSentByMe == true) {
        publicsList.insert(0, groupChat);
      } else {
        publicsList.insert(0, groupChat.copyWith(hasNewMessage: true));
      }

      emit(
        ChatItemsPublicChatsLoaded(groupChatItem: publicsList),
      );
    }
    if (event.userChatID != null && event.userChatID != '') {
      if (event.userChatID != null && event.userChatID != '') {
        var userIndex =
            privatesList.indexWhere((user) => user.id == event.userChatID);

        UserChatItemDTO userChat = privatesList.firstWhere(
          (user) => user.id == event.userChatID,
          orElse: () => throw Exception("User chat not found"),
        );

        if (userIndex != -1) {
          privatesList.removeAt(userIndex);
        }

        if (event.isSentByMe == true) {
          privatesList.insert(0, userChat);
        } else {
          privatesList.insert(0, userChat.copyWith(hasNewMessage: true));
        }

        emit(
          ChatItemsPrivateChatsLoaded(userChatItems: privatesList),
        );
      }
      emit(
        ChatItemsPrivateChatsLoaded(userChatItems: privatesList),
      );
    } else {
      Exception("Coulden't find Chat");
    }
  }

  FutureOr<void> _readMessage(
    ChatItemsReadMessageEvent event,
    Emitter<ChatItemsState> emit,
  ) async {
    emit(ChatItemsLoading());

    if (event.groupChatItem?.id != null && event.groupChatItem?.id != '') {
      var groupIndex = publicsList
          .indexWhere((group) => group.id == event.groupChatItem!.id);

      GroupChatItemDTO groupChat = publicsList.firstWhere(
        (group) => group.id == event.groupChatItem!.id,
        orElse: () => throw Exception("Group chat not found"),
      );

      if (groupIndex != -1) {
        publicsList.removeAt(groupIndex);
      }

      publicsList.insert(groupIndex, groupChat.copyWith(hasNewMessage: false));

      emit(
        ChatItemsPublicChatsLoaded(groupChatItem: publicsList),
      );
    }
    if (event.userChatItem?.id != null && event.userChatItem?.id != '') {
      var userIndex =
          privatesList.indexWhere((user) => user.id == event.userChatItem!.id);

      UserChatItemDTO userChat = privatesList.firstWhere(
        (user) => user.id == event.userChatItem!.id,
        orElse: () => throw Exception("User chat not found"),
      );

      if (userIndex != -1) {
        privatesList.removeAt(userIndex);
      }

      privatesList.insert(userIndex, userChat.copyWith(hasNewMessage: false));

      emit(
        ChatItemsPrivateChatsLoaded(userChatItems: privatesList),
      );
    } else {
      Exception("Coulden't find Chat");
    }
  }
}
