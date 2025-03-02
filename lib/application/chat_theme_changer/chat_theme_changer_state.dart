part of 'chat_theme_changer_bloc.dart';

@immutable
sealed class ChatThemeChangerState {
  final ThemeData theme;

  const ChatThemeChangerState({
    required this.theme,
  });
}

final class ChatThemeChangerInitial extends ChatThemeChangerState {
  const ChatThemeChangerInitial({
    required super.theme,
  });
}

final class ChatThemeChangerLoading extends ChatThemeChangerState {
  const ChatThemeChangerLoading({
    required super.theme,
  });
}

final class ChatThemeChangerLoaded extends ChatThemeChangerState {
  const ChatThemeChangerLoaded({
    required super.theme,
  });
}
