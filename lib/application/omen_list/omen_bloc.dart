import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:Faleh_Hafez/application/omen_list/omens.dart';
import 'package:Faleh_Hafez/domain/models/omen/omen_dto.dart';
import 'package:Faleh_Hafez/domain/models/omen_model.dart';
import 'package:flutter/material.dart';
import 'package:persian/persian.dart';

part 'omen_event.dart';
part 'omen_state.dart';

class OmenBloc extends Bloc<OmenEvent, OmenState> {
  List<OmenDTO> omensList = omens
      .map(
        (e) => OmenDTO(
          title: e["title"]!,
          ghazal: e["ghazal"]!,
          tabirContent: e["tabir_content"]!,
        ),
      )
      .toList();

  OmenBloc() : super(OmenInitial()) {
    on<OmenGetRandomEvent>(_getOmen);
    on<OmenSearchedEvent>(_searchOmen);
    on<OmenSearchedPoemEvent>(_searchPoemOmen);
    on<OmenSearchedGetPoemsEvent>(_searchGetPoemOmen);
  }

  FutureOr<void> _getOmen(
    OmenGetRandomEvent event,
    Emitter<OmenState> emit,
  ) async {
    {
      emit(OmenLoading());

      final Random random = Random();
      final int randomIndex = random.nextInt(omensList.length);
      final selectedOmen = omensList[randomIndex];

      await Future.delayed(
        const Duration(
          seconds: 2,
        ),
      );

      emit(
        OmenLoaded(
          omen: Omen(
            poemText: selectedOmen.ghazal,
            omenText: selectedOmen.tabirContent,
          ),
        ),
      );
    }
  }

  FutureOr<void> _searchOmen(
    OmenSearchedEvent event,
    Emitter<OmenState> emit,
  ) async {
    emit(OmenLoading());

    var searchIndex = int.parse(event.searchIndex);

    final selectedOmen = omensList[searchIndex - 1];

    if (searchIndex < 0) {
      emit(
        OmenError(
          errorMessage: 'عدد باید بیشتر از 0 باشد',
        ),
      );
    }

    if (searchIndex > omensList.length - 1) {
      emit(
        OmenError(
          errorMessage:
              "عدد وارد شده از تعداد غزل ها بیشتر است مجددا امتحان کنین",
        ),
      );
    } else {
      emit(
        OmenLoaded(
          omen: Omen(
            poemText: selectedOmen.ghazal,
            omenText: selectedOmen.tabirContent,
          ),
        ),
      );
    }
  }

  FutureOr<void> _searchPoemOmen(
    OmenSearchedPoemEvent event,
    Emitter<OmenState> emit,
  ) async {
    emit(OmenLoading());

    String searchQuery = event.searchString.trim();
    if (searchQuery.isEmpty) {
      emit(OmenSearchingLoaded(omens: omensList));
      return;
    }

    String normalizedSearch = searchQuery.withPersianLetters();

    List<OmenDTO> omensExistsString = omensList.where((e) {
      String poemText = (e.ghazal ?? '').withPersianLetters();
      return poemText.contains(normalizedSearch);
    }).toList();

    await Future.delayed(const Duration(seconds: 3));

    if (omensExistsString.isEmpty) {
      emit(
        OmenError(errorMessage: "متاسفانه موردی پیدا نشد"),
      );
    } else {
      emit(OmenSearchingLoaded(omens: omensExistsString));
    }
  }

  FutureOr<void> _searchGetPoemOmen(
    OmenSearchedGetPoemsEvent event,
    Emitter<OmenState> emit,
  ) async {
    emit(OmenLoading());
    await Future.delayed(const Duration(seconds: 1));

    emit(OmenSearchingLoaded(omens: omensList));
  }
}
