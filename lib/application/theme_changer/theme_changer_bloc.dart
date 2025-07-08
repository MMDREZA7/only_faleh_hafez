import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:Faleh_Hafez/presentation/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';

part 'theme_changer_event.dart';
part 'theme_changer_state.dart';

ThemeData mainTheme = lightTheme;

class ThemeChangerBloc extends Bloc<ThemeChangerEvent, ThemeChangerState> {
  final _myBox = Hive.box('mybox');
  ThemeChangerBloc() : super(ThemeChangerInitial()) {
    on<FirstTimeToOpenApp>((event, emit) async {
      emit(ThemeChangerLoading());

      const Duration(seconds: 3);

      if (_myBox.isEmpty) {
        mainTheme = lightTheme;
        _myBox.put('theme', 'lightTheme');
      } else {
        var val = _myBox.get('theme');
        if (val == 'lightTheme') {
          mainTheme = lightTheme;
        } else {
          mainTheme = darkTheme;
        }
      }

      emit(ThemeChangerLoaded(theme: mainTheme));
    });

    // -----

    on<ChangeThemeEvent>((event, emit) async {
      emit(ThemeChangerLoading());

      var val = _myBox.get('theme');

      if (val == 'lightTheme') {
        mainTheme = darkTheme;
        _myBox.put('theme', 'darkTheme');
      } else {
        mainTheme = lightTheme;
        _myBox.put('theme', 'lightTheme');
      }

      emit(ThemeChangerLoaded(theme: mainTheme));
    });
  }
}
