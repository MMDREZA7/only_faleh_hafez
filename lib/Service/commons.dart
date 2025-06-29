import 'package:encrypt/encrypt.dart';

class Commons {
  // static final key = Key.fromUtf8('8fBzT7wqLxP3d91vKcLuKKaA0HsRgVnm');
  static final iv = IV.fromBase64("nlLGHIZALl+dvnjVnNktGA==");

  static String addSalt(String input, String salt) => '$input$salt';
  static String addPepper(String input, String pepper) => '$input$pepper';
}
