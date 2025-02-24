part of 'omen_bloc.dart';

@immutable
sealed class OmenState {}

class OmenInitial extends OmenState {}

class OmenLoading extends OmenState {}

class OmenLoaded extends OmenState {
  final Omen omen;

  OmenLoaded({
    required this.omen,
  });
}

class OmenSearchingLoaded extends OmenState {
  final List<OmenDTO> omens;

  OmenSearchingLoaded({
    required this.omens,
  });
}

class OmenError extends OmenState {
  final String errorMessage;

  OmenError({
    required this.errorMessage,
  });
}
