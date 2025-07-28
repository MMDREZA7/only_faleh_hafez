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

// ThemeData lightChatTheme = ThemeData(
//   brightness: Brightness.light,
//   colorScheme: ColorScheme.light(
//     background: Colors.white,
//     onBackground: Colors.grey.shade800,
//     primary: Colors.grey.shade100,
//     onPrimary: Colors.grey.shade900,
//     secondary: Colors.grey.shade500,
//     onSecondary: Colors.grey.shade800,
//   ),
// );

// ThemeData darkChatTheme = ThemeData(
//   brightness: Brightness.dark,
//   colorScheme: ColorScheme.dark(
//     background: Colors.black,
//     onBackground: Colors.grey.shade200,
//     primary: Colors.grey.shade900,
//     onPrimary: Colors.grey.shade100,
//     secondary: Colors.grey.shade700,
//     onSecondary: Colors.grey.shade200,
//   ),
// );

final ThemeData lightChatTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.white,
    onBackground: Colors.grey.shade800,
    primary: Colors.grey.shade100,
    onPrimary: Colors.grey.shade900,
    secondary: Colors.grey.shade500,
    onSecondary: Colors.grey.shade800,
    tertiary: Colors.green.shade500,
    onTertiary: Colors.white,
    error: Colors.red.shade500,
    onError: Colors.white,
  ),
);

final ThemeData darkChatTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.black,
    onBackground: Colors.grey.shade200,
    primary: Colors.grey.shade900,
    onPrimary: Colors.grey.shade100,
    secondary: Colors.grey.shade700,
    onSecondary: Colors.grey.shade200,
    tertiary: Colors.green.shade900,
    onTertiary: Colors.white,
    error: Colors.red.shade900,
    onError: Colors.white,
  ),
);


// final ndlightChatTheme = ThemeData(
//   brightness: Brightness.light,
//   colorScheme: const ColorScheme(
//     brightness: Brightness.light,
//     primary: Color(0xFFFFFFFF), // --primary
//     onPrimary: Color(0xFF050E1F), // --text
//     background: Color(0xFFEBF3FF), // --background
//     onBackground: Color(0xFF050E1F), // --text
//     secondary: Color(0xFFCFCFCF), // --secondary
//     onSecondary: Color(0xFF050E1F), // --text
//     error: Colors.red,
//     onError: Colors.white,
//     surface: Color(0xFFCFCFCF), // --secondary
//     onSurface: Color(0xFF050E1F), // --text
//   ),
// );

// final nddarkChatTheme = ThemeData(
//   brightness: Brightness.dark,
//   colorScheme: const ColorScheme(
//     brightness: Brightness.dark,
//     primary: Color(0xFF000000), // --primary
//     onPrimary: Color(0xFFE0E9FA), // --text
//     background: Color(0xFF000814), // --background
//     onBackground: Color(0xFFE0E9FA), // --text
//     secondary: Color(0xFF303030), // --secondary
//     onSecondary: Color(0xFFE0E9FA), // --text
//     error: Colors.red,
//     onError: Colors.white,
//     surface: Color(0xFF303030),
//     onSurface: Color(0xFFE0E9FA),
//   ),
// );

// final ThemeData lightChatTheme = ThemeData(
//   brightness: Brightness.light,
//   scaffoldBackgroundColor: Color(0xFFFFFFFF), // سفید کامل
//   appBarTheme: const AppBarTheme(
//     backgroundColor: Color(0xFFF8F8F8), // header رنگ روشن
//     elevation: 0.5,
//     iconTheme: IconThemeData(color: Colors.black87),
//     titleTextStyle: TextStyle(color: Colors.black87, fontSize: 18),
//   ),
//   floatingActionButtonTheme: const FloatingActionButtonThemeData(
//     backgroundColor: Color(0xFF0088cc), // آبی تلگرامی
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.all(Radius.circular(16)),
//     ),
//   ),
//   bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//     backgroundColor: Color(0xFFF5F5F5),
//     selectedItemColor: Color(0xFF0088cc),
//     unselectedItemColor: Colors.grey,
//     showUnselectedLabels: true,
//   ),
//   colorScheme: const ColorScheme.light(
//     background: Color(0xFFFFFFFF),
//     onBackground: Color(0xFF1C1C1E), // متن
//     primary: Color(0xFFe5e5ea), // پیام مخاطب
//     onPrimary: Color(0xFF000000),
//     secondary: Color(0xFF0088cc), // پیام خودت
//     onSecondary: Color(0xFFFFFFFF),
//     tertiary: Color(0xFF0088cc), // accent
//     onTertiary: Color(0xFFFFFFFF),
//   ),
//   textTheme: const TextTheme(
//     bodyMedium: TextStyle(color: Color(0xFF1C1C1E)),
//   ),
// );

// final ThemeData darkChatTheme = ThemeData(
//   brightness: Brightness.dark,
//   scaffoldBackgroundColor: Color(0xFF1c1c1e), // مشکی-سرمه‌ای
//   appBarTheme: const AppBarTheme(
//     backgroundColor: Color(0xFF2c2c2e),
//     elevation: 0.5,
//     iconTheme: IconThemeData(color: Colors.white),
//     titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
//   ),
//   floatingActionButtonTheme: const FloatingActionButtonThemeData(
//     backgroundColor: Color(0xFF29b6f6),
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.all(Radius.circular(16)),
//     ),
//   ),
//   bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//     backgroundColor: Color(0xFF2c2c2e),
//     selectedItemColor: Color(0xFF29b6f6),
//     unselectedItemColor: Colors.grey,
//     showUnselectedLabels: true,
//   ),
//   colorScheme: const ColorScheme.dark(
//     background: Color(0xFF1c1c1e),
//     onBackground: Color(0xFFEAEAEA),
//     primary: Color(0xFF3a3a3c), // پیام مخاطب
//     onPrimary: Color(0xFFEAEAEA),
//     secondary: Color(0xFF29b6f6), // پیام خودت
//     onSecondary: Color(0xFF000000),
//     tertiary: Color(0xFF29b6f6), // accent
//     onTertiary: Color(0xFF000000),
//   ),
//   textTheme: const TextTheme(
//     bodyMedium: TextStyle(color: Color(0xFFEAEAEA)),
//   ),
// );
