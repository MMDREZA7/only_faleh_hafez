import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:faleh_hafez/Service/APIService.dart';
import 'package:faleh_hafez/application/authentiction/authentication_bloc.dart';
import 'package:faleh_hafez/domain/models/group_chat_dto.dart';
import 'package:faleh_hafez/domain/models/group_member.dart';
import 'package:faleh_hafez/domain/models/user.dart';
import 'package:faleh_hafez/domain/models/user_chat_dto.dart';
import 'package:flutter/foundation.dart';

part 'chat_items_event.dart';
part 'chat_items_state.dart';

class ChatItemsBloc extends Bloc<ChatItemsEvent, ChatItemsState> {
  ChatItemsBloc() : super(ChatItemsInitial()) {
    on<ChatItemsGetPrivateChatsEvent>(_fetchPrivateChats);
    on<ChatItemsGetPublicChatsEvent>(_fetchPublicChats);
    on<ChatItemsGetGroupMembersEvent>(_getGroupMembers);
    on<ChatItemsAddNewMemberToGroupEvent>(_addNewMember);
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

      emit(ChatItemsPrivateChatsLoaded(userChatItems: response));
    } catch (e) {
      emit(
        ChatItemsError(errorMessage: e.toString().split(':')[1]),
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

      print("Response: $response");

      emit(ChatItemsPublicChatsLoaded(groupChatItem: response));
    } catch (e) {
      emit(
        ChatItemsError(
          errorMessage: e.toString().split(':')[1],
        ),
      );
    }
  }

  FutureOr<void> _getGroupMembers(
    ChatItemsGetGroupMembersEvent event,
    Emitter<ChatItemsState> emit,
  ) async {
    emit(ChatItemsGroupMembersLoading());

    try {
      final response = await APIService().getGroupMembers(
        token: event.token,
        groupID: event.groupID,
      );

      if (response.isEmpty) {
        emit(ChatItemsEmpty());
        return;
      }

      emit(
        ChatItemsGroupMembersLoaded(
          groupMembers: response,
        ),
      );
    } catch (e) {
      emit(
        ChatItemsError(
          errorMessage: e.toString().split(':')[1],
        ),
      );
    }
  }

  // FutureOr<void> _addNewMember(
  //   ChatItemsAddNewMemberToGroupEvent event,
  //   Emitter<ChatItemsState> emit,
  // ) async {
  //   try {
  //     // Fetch user ID
  //     final userID = await APIService().getUserID(
  //       token: event.token,
  //       mobileNumber: event.mobileNumber,
  //     );

  //     emit(ChatItemsGroupMembersLoading());

  //     if (state is ChatItemsGroupMembersLoaded) {
  //       final updatedMembers = List<GroupMember>.from(
  //         (state as ChatItemsGroupMembersLoaded).groupMember,
  //       )..add(
  //           GroupMember(
  //             id: userID,
  //             mobileNumber: event.mobileNumber,
  //             userName: '',
  //             type: groupMemberConvertToEnum[event.role]!,
  //           ),
  //         );

  //       emit(ChatItemsGroupMembersLoaded(groupMember: updatedMembers));
  //     }

  //     await APIService().addUserToGroup(
  //       token: event.token,
  //       groupID: event.groupID,
  //       role: event.role,
  //       userID: userID,
  //     );

  //     add(ChatItemsGetGroupMembersEvent(
  //       token: event.token,
  //       groupID: event.groupID,
  //     ));
  //   } catch (e) {
  //     emit(
  //       ChatItemsError(
  //         errorMessage: e.toString(),
  //       ),
  //     );
  //   }
  // }

  FutureOr<void> _addNewMember(
    ChatItemsAddNewMemberToGroupEvent event,
    Emitter<ChatItemsState> emit,
  ) async {
    emit(ChatItemsGroupMembersLoading());

    try {
      String userID = await APIService().getUserID(
        token: event.token,
        mobileNumber: event.mobileNumber,
      );

      List<GroupMember> response = await APIService().addUserToGroup(
        token: event.token,
        groupID: event.groupID,
        role: event.role,
        userID: userID,
      );

      emit(
        ChatItemsGroupMembersLoaded(groupMembers: response),
      );
    } catch (e) {
      emit(
        ChatItemsGroupMembersError(
          errorMessage: e.toString().split(':')[1],
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

      box.put(response.displayName, 'userName');
      box.put(response.id, 'userID');
      box.put(response.mobileNumber, 'userMobile');
      box.put(response.profileImage, 'profileImage');
      box.put(userTypeConvertToJson[response.type], "userType");
    } catch (e) {
      emit(
        ChatItemsError(
          errorMessage: e.toString().split(':')[1],
        ),
      );
    }
  }
}
