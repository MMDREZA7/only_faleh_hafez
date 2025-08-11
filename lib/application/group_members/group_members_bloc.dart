import 'dart:async';
import 'package:Faleh_Hafez/Service/APIService.dart';
import 'package:Faleh_Hafez/Service/signal_r/SignalR_Service.dart';
import 'package:Faleh_Hafez/domain/models/group_member.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'group_members_event.dart';
part 'group_members_state.dart';

class GroupMembersBloc extends Bloc<GroupMembersEvent, GroupMembersState> {
  List<GroupMember> groupMembers = [];
  GroupMembersBloc() : super(GroupMembersInitial(groupMembers: [])) {
    on<GroupMembersGetGroupMembersEvent>(_getGroupMembers);
    on<GroupMembersAddNewMemberEvent>(_addNewMember);
    on<GroupMembersLeaveGroupEvent>(_leaveGroup);
    on<GroupMembersKickMember>(_kickGroup);
    on<GroupMembersEditProfilesEvent>(_editGroupMembers);
  }
  FutureOr<void> _getGroupMembers(
    GroupMembersGetGroupMembersEvent event,
    Emitter<GroupMembersState> emit,
  ) async {
    emit(GroupMembersLoading(groupMembers: []));
    try {
      final response = await APIService().getGroupMembers(
        token: event.token,
        groupID: event.groupID,
      );
      print(response);

      groupMembers = response;

      emit(
        GroupMembersLoaded(
          groupMembers: groupMembers,
        ),
      );
    } catch (e) {
      emit(
        GroupMembersError(
          groupMembers: groupMembers,
          errorMessage: e.toString().split(':')[1],
        ),
      );
    }
  }

  FutureOr<void> _addNewMember(
    GroupMembersAddNewMemberEvent event,
    Emitter<GroupMembersState> emit,
  ) async {
    emit(GroupMembersLoading(groupMembers: groupMembers));

    try {
      String userID = await APIService().getUserID(
        token: event.token,
        mobileNumber: event.mobileNumber,
      );

      // var response =
      List<GroupMember> response = await APIService().addUserToGroup(
        token: event.token,
        groupID: event.groupID,
        role: event.userRole,
        userID: userID,
      );

      // add(
      //   GroupMembersGetGroupMembersEvent(
      //     token: event.token,
      //     groupID: event.groupID,
      //   ),
      // );
      groupMembers = response;

      emit(
        GroupMembersLoaded(
          groupMembers: groupMembers,
        ),
      );
    } catch (e) {
      emit(
        GroupMembersError(
          errorMessage: e.toString().split(':')[1],
          groupMembers: groupMembers,
        ),
      );
    }
  }

  FutureOr<void> _leaveGroup(
    GroupMembersLeaveGroupEvent event,
    Emitter<GroupMembersState> emit,
  ) async {
    emit(GroupMembersLoading(groupMembers: groupMembers));

    try {
      // var index = publicsList.indexWhere(
      //     (element) => element.id == event.groupID,
      //   );

      var response = await APIService().leaveGroup(
        token: event.token,
        groupID: event.groupID,
      );

      // if (index != -1) {
      //   publicsList.removeAt(index);

      // add(
      //   GroupMembersGetGroupMembersEvent(
      //     token: event.token,
      //     groupID: event.groupID,
      //   ),
      // );

      groupMembers = response;
      emit(
        GroupMembersLoaded(
          groupMembers: groupMembers,
        ),
      );
    } catch (e) {
      emit(
        GroupMembersError(
          errorMessage: e.toString().split(':')[1],
          groupMembers: groupMembers,
        ),
      );
    }
  }

  FutureOr<void> _kickGroup(
    GroupMembersKickMember event,
    Emitter<GroupMembersState> emit,
  ) async {
    emit(GroupMembersLoading(groupMembers: groupMembers));
    try {
      final response = await APIService().kickMember(
        token: event.token,
        userID: event.userID,
        groupID: event.groupID,
      );

      // if (response.isEmpty) {
      //   emit(ChatItemsEmpty());
      //   return;
      // }

      groupMembers = response;

      emit(
        GroupMembersLoaded(
          groupMembers: groupMembers,
        ),
      );

      // add(
      //   GroupMembersGetGroupMembersEvent(
      //     token: event.token,
      //     groupID: event.groupID,
      //   ),
      // );
    } catch (e) {
      emit(
        GroupMembersError(
          errorMessage: e.toString().split(':')[1],
          groupMembers: groupMembers,
        ),
      );
    }
  }

  FutureOr<void> _editGroupMembers(
    GroupMembersEditProfilesEvent event,
    Emitter<GroupMembersState> emit,
  ) async {
    emit(GroupMembersLoading(groupMembers: groupMembers));
    try {
      emit(
        GroupMembersLoaded(
          groupMembers: groupMembers,
        ),
      );

      // add(
      //   GroupMembersGetGroupMembersEvent(
      //     token: event.token,
      //     groupID: event.groupID,
      //   ),
      // );
    } catch (e) {
      emit(
        GroupMembersError(
          errorMessage: e.toString().split(':')[1],
          groupMembers: groupMembers,
        ),
      );
    }
  }
}
