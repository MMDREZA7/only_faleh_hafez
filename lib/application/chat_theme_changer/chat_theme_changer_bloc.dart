import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';

import '../../presentation/themes/theme.dart';

part 'chat_theme_changer_event.dart';
part 'chat_theme_changer_state.dart';

ThemeData mainTheme = lightChatTheme;

class ChatThemeChangerBloc
    extends Bloc<ChatThemeChangerEvent, ChatThemeChangerState> {
  final _myBox = Hive.box('mybox');
  ChatThemeChangerBloc()
      : super(ChatThemeChangerInitial(theme: darkChatTheme)) {
    on<ChangeChatPageTheme>((event, emit) async {
      final current = _myBox.get('chatTheme', defaultValue: 'darkChatTheme');

      if (current == 'lightChatTheme') {
        mainTheme = darkChatTheme;
        await _myBox.put('chatTheme', 'darkChatTheme');
      } else {
        mainTheme = lightChatTheme;
        await _myBox.put('chatTheme', 'lightChatTheme');
      }

      emit(ChatThemeChangerLoaded(theme: mainTheme));
    });

    on<FirstTimeOpenChat>((event, emit) async {
      final savedTheme = _myBox.get('chatTheme');

      if (savedTheme == null) {
        await _myBox.put('chatTheme', 'darkChatTheme');
        mainTheme = darkChatTheme;
      } else if (savedTheme == 'lightChatTheme') {
        mainTheme = lightChatTheme;
      } else {
        mainTheme = darkChatTheme;
      }

      emit(ChatThemeChangerLoaded(theme: mainTheme));
    });
  }
}
