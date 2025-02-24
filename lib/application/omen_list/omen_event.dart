part of 'omen_bloc.dart';

@immutable
sealed class OmenEvent {}

class OmenGetRandomEvent extends OmenEvent {}

class OmenSearchedEvent extends OmenEvent {
  final String searchIndex;

  OmenSearchedEvent({
    required this.searchIndex,
  });
}

class OmenSearchedGetPoemsEvent extends OmenEvent {}

class OmenSearchedPoemEvent extends OmenEvent {
  final String searchString;

  OmenSearchedPoemEvent({
    required this.searchString,
  });
}
