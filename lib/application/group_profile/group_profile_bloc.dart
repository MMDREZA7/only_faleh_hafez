import 'dart:async';

import 'package:Faleh_Hafez/Service/APIService.dart';
import 'package:Faleh_Hafez/domain/models/group_chat_dto.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'group_profile_event.dart';
part 'group_profile_state.dart';

class GroupProfileBloc extends Bloc<GroupProfileEvent, GroupProfileState> {
  GroupProfileBloc() : super(GroupProfileInitial()) {
    on<EditGroupProfileEvent>(_editGroupProfile);
  }

  FutureOr<void> _editGroupProfile(
    EditGroupProfileEvent event,
    Emitter<GroupProfileState> emit,
  ) async {
    emit(GroupProfileLoading());

    try {
      GroupChatItemDTO response = await APIService().editGroupProfile(
        token: event.token,
        groupID: event.groupID,
        groupName: event.groupName,
        profileImage: event.groupImage,
      );

      emit(
        GroupProfileLoaded(group: response),
      );
    } catch (e) {
      emit(
        GroupProfileError(
          errorMessage: e.toString().contains(':')
              ? e.toString().split(':')[1]
              : e.toString(),
        ),
      );
    }
  }
}
