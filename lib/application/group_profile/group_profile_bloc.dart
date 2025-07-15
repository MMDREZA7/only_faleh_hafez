import 'dart:async';
import 'package:Faleh_Hafez/Service/APIService.dart';
import 'package:Faleh_Hafez/domain/models/group_member.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'group_profile_event.dart';
part 'group_profile_state.dart';

class GroupProfileBloc extends Bloc<GroupProfileEvent, GroupProfileState> {
  String parseErrorMessage(Object e) {
    final message = parseErrorMessage(e);
    if (message.contains(':')) return message.split(':').last.trim();
    return message;
  }

  GroupProfileBloc() : super(GroupProfileInitial()) {
    on<GroupProfileGetGroupMembersEvent>(_getGroupMembers);
    on<GroupProfileAddNewMemberEvent>(_addNewMember);
    on<GroupProfileLeaveGroupEvent>(_leaveGroup);
    on<GroupProfileKickMember>(_kickGroup);
  }
  FutureOr<void> _getGroupMembers(
    GroupProfileGetGroupMembersEvent event,
    Emitter<GroupProfileState> emit,
  ) async {
    emit(GroupProfileLoading());
    try {
      final response = await APIService().getGroupMembers(
        token: event.token,
        groupID: event.groupID,
      );
      print(response);

      emit(
        GroupProfileLoaded(
          groupMembers: response,
        ),
      );
    } catch (e) {
      emit(
        GroupProfileError(
          errorMessage: parseErrorMessage(e),
        ),
      );
    }
  }

  FutureOr<void> _addNewMember(
    GroupProfileAddNewMemberEvent event,
    Emitter<GroupProfileState> emit,
  ) async {
    emit(GroupProfileLoading());

    try {
      String userID = await APIService().getUserID(
        token: event.token,
        mobileNumber: event.mobileNumber,
      );

      // List<GroupMember> response =
      // var response =
      await APIService().addUserToGroup(
        token: event.token,
        groupID: event.groupID,
        role: event.userRole,
        userID: userID,
      );

      add(
        GroupProfileGetGroupMembersEvent(
          token: event.token,
          groupID: event.groupID,
        ),
      );

      // emit(
      //   GroupProfileLoaded(
      //     groupMembers: response,
      //   ),
      // );
    } catch (e) {
      emit(
        GroupProfileError(
          errorMessage: parseErrorMessage(e),
        ),
      );
    }
  }

  FutureOr<void> _leaveGroup(
    GroupProfileLeaveGroupEvent event,
    Emitter<GroupProfileState> emit,
  ) async {
    emit(GroupProfileLoading());

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

      emit(
        GroupProfileLoaded(
          groupMembers: response,
        ),
      );
      // }
    } catch (e) {
      emit(
        GroupProfileError(
          errorMessage: parseErrorMessage(e),
        ),
      );
    }
  }

  FutureOr<void> _kickGroup(
    GroupProfileKickMember event,
    Emitter<GroupProfileState> emit,
  ) async {
    emit(GroupProfileLoading());
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

      emit(
        GroupProfileLoaded(
          groupMembers: response,
        ),
      );

      // add(
      //   GroupProfileGetGroupMembersEvent(
      //     token: event.token,
      //     groupID: event.groupID,
      //   ),
      // );
    } catch (e) {
      emit(
        GroupProfileError(
          errorMessage: parseErrorMessage(e),
        ),
      );
    }
  }
}
