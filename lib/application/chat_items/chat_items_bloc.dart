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
    on<ChatItemsEditProfileUser>(_editProfile);
  }

  FutureOr<void> _fetchPrivateChats(
    ChatItemsGetPrivateChatsEvent event,
    Emitter<ChatItemsState> emit,
  ) async {
    emit(ChatItemsLoading());

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
    emit(ChatItemsLoading());

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

  // FutureOr<void> _getGroupMembers(
  //   ChatItemsGetGroupMembersEvent event,
  //   Emitter<ChatItemsState> emit,
  // ) async {
  //   emit(ChatItemsGroupMembersLoading());

  //   try {
  //     final response = await APIService().getGroupMembers(
  //       token: event.token,
  //       groupID: event.groupID,
  //     );

  //     if (response.isEmpty) {
  //       emit(ChatItemsEmpty());
  //       return;
  //     }

  //     emit(
  //       ChatItemsGroupMembersLoaded(
  //         groupMembers: response,
  //       ),
  //     );
  //   } catch (e) {
  //     emit(
  //       ChatItemsError(
  //         errorMessage: e.toString().contains(':')
  //             ? e.toString().split(':')[1]
  //             : e.toString(),
  //       ),
  //     );
  //   }
  // }

  // FutureOr<void> _addNewMember(
  //   ChatItemsAddNewMemberToGroupEvent event,
  //   Emitter<ChatItemsState> emit,
  // ) async {
  //   emit(ChatItemsGroupMembersLoading());

  //   try {
  //     String userID = await APIService().getUserID(
  //       token: event.token,
  //       mobileNumber: event.mobileNumber,
  //     );

  //     // List<GroupMember> response =
  //     // var response =
  //     await APIService().addUserToGroup(
  //       token: event.token,
  //       groupID: event.groupID,
  //       role: event.role,
  //       userID: userID,
  //     );

  //     // emit(
  //     //   ChatItemsGroupMembersLoaded(
  //     //     groupMembers: response,
  //     //   ),
  //     // );
  //     add(
  //       ChatItemsGetGroupMembersEvent(
  //         token: userProfile.token!,
  //         groupID: event.groupID,
  //       ),
  //     );
  //   } catch (e) {
  //     emit(
  //       ChatItemsGroupMembersError(
  //         errorMessage: e.toString().contains(':')
  //             ? e.toString().split(':')[1]
  //             : e.toString(),
  //       ),
  //     );
  //   }
  // }

  // FutureOr<void> _leaveGroup(
  //   ChatItemsleaveGroupEvent event,
  //   Emitter<ChatItemsState> emit,
  // ) async {
  //   emit(ChatItemsLoading());

  //   try {
  //     var index = publicsList.indexWhere(
  //       (element) => element.id == event.groupID,
  //     );

  //     await APIService().leaveGroup(
  //       token: event.token,
  //       groupID: event.groupID,
  //     );

  //     if (index != -1) {
  //       publicsList.removeAt(index);

  //       emit(
  //         ChatItemsPublicChatsLoaded(
  //           groupChatItem: publicsList,
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     emit(
  //       ChatItemsGroupMembersError(
  //         errorMessage: e.toString().contains(':')
  //             ? e.toString().split(':')[1]
  //             : e.toString(),
  //       ),
  //     );
  //   }
  // }

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

        // emit(
        //   ChatItemsPrivateChatsLoaded(
        //     userChatItems: privatesList,
        //   ),
        // );
        add(
          ChatItemsGetPrivateChatsEvent(
            token: event.token,
          ),
        );
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
    ChatItemsEditProfileUser event,
    Emitter<ChatItemsState> emit,
  ) async {
    emit(ChatItemsLoading());

    try {
      User response = await APIService().editUser(
        token: event.token,
        displayName: event.displayName,
        profileImage: event.profileImage,
      );

      emit(
        ChatItemsEditProfileLoaded(user: response),
      );

      box.delete('userName');
      box.delete('userID');
      box.delete('userMobile');
      box.delete('profileImage');
      box.delete('userType');

      box.put('userName', response.displayName);
      box.put('userID', response.id);
      box.put('userMobile', response.mobileNumber);
      // box.put(response.profileImage ?? '', 'profileImage');
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

  // FutureOr<void> _editGroupProfile(
  //   ChatItemsEditProfileGroup event,
  //   Emitter<ChatItemsState> emit,
  // ) async {
  //   emit(ChatItemsLoading());

  //   try {
  //     GroupChatItemDTO response = await APIService().editGroupProfile(
  //       token: event.token,
  //       groupID: event.groupID,
  //       groupName: event.groupName,
  //       profileImage: event.profileImage,
  //     );

  //     emit(
  //       ChatItemsEditProfileLoaded(group: response),
  //     );
  //   } catch (e) {
  //     emit(
  //       ChatItemsError(
  //         errorMessage: e.toString().contains(':') ? e.toString().split(':')[1] : e.toString(),
  //       ),
  // );
  // }
  // }
}
