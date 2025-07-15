import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: Colors.green.shade500,
    onPrimary: Colors.green.shade900,
    background: Colors.green.shade300,
    onBackground: Colors.green.shade900,
    secondary: Colors.green.shade900,
    onSecondary: Colors.green.shade500,
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: Colors.green.shade900,
    onPrimary: Colors.green.shade300,
    background: Colors.green.shade800,
    onBackground: Colors.green.shade400,
    secondary: Colors.green.shade600,
    onSecondary: Colors.green.shade900,
    primaryContainer: Colors.black54,
  ),
);

ThemeData secretPageTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade900,
    onBackground: Colors.grey.shade700,
    primary: Colors.grey.shade800,
    onPrimary: Colors.grey.shade300,
    secondary: Colors.grey.shade600,
    onSecondary: Colors.grey.shade400,
  ),
);

ThemeData lightChatTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.white,
    onBackground: Colors.grey.shade800,
    primary: Colors.grey.shade100,
    onPrimary: Colors.grey.shade900,
    secondary: Colors.grey.shade500,
    onSecondary: Colors.grey.shade800,
  ),
);

ThemeData darkChatTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.black,
    onBackground: Colors.grey.shade200,
    primary: Colors.grey.shade900,
    onPrimary: Colors.grey.shade100,
    secondary: Colors.grey.shade700,
    onSecondary: Colors.grey.shade200,
    // background: Colors.grey.shade800,
    // onBackground: Colors.grey.shade200,
    // primary: Colors.grey.shade900,
    // onPrimary: Colors.grey.shade100,
    // secondary: Colors.grey.shade700,
    // onSecondary: Colors.grey.shade200,
  ),
);

final ndlightChatTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFFFFFFF), // --primary
    onPrimary: Color(0xFF050E1F), // --text
    background: Color(0xFFEBF3FF), // --background
    onBackground: Color(0xFF050E1F), // --text
    secondary: Color(0xFFCFCFCF), // --secondary
    onSecondary: Color(0xFF050E1F), // --text
    error: Colors.red,
    onError: Colors.white,
    surface: Color(0xFFCFCFCF), // --secondary
    onSurface: Color(0xFF050E1F), // --text
  ),
);

final nddarkChatTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF000000), // --primary
    onPrimary: Color(0xFFE0E9FA), // --text
    background: Color(0xFF000814), // --background
    onBackground: Color(0xFFE0E9FA), // --text
    secondary: Color(0xFF303030), // --secondary
    onSecondary: Color(0xFFE0E9FA), // --text
    error: Colors.red,
    onError: Colors.white,
    surface: Color(0xFF303030),
    onSurface: Color(0xFFE0E9FA),
  ),
);
